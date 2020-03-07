    .title "Module Pattern2, Key A6E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern2_A6E2D4B5
    .global _Pattern2_A6E2D4B5_s_bss
_Pattern2_A6E2D4B5_s_bss:
_Pattern2_s_bss:
    .space 36



    .align 4
    .section .init_Pattern2_A6E2D4B5

_Pattern2_init:
    entry a1, 16
    movi a2, _Pattern2_s_bss
    l32i a3, a2, 0
    addi a3, a3, 1
    l32i a4, a2, 0
    addi a4, a4, -1
    mull a3, a3, a4
    s32i a3, a2, 0
    l32i a3, a2, 8
    movi a4, 17
    quos a3, a3, a4
    s32i a3, a2, 8
    l32i a3, a2, 12
    slli a3, a3, 3
    s32i a3, a2, 8
    l32i a3, a2, 12
    srai a3, a3, 1
    s32i a3, a2, 8
    l32i a3, a2, 12
    movi a4, 15
    and a3, a3, a4
    s32i a3, a2, 8
    l32i a3, a2, 16
    movi a4, 1065353216
    wfr f0, a3
    wfr f1, a4
    sub.s f0, f0, f1
    rfr a3, f2
    l32i a4, a2, 20
    wfr f0, a4
    wfr f1, a3
    call __fdiv32
    rfr a3, f2
    wfr f0, a3
    neg.s f0, f0
    rfr a3, f0
    s32i a3, a2, 16
    l32i a3, a2, 28
    l32i a4, a2, 32
    and a3, a3, a4
    l32i a4, a2, 24
    or a3, a4, a3
    s32i a3, a2, 24
    retw
    .size _Pattern2_init, .-_Pattern2_init


    .align 4
    .section .init_table_Pattern2_A6E2D4B5
    .int _Pattern2_init

