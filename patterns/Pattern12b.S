    .title "Module Pattern12b, Key A32BBAE9"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern12b_A32BBAE9
    .global _Pattern12b_A32BBAE9_s_bss
_Pattern12b_A32BBAE9_s_bss:
_Pattern12b_s_bss:
    .space 4

# -->    1: MODULE Pattern12b;
# -->    2: VAR
# -->    3:   x*: REAL;
# -->    4:   
# -->    5:   PROCEDURE Q*;
# -->    6:   BEGIN

    .align 4
    .section .text_Pattern12b_A32BBAE9
    .global _Pattern12b_A32BBAE9_s_text
_Pattern12b_A32BBAE9_s_text:

    .global _Pattern12b_A32BBAE9_p_Q
    .type _Pattern12b_A32BBAE9_p_Q, @function
_Pattern12b_A32BBAE9_p_Q:
    .type _Q, @function
_Q:
    entry a1, 16
    movi a2, _Pattern12b_s_bss
# -->    7:     x := 1.0
# -->    8:   END Q;
    movi a3, 1065353216
    s32i a3, a2, 0
    retw
    .size _Q, .-_Q
# -->    9: END Pattern12b.


    .align 4
    .section .init_Pattern12b_A32BBAE9

_Pattern12b_init:
    entry a1, 16
    movi a2, _Pattern12b_s_bss
    retw
    .size _Pattern12b_init, .-_Pattern12b_init


    .align 4
    .section .init_table_Pattern12b_A32BBAE9
    .int _Pattern12b_init

