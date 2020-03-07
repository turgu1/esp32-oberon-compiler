    .title "Module Pattern12c, Key A6E336E7"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern12c_A6E336E7
    .global _Pattern12c_A6E336E7_s_bss
_Pattern12c_A6E336E7_s_bss:
_Pattern12c_s_bss:
    .space 8



    .align 4
    .section .init_Pattern12c_A6E336E7

_Pattern12c_init:
    entry a1, 16
    movi a2, _Pattern12c_s_bss
    movi a3, _Pattern12a_A42AACE9_s_bss
    l32i a3, a3, 0
    s32i a3, a2, 0
    movi a3, _Pattern12b_A32BBAE9_s_bss
    l32i a3, a3, 0
    s32i a3, a2, 4
    call4 _Pattern12b_A32BBAE9_p_Q
    retw
    .size _Pattern12c_init, .-_Pattern12c_init


    .align 4
    .section .init_table_Pattern12c_A6E336E7
    .int _Pattern12c_init

