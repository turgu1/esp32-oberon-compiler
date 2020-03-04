    .title "Module Out, Key 6D1528C7"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_strs_Out_6D1528C7
    .global _Out_6D1528C7_s_data_strs
_Out_6D1528C7_s_data_strs:
_Out_s_str:
    .byte 32,32,48,0

    .align 4
    .section .bss_Out_6D1528C7
    .global _Out_6D1528C7_s_bss
_Out_6D1528C7_s_bss:
_Out_s_bss:
    .space 4


    .align 4
    .section .text_Out_6D1528C7
    .global _Out_6D1528C7_s_text
_Out_6D1528C7_s_text:

    .global _Out_6D1528C7_p_Open
    .type _Out_6D1528C7_p_Open, @function
_Out_6D1528C7_p_Open:
_Open:
    entry a1, 16
    movi a15, _Out_s_bss
    retw

    .align 4
    .global _Out_6D1528C7_p_Char
    .type _Out_6D1528C7_p_Char, @function
_Out_6D1528C7_p_Char:
_Char:
    entry a1, 16
    s32i a2, a1, 0
    movi a15, _Out_s_bss
    l8ui a2, a1, 0
    movi a3, 1072955392
    s32i a2, a3, 0
    retw

    .align 4
    .global _Out_6D1528C7_p_String
    .type _Out_6D1528C7_p_String, @function
_Out_6D1528C7_p_String:
_String:
    entry a1, 16
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a15, _Out_s_bss
    movi a2, 0
    s32i a2, a1, 8
1:
    l32i a2, a1, 4
    l32i a3, a1, 8
    bge a2, a3, 2f
    l32i a2, a1, 8
    l32i a3, a1, 0
    add a2, a3, a2
    l8ui a2, a2, 0
    movi a3, 0
    beq a2, a3, 2f
3:
    l32i a6, a1, 8
    l32i a7, a1, 0
    add a6, a7, a6
    l8ui a6, a6, 0
    call4 _Char
    addi a2, a1, 8
    l32i a3, a2, 0
    addi a3, a3, 1
    s32i a3, a2, 0
    j 1b
2:
    retw

    .align 4
    .global _Out_6D1528C7_p_Int
    .type _Out_6D1528C7_p_Int, @function
_Out_6D1528C7_p_Int:
_Int:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a15, _Out_s_bss
    movi a2, 0
    s32i a2, a1, 8
    l32i a2, a1, 0
    movi a3, 0
    bge a2, a3, 4f
    l32i a2, a1, 0
    neg a2, a2
    s32i a2, a1, 12
    addi a2, a1, 4
    l32i a3, a2, 0
    addi a3, a3, -1
    s32i a3, a2, 0
    j 5f
4:
    l32i a2, a1, 0
    s32i a2, a1, 12
5:
6:
    l32i a2, a1, 8
    add a2, a1, a2
    l32i a3, a1, 12
    movi a4, 10
    rems a3, a3, a4
    addi a3, a3, 48
    s8i a3, a2, 16
    l32i a2, a1, 12
    movi a3, 10
    quos a2, a2, a3
    s32i a2, a1, 12
    addi a2, a1, 8
    l32i a3, a2, 0
    addi a3, a3, 1
    s32i a3, a2, 0
    l32i a2, a1, 12
    movi a3, 0
    bne a2, a3, 6b
7:
    l32i a2, a1, 4
    l32i a3, a1, 8
    bge a3, a2, 8f
    movi a6, 32
    call4 _Char
    addi a2, a1, 4
    l32i a3, a2, 0
    addi a3, a3, -1
    s32i a3, a2, 0
    j 7b
8:
    l32i a2, a1, 0
    movi a3, 0
    bge a2, a3, 9f
    movi a6, 45
    call4 _Char
9:
10:
    addi a2, a1, 8
    l32i a3, a2, 0
    addi a3, a3, -1
    s32i a3, a2, 0
    l32i a6, a1, 8
    add a6, a1, a6
    l8ui a6, a6, 16
    call4 _Char
    l32i a2, a1, 8
    movi a3, 0
    bne a2, a3, 10b
    retw

    .align 4
    .global _Out_6D1528C7_p_Hex
    .type _Out_6D1528C7_p_Hex, @function
