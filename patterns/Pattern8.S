    .title "Module Pattern8, Key ACE2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern8_ACE2D4B5
    .global _Pattern8_ACE2D4B5_s_bss
_Pattern8_ACE2D4B5_s_bss:
_Pattern8_s_bss:
    .space 4

1:
    .section .text_Pattern8_ACE2D4B5
    .global _Pattern8_ACE2D4B5_s_text
_Pattern8_ACE2D4B5_s_text:

_P:
    entry a1, 12
    s32i a2, a1, 0
    s32i a3, a1, 4
    l32i a2, a1, 0
    s32i a2, a1, 8
    l32i a2, a1, 8
    l32i a3, a1, 4
    s32i a2, a3, 0
    retw

    .section .init_Pattern8_ACE2D4B5
    .global _Pattern8_ACE2D4B5_s_init
_Pattern8_ACE2D4B5_s_init:

_Pattern8_init:
    entry a1, 0
    movi a6, 5
    movi a7, _Pattern8_s_bss
    addi a7, a7, 0
    call4 _P
    retw

    .section .init_table_Pattern8_ACE2D4B5
    .global _Pattern8_ACE2D4B5_s_init_table
_Pattern8_ACE2D4B5_s_init_table:
    .int .init_Pattern8_ACE2D4B5

