    .title "Module Pattern4, Key A8E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_types_Pattern4_A8E2D4B5
    .global _Pattern4_A8E2D4B5_s_data_types
_Pattern4_A8E2D4B5_s_data_types:
_Pattern4_s_types:
    .int 32,-1,-1,-1,12,-1

    .align 4
    .section .bss_Pattern4_A8E2D4B5
    .global _Pattern4_A8E2D4B5_s_bss
_Pattern4_A8E2D4B5_s_bss:
_Pattern4_s_bss:
    .space 48



    .align 4
    .section .init_Pattern4_A8E2D4B5

_Pattern4_init:
    entry a1, 16
    movi a15, _Pattern4_s_bss
    movi a2, 10
    s32i a2, a15, 32
    l32i a2, a15, 24
    movi a3, 6
    s32i a3, a2, 0
    l32i a2, a15, 24
    movi a3, 48
    s8i a3, a2, 11
    l32i a2, a15, 24
    l32i a3, a15, 28
    s32i a3, a2, 12
    l32i a2, a15, 24
    l32i a2, a2, 12
    movi a3, 0
    s32i a3, a2, 12
    retw
    .size _Pattern4_init, .-_Pattern4_init


    .align 4
    .section .init_table_Pattern4_A8E2D4B5
    .int _Pattern4_init

