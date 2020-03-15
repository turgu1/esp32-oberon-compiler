    #include "defs.S"

/* ---- stack ---- */

    .align 4
    .section .stack
    .space 16384

/* ---- application entry_point ---- */

    .section .entry.text

    j _call_start_cpu0

    .global _call_start_cpu0

    .align 4

_call_start_cpu0:

    movi a1, _tos              # Set Top of stack
    movi a0, 0                 # Initialize return adress to nothing
    addi a1, a1, -16           # stack frame initialization only
    addi a4, sp, 16            #     call4 can be done as 1st call level
    s32e a4, sp, -12

    call4 _stop_watchdog       # Disable both Watchdog
    call4 _set_160mhz          # Set CPU Speed to 160MHz

    movi a2, 2
    call0 _xt_syscall_exc


_init_end:
    j _init_end

/* ---- _stop_watchdog ---- */

    # Registers to disable both Watchdog
    .equ RTC_CNTL_WDTCONFIG0_REG, 0x3FF4808C
    .equ TIMG0_T0_WDTCONFIG0_REG, 0x3FF5F048

    .align 4

_stop_watchdog:
    entry a1, 16
    movi a2, 0
    movi a3, RTC_CNTL_WDTCONFIG0_REG
    s32i a2, a3, 0
    movi a3, TIMG0_T0_WDTCONFIG0_REG
    s32i a2, a3, 0
    retw

/* ---- _set_160mhz ---- */

    .equ RTC_CNTL_CLK_CONF_REG,  0x3FF48070
    .equ DPORT_CPU_PER_CONF_REG, 0x3ff0003C
    .equ CLKCONF,                0x08002210

    .align 4

_set_160mhz:
    entry a1, 16

    # Switch SoC clock source to PLL (instead of the default which is XTAl).
    # This switches the CPU (and APB) clock from 40MHz to 80MHz.
    movi a2, RTC_CNTL_CLK_CONF_REG
    movi a3, CLKCONF
    s32i a3, a2, 0

    # Switch CPU from 80MHz to 160MHz
    movi a2, DPORT_CPU_PER_CONF_REG
    movi a3, 1
    s32i a3, a2, 0

    retw 

/*

--------------------------------------------------------------------------------
Syscall Exception Handler (jumped to from User Exception Handler).
Syscall 0 is required to spill the register windows (no-op in Call 0 ABI).
Only syscall 0 is handled here. Other syscalls return -1 to caller in a2.
--------------------------------------------------------------------------------
*/

iram_function xt_syscall_exc

    /*
    Save necessary context and spill the register windows.
    PS.EXCM is still set and must remain set until after the spill.
    Reuse context save function though it saves more than necessary.
    For this reason, a full interrupt stack frame is allocated.
    */
    mov     a0, sp
    addi    sp, sp, -XT_STK_FRMSZ           /* allocate interrupt stack frame */
    s32i    a12, sp, XT_STK_A12             /* _xt_context_save requires A12- */
    s32i    a13, sp, XT_STK_A13             /* A13 to have already been saved */

    s32e    a0, sp, -12
    rsr     a0, PS                          /* save interruptee's PS */
    s32i    a0, sp, XT_STK_PS
    
    rsr     a0, EPC_1                       /* save interruptee's PC */
    s32i    a0, sp, XT_STK_PC
    s32e    a0, sp, -16                     /* for debug backtrace */
    call0   _xt_context_save

    /*
    Grab the interruptee's PC and skip over the 'syscall' instruction.
    If it's at the end of a zero-overhead loop and it's not on the last
    iteration, decrement loop counter and skip to beginning of loop.
    */
    rsr     a2, EPC_1                       /* a2 = PC of 'syscall' */
    addi    a3, a2, 3                       /* ++PC                 */
    rsr     a0, LEND                        /* if (PC == LEND       */
    bne     a3, a0, 1f
    rsr     a0, LCOUNT                      /*     && LCOUNT != 0)  */
    beqz    a0, 1f                          /* {                    */
    addi    a0, a0, -1                      /*   --LCOUNT           */
    rsr     a3, LBEG                        /*   PC = LBEG          */
    wsr     a0, LCOUNT                      /* }                    */
1:  wsr     a3, EPC_1                       /* update PC            */

    l32i    a2, sp, XT_STK_A2
    beqz    a2, 2f                          /* branch if syscall 0  */

    mov     a6, a2                          /* prepare parameters for user's handler */
    l32i    a7,  sp, XT_STK_A3
    l32i    a8,  sp, XT_STK_A4
    l32i    a9,  sp, XT_STK_A5
    l32i    a10, sp, XT_STK_A6

    call4   _OberonSyscallHandler

    s32i    a3, sp, XT_STK_A3               /* save return value */
    call0   _xt_context_restore
    addi    sp, sp, XT_STK_FRMSZ
    ret

    /* Restore interruptee's context and return from exception. */