_Out_6D1528C7_p_Hex:
_Hex:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a15, _Out_s_bss
    movi a2, 0
    s32i a2, a1, 8
11:
    l32i a2, a1, 0
    movi a3, 15
    and a2, a2, a3
    s32i a2, a1, 12
    l32i a2, a1, 12
    movi a3, 10
    bge a2, a3, 12f
    l32i a2, a1, 8
    add a2, a1, a2
    l32i a3, a1, 12
    addi a3, a3, 48
    s8i a3, a2, 16
    j 13f
12:
    l32i a2, a1, 8
    add a2, a1, a2
    l32i a3, a1, 12
    addi a3, a3, 55
    s8i a3, a2, 16
13:
    l32i a2, a1, 0
    srai a2, a2, 4
    s32i a2, a1, 0
    addi a2, a1, 8
    l32i a3, a2, 0
    addi a3, a3, 1
    s32i a3, a2, 0
    l32i a2, a1, 8
    movi a3, 8
    bne a2, a3, 11b
14:
    l32i a2, a1, 4
    movi a3, 8
    bge a3, a2, 15f
    movi a6, 32
    call4 _Char
    addi a2, a1, 4
    l32i a3, a2, 0
    addi a3, a3, -1
    s32i a3, a2, 0
    j 14b
15:
16:
    addi a2, a1, 8
    l32i a3, a2, 0
    addi a3, a3, -1
    s32i a3, a2, 0
    l32i a6, a1, 8
    add a6, a1, a6
    l8ui a6, a6, 16
    call4 _Char
    l32i a2, a1, 8
    movi a3, 0
    bne a2, a3, 16b
    retw

    .align 4
_Ten:
    entry a1, 16
    s32i a2, a1, 0
    movi a2, 1065353216
    s32i a2, a1, 4
    movi a2, 1092616192
    s32i a2, a1, 8
17:
    l32i a2, a1, 0
    movi a3, 0
    bge a3, a2, 18f
    l32i a2, a1, 0
    movi a3, 1
    and a2, a2, a3
    beqz a2, 19f
    l32i a2, a1, 8
    l32i a3, a1, 4
    wfr f0, a2
    wfr f1, a3
    mul.s f0, f0, f1
    rfr a2, f2
    s32i a2, a1, 4
19:
    l32i a2, a1, 8
    l32i a3, a1, 8
    wfr f0, a2
    wfr f1, a3
    mul.s f0, f0, f1
    rfr a2, f2
    s32i a2, a1, 8
    l32i a2, a1, 0
    srai a2, a2, 1
    s32i a2, a1, 0
    j 17b
18:
    l32i a2, a1, 4
    retw

    .align 4
    .global _Out_6D1528C7_p_Real
    .type _Out_6D1528C7_p_Real, @function
_Out_6D1528C7_p_Real:
_Real:
    entry a1, 48
    s32i a2, a1, 0
    s32i a3, a1, 4
    s32i a4, a1, 8
    movi a15, _Out_s_bss
    l32i a2, a1, 0
    movi a3, 0
    bne a2, a3, 20f
    movi a6, _Out_s_str
    addi a6, a6, 0
    movi a7, 4
    call4 _String
    j 21f
20:
    l32i a2, a1, 0
    movi a3, 0
    bge a2, a3, 22f
    l32i a2, a1, 0
    wfr f0, a2
    neg.s f0, f0
    rfr a2, f0
    s32i a2, a1, 0
    movi a2, 1
    s8i a2, a1, 20
    j 23f
22:
    movi a2, 0
    s8i a2, a1, 20
23:
    l32i a2, a1, 8
    movi a3, 7
    bge a3, a2, 24f
    movi a2, 7
    s32i a2, a1, 8
