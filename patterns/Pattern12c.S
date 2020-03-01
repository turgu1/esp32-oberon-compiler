    .title "Module Pattern12c, Key A6E336E7"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern12c_A6E336E7
    .global _Pattern12c_A6E336E7_s_bss
_Pattern12c_A6E336E7_s_bss:
_Pattern12c_s_bss:
    .space 8


    .section .init_Pattern12c_A6E336E7
    .global _Pattern12c_A6E336E7_s_init
_Pattern12c_A6E336E7_s_init:

_Pattern12c_init:
    entry a1, 0
    movi a15, _Pattern12c_s_bss
    movi a2, _Pattern12a_A42AACE9_s_bss
    l32i a2, a2, 0
    s32i a2, a15, 0
    movi a2, _Pattern12b_A32BBAE9_s_bss
    l32i a2, a2, 0
    s32i a2, a15, 4
    call4 _Pattern12b_A32BBAE9_p_Q
    movi a15, _Pattern12c_s_bss
    retw

    .section .init_table_Pattern12c_A6E336E7
    .global _Pattern12c_A6E336E7_s_init_table
_Pattern12c_A6E336E7_s_init_table:
    .int .init_Pattern12c_A6E336E7

