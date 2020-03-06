    .title "Module Pattern12b, Key A32BBAE9"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern12b_A32BBAE9
    .global _Pattern12b_A32BBAE9_s_bss
_Pattern12b_A32BBAE9_s_bss:
_Pattern12b_s_bss:
    .space 4


    .align 4
    .section .text_Pattern12b_A32BBAE9
    .global _Pattern12b_A32BBAE9_s_text
_Pattern12b_A32BBAE9_s_text:

    .global _Pattern12b_A32BBAE9_p_Q
    .type _Pattern12b_A32BBAE9_p_Q, @function
_Pattern12b_A32BBAE9_p_Q:
_Q:
    entry a1, 16
    movi a15, _Pattern12b_s_bss
    movi a2, 1065353216
    s32i a2, a15, 0
    retw
    .size _Q, .-_Q


    .align 4
    .section .init_Pattern12b_A32BBAE9

_Pattern12b_init:
    entry a1, 16
    movi a15, _Pattern12b_s_bss
    retw
    .size _Pattern12b_init, .-_Pattern12b_init


    .align 4
    .section .init_table_Pattern12b_A32BBAE9
    .int _Pattern12b_init

