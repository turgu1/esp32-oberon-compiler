    .title "Module Pattern3, Key A7E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern3_A7E2D4B5
    .global _Pattern3_A7E2D4B5_s_bss
_Pattern3_A7E2D4B5_s_bss:
_Pattern3_s_bss:
    .space 4456


    .section .init_Pattern3_A7E2D4B5
    .global _Pattern3_A7E2D4B5_s_init
_Pattern3_A7E2D4B5_s_init:

_Pattern3_init:
    entry a1, 0
    movi a15, _Pattern3_s_bss
    l32i a2, a15, 0
    slli a2, a2, 2
    add a2, a15, a2
    l32i a2, a2, 16
    s32i a2, a15, 8
    l32i a2, a15, 36
    s32i a2, a15, 12
    l32i a2, a15, 0
    movi a3, 40
    mull a2, a2, a3
    add a2, a15, a2
    l32i a3, a15, 4
    slli a3, a3, 2
    add a2, a2, a3
    movi a3, 2
    s32i a3, a2, 56
    l32i a2, a15, 0
    movi a3, 400
    mull a2, a2, a3
    add a2, a15, a2
    l32i a3, a15, 4
    movi a4, 40
    mull a3, a3, a4
    add a2, a2, a3
    l32i a3, a15, 8
    slli a3, a3, 2
    add a2, a2, a3
    movi a3, 3
    s32i a3, a2, 456
    movi a2, 6
    addmi a3, a15, 1792
    s32i a2, a3, 44
    retw

    .section .init_table_Pattern3_A7E2D4B5
    .global _Pattern3_A7E2D4B5_s_init_table
_Pattern3_A7E2D4B5_s_init_table:
    .int .init_Pattern3_A7E2D4B5