24:
    l32i a6, a1, 8
    call4 _Ten
    mov a2, a6
    l32i a3, a1, 0
    wfr f0, a2
    wfr f1, a3
    mul.s f0, f0, f1
    rfr a2, f2
    s32i a2, a1, 0
    l32i a2, a1, 0
    movi a3, 1056964608
    wfr f0, a2
    wfr f1, a3
    add.s f0, f0, f1
    rfr a2, f2
    wfr f0, a2
    floor.s a2, f0, 0
    s32i a2, a1, 16
    movi a2, 0
    s32i a2, a1, 12
25:
    l32i a2, a1, 12
    add a2, a1, a2
    l32i a3, a1, 16
    movi a4, 10
    rems a3, a3, a4
    addi a3, a3, 48
    s8i a3, a2, 24
    l32i a2, a1, 16
    movi a3, 10
    quos a2, a2, a3
    s32i a2, a1, 16
    addi a2, a1, 12
    l32i a3, a2, 0
    addi a3, a3, 1
    s32i a3, a2, 0
    l32i a2, a1, 16
    movi a3, 0
    bne a2, a3, 25b
    movi a6, 32
    call4 _Char
26:
    l32i a2, a1, 12
    addi a2, a2, 3
    l32i a3, a1, 4
    bge a3, a2, 27f
    movi a6, 32
    call4 _Char
    addi a2, a1, 4
    l32i a3, a2, 0
    addi a3, a3, -1
    s32i a3, a2, 0
    j 26b
27:
    l8ui a2, a1, 20
    beqz a2, 28f
    movi a6, 45
    call4 _Char
    addi a2, a1, 4
    l32i a3, a2, 0
    addi a3, a3, -1
    s32i a3, a2, 0
    j 29f
28:
    movi a6, 32
    call4 _Char
29:
30:
    l32i a2, a1, 12
    l32i a3, a1, 8
    bge a3, a2, 31f
    addi a2, a1, 12
    l32i a3, a2, 0
    addi a3, a3, -1
    s32i a3, a2, 0
    l32i a6, a1, 12
    add a6, a1, a6
    l8ui a6, a6, 24
    call4 _Char
    j 30b
31:
    movi a6, 46
    call4 _Char
32:
    l32i a2, a1, 8
    l32i a3, a1, 12
    bge a3, a2, 33f
    addi a2, a1, 8
    l32i a3, a2, 0
    addi a3, a3, -1
    s32i a3, a2, 0
    movi a6, 48
    call4 _Char
    j 32b
33:
34:
    l32i a2, a1, 12
    movi a3, 0
    bge a3, a2, 35f
    addi a2, a1, 12
    l32i a3, a2, 0
    addi a3, a3, -1
    s32i a3, a2, 0
    l32i a6, a1, 12
    add a6, a1, a6
    l8ui a6, a6, 24
    call4 _Char
    j 34b
35:
21:
    retw

    .align 4
    .global _Out_6D1528C7_p_Ln
    .type _Out_6D1528C7_p_Ln, @function
_Out_6D1528C7_p_Ln:
_Ln:
    entry a1, 16
    movi a15, _Out_s_bss
    movi a6, 13
    call4 _Char
    movi a6, 10
    call4 _Char
    retw

    .align 4
    .global _Out_6D1528C7_p_SetBaudRate
    .type _Out_6D1528C7_p_SetBaudRate, @function
_Out_6D1528C7_p_SetBaudRate:
_SetBaudRate:
    entry a1, 16
    s32i a2, a1, 0
    movi a15, _Out_s_bss
    movi a2, 1072955412
    l32i a3, a1, 0
    s32i a3, a2, 0
    retw

    .align 4
    .global _Out_6D1528C7_p_Setup
    .type _Out_6D1528C7_p_Setup, @function
_Out_6D1528C7_p_Setup:
_Setup:
    entry a1, 16
    movi a15, _Out_s_bss
    movi a6, 694
    call4 _SetBaudRate
    retw


    .align 4
    .section .init_Out_6D1528C7
    .global _Out_6D1528C7_s_init
_Out_6D1528C7_s_init:

_Out_init:
    entry a1, 16
    movi a15, _Out_s_bss
    call4 _Setup
    retw


    .align 4
    .section .init_table_Out_6D1528C7
    .global _Out_6D1528C7_s_init_table
_Out_6D1528C7_s_init_table:
    .int _Out_init

