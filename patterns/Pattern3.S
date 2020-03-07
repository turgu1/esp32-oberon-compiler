    .title "Module Pattern3, Key A7E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern3_A7E2D4B5
    .global _Pattern3_A7E2D4B5_s_bss
_Pattern3_A7E2D4B5_s_bss:
_Pattern3_s_bss:
    .space 4456



    .align 4
    .section .init_Pattern3_A7E2D4B5

_Pattern3_init:
    entry a1, 16
    movi a2, _Pattern3_s_bss
    l32i a3, a2, 0
    slli a3, a3, 2
    add a3, a2, a3
    l32i a3, a3, 16
    s32i a3, a2, 8
    l32i a3, a2, 36
    s32i a3, a2, 12
    l32i a3, a2, 0
    movi a4, 40
    mull a3, a3, a4
    add a3, a2, a3
    l32i a4, a2, 4
    slli a4, a4, 2
    add a3, a3, a4
    movi a4, 2
    s32i a4, a3, 56
    l32i a3, a2, 0
    movi a4, 400
    mull a3, a3, a4
    add a3, a2, a3
    l32i a4, a2, 4
    movi a5, 40
    mull a4, a4, a5
    add a3, a3, a4
    l32i a4, a2, 8
    slli a4, a4, 2
    add a3, a3, a4
    movi a4, 3
    s32i a4, a3, 456
    movi a3, 6
    addmi a4, a2, 1792
    s32i a3, a4, 44
    retw
    .size _Pattern3_init, .-_Pattern3_init


    .align 4
    .section .init_table_Pattern3_A7E2D4B5
    .int _Pattern3_init

