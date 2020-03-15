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
    mov     a0,  sp
    addi    sp,  sp, -XT_STK_FRMSZ           /* allocate interrupt stack frame */
    s32i    a0,  sp, XT_STK_A1
    s32e    a0,  sp, -12                     /* for debug backtrace */
    rsr     a0,  PS                          /* save interruptee's PS */
    s32i    a0,  sp, XT_STK_PS
    rsr     a0,  EPC_1                       /* a12 = PC of 'syscall' */
    addi    a0,  a0, 3
    wsr     a0,  EPC_1                       /* a12 = PC of 'syscall' */
    s32i    a0,  sp, XT_STK_PC
    s32e    a0,  sp, -16                     /* for debug backtrace */
    s32i    a12, sp, XT_STK_A12              /* _xt_context_save requires A12- */
    s32i    a13, sp, XT_STK_A13              /* A13 to have already been saved */
    call0   _xt_context_save

    l32i    a2, sp, XT_STK_A2
    beqz    a2, 2f                          /* branch if syscall 0  */

    /* Save exc cause and vaddr into exception frame */
    rsr     a0, EXCCAUSE
    s32i    a0, sp, XT_STK_EXCCAUSE
    rsr     a0, EXCVADDR
    s32i    a0, sp, XT_STK_EXCVADDR

    /* _xt_context_save seems to save the current a0, but we need the interuptees a0. Fix this. */
    rsr     a0, EXCSAVE_1                   /* save interruptee's a0 */
    s32i    a0, sp, XT_STK_A0

    /*
        Create pseudo base save area. At this point, sp is still pointing to the
        allocated and filled exception stack frame.
    */

    /* Set up PS for C, reenable hi-pri interrupts, and clear EXCM. */
    movi    a0, PS_INTLEVEL(XCHAL_EXCM_LEVEL) | PS_UM | PS_WOE
    wsr     a0, PS

    l32i    a3, sp, XT_STK_A0               /* Copy pre-exception a0 (return address) */
    s32e    a3, sp, -16
    l32i    a3, sp, XT_STK_A1               /* Copy pre-exception a1 (stack pointer) */
    s32e    a3, sp, -12
    rsr     a0, EPC_1                       /* return address for debug backtrace */
    movi    a5, 0xC0000000                  /* constant with top 2 bits set (call size) */
    rsync                                   /* wait for WSR.PS to complete */
    or      a0, a0, a5                      /* set top 2 bits */
    addx2   a0, a5, a0                      /* clear top bit -- thus simulating call4 size */

    l32i    a6,  sp, XT_STK_EXCCAUSE        /* recover exc cause */
    l32i    a7,  sp, XT_STK_A3
    l32i    a8,  sp, XT_STK_A4

    call4   _OberonSyscallHandler

    /* Restore context and return */

    call0   _xt_context_restore
    l32i    a0, sp, XT_STK_PS               /* retrieve interruptee's PS */
    wsr     a0, PS
    l32i    a0, sp, XT_STK_PC               /* retrieve interruptee's PC */
    wsr     a0, EPC_1
    l32i    a0, sp, XT_STK_A0               /* retrieve interruptee's A0 */
    l32i    sp, sp, XT_STK_A1               /* remove exception frame    */
    rsync                                   /* ensure PS and EPC written */
    rfe                                     /* PS.EXCM is cleared        */

    /* Restore interruptee's context and return from exception. */
2:
    call0   _xt_context_restore
    addi    sp, sp, XT_STK_FRMSZ
    movi    a0, -1
    movnez  a2, a0, a2                      /* return -1 if not syscall 0 */
    rsr     a0, EXCSAVE_1
    rfe
