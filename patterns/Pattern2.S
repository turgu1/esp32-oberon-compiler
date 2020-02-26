    .title "Module Pattern2, Key A6E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern2_A6E2D4B5
    .global _Pattern2_A6E2D4B5_s_bss
_Pattern2_A6E2D4B5_s_bss:
_Pattern2_s_bss:
    .space 36


    .section .init_Pattern2_A6E2D4B5
    .global _Pattern2_A6E2D4B5_s_init
_Pattern2_A6E2D4B5_s_init:

_Pattern2_init:
    entry a1, 0
    movi a2, _Pattern2_s_bss
    l32i a2, a2, 0
    movi a3, 1
    add a2, a2, a3
    movi a3, _Pattern2_s_bss
    l32i a3, a3, 0
    movi a4, 1
    sub a3, a3, a4
    mull a2, a2, a3
    movi a3, _Pattern2_s_bss
    s32i a2, a3, 0
    movi a2, _Pattern2_s_bss
    l32i a2, a2, 8
    movi a3, 17
    quos a2, a2, a3
    movi a3, _Pattern2_s_bss
    s32i a2, a3, 8
    movi a2, _Pattern2_s_bss
    l32i a2, a2, 12
    slli a2, a2, 3
    movi a3, _Pattern2_s_bss
    s32i a2, a3, 8
    movi a2, _Pattern2_s_bss
    l32i a2, a2, 12
    srai a2, a2, 1
    movi a3, _Pattern2_s_bss
    s32i a2, a3, 8
    movi a2, _Pattern2_s_bss
    l32i a2, a2, 12
    movi a3, 15
    and a2, a2, a3
    movi a3, _Pattern2_s_bss
    s32i a2, a3, 8
    movi a2, _Pattern2_s_bss
    l32i a2, a2, 16
    movi a3, 1
    wfr f0, a2
    wfr f1, a3
    sub.s f0, f0, f1
    rfr a2, f2
    movi a3, _Pattern2_s_bss
    l32i a3, a3, 20
    wfr f0, a3
    wfr f1, a2
    call __fdiv32
    rfr a2, f2
    wfr f0, a2
    neg.s f0, f0
    rfr a2, f0
    movi a3, _Pattern2_s_bss
    s32i a2, a3, 16
    movi a2, _Pattern2_s_bss
    l32i a2, a2, 28
    movi a3, _Pattern2_s_bss
    l32i a3, a3, 32
    and a2, a2, a3
    movi a3, _Pattern2_s_bss
    l32i a3, a3, 24
    or a2, a3, a2
    movi a3, _Pattern2_s_bss
    s32i a2, a3, 24
    retw

    .section .init_table_Pattern2_A6E2D4B5
    .global _Pattern2_A6E2D4B5_s_init_table
_Pattern2_A6E2D4B5_s_init_table:
    .int .init_Pattern2_A6E2D4B5

