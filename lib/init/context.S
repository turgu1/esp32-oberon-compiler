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

