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
    .space 24

    .align 4
    .section .pointers_table_Pattern4_A8E2D4B5
    .int _Pattern4_s_bss + 0
    .int _Pattern4_s_bss + 4
    .int _Pattern4_s_bss + 20



    .align 4
    .section .init_Pattern4_A8E2D4B5

_Pattern4_init:
    entry a1, 16
    movi a2, _Pattern4_s_bss
    movi a3, 10
    s32i a3, a2, 8
    l32i a3, a2, 0
    movi a4, 6
    s32i a4, a3, 0
    l32i a3, a2, 0
    movi a4, 48
    s8i a4, a3, 11
    l32i a3, a2, 0
    l32i a4, a2, 4
    s32i a4, a3, 12
    l32i a3, a2, 0
    l32i a3, a3, 12
    movi a4, 0
    s32i a4, a3, 12
    retw
    .size _Pattern4_init, .-_Pattern4_init


    .align 4
    .section .init_table_Pattern4_A8E2D4B5
    .int _Pattern4_init

