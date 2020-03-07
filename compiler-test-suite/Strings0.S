    .title "Module Strings0, Key 99E5DCC1"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_strs_Strings0_99E5DCC1
_Strings0_s_str:
    .byte 66,65,79,66,65,66,0,0,66,65,79,66,65,66,0,0
    .byte 66,65,79,66,65,66,0,0

    .align 4
    .section .bss_Strings0_99E5DCC1
    .global _Strings0_99E5DCC1_s_bss
_Strings0_99E5DCC1_s_bss:
_Strings0_s_bss:
    .space 28


    .align 4
    .section .text_Strings0_99E5DCC1
    .global _Strings0_99E5DCC1_s_text
_Strings0_99E5DCC1_s_text:

_P:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Strings0_s_bss
    l32i a3, a1, 0
    movi a4, _Strings0_s_str
    movi a5, 2
    loop a5, 1f
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
1:
    addi a3, a2, 16
    movi a4, _Strings0_s_str
    addi a4, a4, 8
    movi a5, 2
    loop a5, 2f
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
2:
    retw
    .size _P, .-_P

    .align 4
_Init:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Strings0_s_bss
    movi a3, 0
3:
    l32i a4, a1, 4
    addi a4, a4, -1
    blt a4, a3, 4f
    s32i a3, a1, 8
    l32i a3, a1, 8
    l32i a4, a1, 0
    add a3, a4, a3
    movi a4, 45
    s8i a4, a3, 0
    l32i a3, a1, 8
    addi a3, a3, 1
    j 3b
4:
    retw
    .size _Init, .-_Init

    .align 4
_Print:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Strings0_s_bss
    movi a3, 0
5:
    l32i a4, a1, 4
    addi a4, a4, -1
    blt a4, a3, 6f
    s32i a3, a1, 8
    l32i a3, a1, 8
    l32i a4, a1, 0
    add a3, a4, a3
    l8ui a3, a3, 0
    movi a4, 0
    bne a3, a4, 7f
    movi a6, 36
    call4 _Out_23908F94_p_Char
    j 8f
7:
    l32i a6, a1, 8
    l32i a7, a1, 0
    add a6, a7, a6
    l8ui a6, a6, 0
    call4 _Out_23908F94_p_Char
8:
    l32i a3, a1, 8
    addi a3, a3, 1
    j 5b
6:
    call4 _Out_23908F94_p_Ln
    retw
    .size _Print, .-_Print

    .align 4
_Print2:
    entry a1, 32
    s32i a2, a1, 0
    movi a2, _Strings0_s_bss
    movi a3, 0
9:
    movi a4, 9
    blt a4, a3, 10f
    s32i a3, a1, 4
    l32i a3, a1, 4
    l32i a4, a1, 0
    add a3, a4, a3
    l8ui a3, a3, 0
    movi a4, 0
    bne a3, a4, 11f
    movi a6, 36
    call4 _Out_23908F94_p_Char
    j 12f
11:
    l32i a6, a1, 4
    l32i a7, a1, 0
    add a6, a7, a6
    l8ui a6, a6, 0
    call4 _Out_23908F94_p_Char
12:
    l32i a3, a1, 4
    addi a3, a3, 1
    j 9b
10:
    call4 _Out_23908F94_p_Ln
    retw
    .size _Print2, .-_Print2


    .align 4
    .section .init_Strings0_99E5DCC1

_Strings0_init:
    entry a1, 16
    movi a2, _Strings0_s_bss
    addi a6, a2, 4
    movi a7, 10
    call4 _Init
    addi a3, a2, 4
    movi a4, _Strings0_s_str
    addi a4, a4, 16
    movi a5, 2
    loop a5, 13f
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
13:
    addi a6, a2, 4
    movi a7, 10
    call4 _Print
    movi a3, 67
    s8i a3, a2, 0
    l8ui a6, a2, 0
    call4 _Out_23908F94_p_Char
    movi a3, 67
    s8i a3, a2, 0
    l8ui a6, a2, 0
    call4 _Out_23908F94_p_Char
    call4 _Out_23908F94_p_Ln
    addi a6, a2, 4
    movi a7, 10
    call4 _P
    addi a6, a2, 4
    call4 _Print2
    retw
    .size _Strings0_init, .-_Strings0_init


    .align 4
    .section .init_table_Strings0_99E5DCC1
    .int _Strings0_init