2:
    call0   _xt_context_restore
    addi    sp, sp, XT_STK_FRMSZ
    movi    a0, -1
    movnez  a2, a0, a2                      /* return -1 if not syscall 0 */
    rsr     a0, EXCSAVE_1
    rfe

/*******************************************************************************

_xt_context_save

    !! MUST BE CALLED ONLY BY 'CALL0' INSTRUCTION !!

Saves all Xtensa processor state except PC, PS, A0, A1 (SP), A12, A13, in the
interrupt stack frame defined in xtensa_rtos.h.
Its counterpart is _xt_context_restore (which also restores A12, A13).

Caller is expected to have saved PC, PS, A0, A1 (SP), A12, A13 in the frame.
This function preserves A12 & A13 in order to provide the caller with 2 scratch 
regs that need not be saved over the call to this function. The choice of which
2 regs to provide is governed by xthal_window_spill_nw and xthal_save_extra_nw,
to avoid moving data more than necessary. Caller can assign regs accordingly.

Entry Conditions:
    A0  = Return address in caller.
    A1  = Stack pointer of interrupted thread or handler ("interruptee").
    Original A12, A13 have already been saved in the interrupt stack frame.
    Other processor state except PC, PS, A0, A1 (SP), A12, A13, is as at the 
    point of interruption.
    If windowed ABI, PS.EXCM = 1 (exceptions disabled).

Exit conditions:
    A0  = Return address in caller.
    A1  = Stack pointer of interrupted thread or handler ("interruptee").
    A12, A13 as at entry (preserved).
    If windowed ABI, PS.EXCM = 1 (exceptions disabled).

*******************************************************************************/

    .global _xt_context_save
    .type   _xt_context_save,@function
    .align  4
	.literal_position
    .align  4

_xt_context_save:
    s32i    a2,  sp, XT_STK_A2
    s32i    a3,  sp, XT_STK_A3
    s32i    a4,  sp, XT_STK_A4
    s32i    a5,  sp, XT_STK_A5
    s32i    a6,  sp, XT_STK_A6
    s32i    a7,  sp, XT_STK_A7
    s32i    a8,  sp, XT_STK_A8
    s32i    a9,  sp, XT_STK_A9
    s32i    a10, sp, XT_STK_A10
    s32i    a11, sp, XT_STK_A11
    s32i    a14, sp, XT_STK_A14
    s32i    a15, sp, XT_STK_A15

    rsr     a3,  SAR
    s32i    a3,  sp, XT_STK_SAR

    rsr     a3,  LBEG
    s32i    a3,  sp, XT_STK_LBEG
    rsr     a3,  LEND
    s32i    a3,  sp, XT_STK_LEND
    rsr     a3,  LCOUNT
    s32i    a3,  sp, XT_STK_LCOUNT
    mov     a9,  a0                     /* preserve ret addr */
    s32i    a12, sp, XT_STK_TMP0        /* temp. save stuff in stack frame */
    s32i    a13, sp, XT_STK_TMP1    
    s32i    a9,  sp, XT_STK_TMP2    

    l32i    a12, sp, XT_STK_A12         /* recover original a9,12,13 */
    l32i    a13, sp, XT_STK_A13
    l32i    a9,  sp, XT_STK_A9

#if 0
    #if XCHAL_EXTRA_SA_SIZE > 0
    addi    a2,  sp, XT_STK_EXTRA       /* where to save it */
    # if XCHAL_EXTRA_SA_ALIGN > 16
    movi    a3, -XCHAL_EXTRA_SA_ALIGN
    and     a2, a2, a3                  /* align dynamically >16 bytes */
    # endif
    call0   xthal_save_extra_nw         /* destroys a0,2,3,4,5 */
    #endif
#endif

    /* SPILL_ALL_WINDOWS macro requires window overflow exceptions to be enabled,
     * i.e. PS.EXCM cleared and PS.WOE set.
     * Since we are going to clear PS.EXCM, we also need to increase INTLEVEL
     * at least to XCHAL_EXCM_LEVEL. This matches that value of effective INTLEVEL
     * at entry (CINTLEVEL=max(PS.INTLEVEL, XCHAL_EXCM_LEVEL) when PS.EXCM is set.
     * Since WindowOverflow exceptions will trigger inside SPILL_ALL_WINDOWS,
     * need to save/restore EPC1 as well.
     */
    rsr     a2, PS                     /* to be restored after SPILL_ALL_WINDOWS */
    movi    a4, PS_INTLEVEL_MASK
    and     a3, a2, a4                 /* get the current INTLEVEL */
    bgeui   a3, XCHAL_EXCM_LEVEL, 1f   /* calculate max(INTLEVEL, XCHAL_EXCM_LEVEL) */
    movi    a3, XCHAL_EXCM_LEVEL
