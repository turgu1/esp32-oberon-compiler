    .title "Module Pattern1, Key A5E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern1_A5E2D4B5
    .global _Pattern1_A5E2D4B5_s_bss
_Pattern1_A5E2D4B5_s_bss:
_Pattern1_s_bss:
    .space 16


    .section .init_Pattern1_A5E2D4B5
    .global _Pattern1_A5E2D4B5_s_init
_Pattern1_A5E2D4B5_s_init:

_Pattern1_init:
    entry a1, 0
    movi a2, 48
    movi a3, _Pattern1_s_bss
    s8i a2, a3, 0
    movi a2, 10
    movi a3, _Pattern1_s_bss
    s32i a2, a3, 4
    movi a2, 1
    movi a3, _Pattern1_s_bss
    s32i a2, a3, 8
    movi a2, 273
    movi a3, _Pattern1_s_bss
    s32i a2, a3, 12
    retw

    .section .init_table_Pattern1_A5E2D4B5
    .global _Pattern1_A5E2D4B5_s_init_table
_Pattern1_A5E2D4B5_s_init_table:
    .int .init_Pattern1_A5E2D4B5

