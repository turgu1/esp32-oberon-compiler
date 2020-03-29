
    .title "Module Pattern12a, Key A42AACE9"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern12a_A42AACE9
    .global _Pattern12a_A42AACE9_s_bss
_Pattern12a_A42AACE9_s_bss:
_Pattern12a_s_bss:
    .space 4

# -->    1: MODULE Pattern12a;
# -->    2: VAR
# -->    3:   k*: INTEGER;
# -->    5:   PROCEDURE P*;
# -->    6:   BEGIN


    .align 4
    .section .text_Pattern12a_A42AACE9
    .global _Pattern12a_A42AACE9_s_text
_Pattern12a_A42AACE9_s_text:

    .global _Pattern12a_A42AACE9_p_P
    .type _Pattern12a_A42AACE9_p_P, @function
_Pattern12a_A42AACE9_p_P:    .type _P, @function
_P:
    entry a1, 16
    movi a2, _Pattern12a_s_bss
# -->    7:     k := 1
# -->    8:   END P;
    movi a3, 1
    s32i a3, a2, 0
    retw
    .size _P, .-_P

# -->    9: END Pattern12a.


    .align 4
    .section .init_Pattern12a_A42AACE9
_Pattern12a_init:
    entry a1, 16
    movi a2, _Pattern12a_s_bss
    retw
    .size _Pattern12a_init, .-_Pattern12a_init



    .align 4
    .section .init_table_Pattern12a_A42AACE9
    .int _Pattern12a_init
