    .title "Module Pattern12a, Key A42AACE9"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern12a_A42AACE9
    .global _Pattern12a_A42AACE9_s_bss
_Pattern12a_A42AACE9_s_bss:
_Pattern12a_s_bss:
    .space 4

1:
    .section .text_Pattern12a_A42AACE9
    .global _Pattern12a_A42AACE9_s_text
_Pattern12a_A42AACE9_s_text:

    .global _Pattern12a_A42AACE9_p_P
    .type _Pattern12a_A42AACE9_p_P, @function
_Pattern12a_A42AACE9_p_P:
_P:
    entry a1, 0
    movi a15, _Pattern12a_s_bss
    movi a2, 1
    s32i a2, a15, 0
    retw

    .section .init_Pattern12a_A42AACE9
    .global _Pattern12a_A42AACE9_s_init
_Pattern12a_A42AACE9_s_init:

_Pattern12a_init:
    entry a1, 0
    movi a15, _Pattern12a_s_bss
    retw

    .section .init_table_Pattern12a_A42AACE9
    .global _Pattern12a_A42AACE9_s_init_table
_Pattern12a_A42AACE9_s_init_table:
    .int .init_Pattern12a_A42AACE9

