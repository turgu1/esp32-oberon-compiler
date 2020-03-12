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
    addi    sp, sp, -XT_STK_FRMSZ           /* allocate interrupt stack frame */
    s32i    a12, sp, XT_STK_A12             /* _xt_context_save requires A12- */
    s32i    a13, sp, XT_STK_A13             /* A13 to have already been saved */
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

    /* Restore interruptee's context and return from exception. */
    call0   _xt_context_restore
    addi    sp, sp, XT_STK_FRMSZ
    movi    a0, -1
    movnez  a2, a0, a2                      /* return -1 if not syscall 0 */
    rsr     a0, EXCSAVE_1
    rfe