1:
    movi    a4, PS_UM | PS_WOE         /* clear EXCM, enable window overflow, set new INTLEVEL */
    or      a3, a3, a4
    wsr     a3, ps
    rsr     a4, EPC1                   /* to be restored after SPILL_ALL_WINDOWS */

    addi    sp,  sp, XT_STK_FRMSZ      /* go back to spill register region */
    SPILL_ALL_WINDOWS                  /* place the live register windows there */ 
    addi    sp,  sp, -XT_STK_FRMSZ     /* return the current stack pointer and proceed with context save*/

    wsr     a2, PS                     /* restore to the value at entry */
    rsync
    wsr     a4, EPC1                   /* likewise */

    l32i    a12, sp, XT_STK_TMP0       /* restore the temp saved registers */
    l32i    a13, sp, XT_STK_TMP1       /* our return address is there */
    l32i    a9,  sp, XT_STK_TMP2  
    mov     a0, a9                      /* retrieve ret addr */

    ret

/*******************************************************************************

_xt_context_restore

    !! MUST BE CALLED ONLY BY 'CALL0' INSTRUCTION !!

Restores all Xtensa processor state except PC, PS, A0, A1 (SP) (and in Call0
ABI, A14, A15 which are preserved by all interrupt handlers) from an interrupt 
stack frame defined in xtensa_rtos.h .
Its counterpart is _xt_context_save (whose caller saved A12, A13).

Caller is responsible to restore PC, PS, A0, A1 (SP).

Entry Conditions:
    A0  = Return address in caller.
    A1  = Stack pointer of interrupted thread or handler ("interruptee").

Exit conditions:
    A0  = Return address in caller.
    A1  = Stack pointer of interrupted thread or handler ("interruptee").
    Other processor state except PC, PS, A0, A1 (SP), is as at the point 
    of interruption.

*******************************************************************************/

    .global _xt_context_restore
    .type   _xt_context_restore,@function
    .align  4
	.literal_position
    .align  4
_xt_context_restore:

#if 0
    # To be revisited (GTur)
    #if XCHAL_EXTRA_SA_SIZE > 0
    /*  
    NOTE: Normally the xthal_restore_extra_nw macro only affects address
    registers a2-a5. It is theoretically possible for Xtensa processor
    designers to write TIE that causes more address registers to be
    affected, but it is generally unlikely. If that ever happens,
    more registers need to be saved/restored around this macro invocation.
    Here we only assume a13 is preserved.
    Future Xtensa tools releases might limit the regs that can be affected.
    */
    mov     a13, a0                     /* preserve ret addr */
    addi    a2,  sp, XT_STK_EXTRA       /* where to find it */
    # if XCHAL_EXTRA_SA_ALIGN > 16
    movi    a3, -XCHAL_EXTRA_SA_ALIGN
    and     a2, a2, a3                  /* align dynamically >16 bytes */
    # endif
    call0   xthal_restore_extra_nw      /* destroys a0,2,3,4,5 */
    mov     a0,  a13                    /* retrieve ret addr */
    #endif
#endif

    l32i    a2,  sp, XT_STK_LBEG
    l32i    a3,  sp, XT_STK_LEND
    wsr     a2,  LBEG
    l32i    a2,  sp, XT_STK_LCOUNT
    wsr     a3,  LEND
    wsr     a2,  LCOUNT

    l32i    a3,  sp, XT_STK_SAR
    l32i    a2,  sp, XT_STK_A2
    wsr     a3,  SAR
    l32i    a3,  sp, XT_STK_A3
    l32i    a4,  sp, XT_STK_A4
    l32i    a5,  sp, XT_STK_A5
    l32i    a6,  sp, XT_STK_A6
    l32i    a7,  sp, XT_STK_A7
    l32i    a8,  sp, XT_STK_A8
    l32i    a9,  sp, XT_STK_A9
    l32i    a10, sp, XT_STK_A10
    l32i    a11, sp, XT_STK_A11
    l32i    a12, sp, XT_STK_A12
    l32i    a13, sp, XT_STK_A13
    l32i    a14, sp, XT_STK_A14
    l32i    a15, sp, XT_STK_A15

    ret

interrupt_handler OberonSyscallHandler DEFAULT

    entry a1, 16
    movi a3, 0
    retw
