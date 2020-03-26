    .title "Module TestAssert, Key DAE74D07"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_TestAssert_DAE74D07
    .global _TestAssert_DAE74D07_s_bss
_TestAssert_DAE74D07_s_bss:
_TestAssert_s_bss:
    .space 4



    .align 4
    .section .init_TestAssert_DAE74D07

_TestAssert_init:
    entry a1, 16
    movi a2, _TestAssert_s_bss
    movi a3, 2
    s32i a3, a2, 0
    movi a3, 1
    bnez a3, 1$
    movi a6, 2
    movi a7, 7
    call4 _OberonSyscallHandler
1$:
    l32i a3, a2, 0
    movi a4, 0
    blt a4, a3, 2$
    movi a6, 2
    movi a7, 7
    call4 _OberonSyscallHandler
2$:
    l32i a3, a2, 0
    movi a4, 0
    bge a4, a3, 3$
    l32i a3, a2, 0
    movi a4, 5
    blt a4, a3, 4$
3$:
    l32i a3, a2, 0
    movi a4, 8
    bge a3, a4, 5$
    l32i a3, a2, 0
    movi a4, 3
    bne a3, a4, 6$
    movi a6, 2
    movi a7, 7
    call4 _OberonSyscallHandler
6$:
    movi a6, 1
    movi a7, 10
    call4 _Out_70D42FFB_p_Int
    retw
    .size _TestAssert_init, .-_TestAssert_init


    .align 4
    .section .init_table_TestAssert_DAE74D07
    .int _TestAssert_init

