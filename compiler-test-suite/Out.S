    .title "Module Out, Key 23908F94"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_strs_Out_23908F94
_Out_s_str:
    .byte 32,32,48,0

    .align 4
    .section .bss_Out_23908F94
    .global _Out_23908F94_s_bss
_Out_23908F94_s_bss:
_Out_s_bss:
    .space 4


    .align 4
    .section .text_Out_23908F94
    .global _Out_23908F94_s_text
_Out_23908F94_s_text:

    .global _Out_23908F94_p_Open
    .type _Out_23908F94_p_Open, @function
_Out_23908F94_p_Open:
_Open:
    entry a1, 16
    movi a2, _Out_s_bss
    retw
    .size _Open, .-_Open

    .align 4
_FifoCount:
    entry a1, 32
    movi a2, _Out_s_bss
    movi a3, 1072955420
    l32i a3, a3, 0
    s32i a3, a1, 4
    l32i a3, a1, 4
    srai a3, a3, 16
    movi a4, 255
    and a3, a3, a4
    s32i a3, a1, 0
    l32i a3, a1, 0
    retw
    .size _FifoCount, .-_FifoCount

    .align 4
    .global _Out_23908F94_p_Flush
    .type _Out_23908F94_p_Flush, @function
_Out_23908F94_p_Flush:
_Flush:
    entry a1, 16
    movi a2, _Out_s_bss
1:
    call4 _FifoCount
    mov a3, a7
    movi a4, 0
    bge a4, a3, 2f
    j 1b
2:
    retw
    .size _Flush, .-_Flush

    .align 4
    .global _Out_23908F94_p_Char
    .type _Out_23908F94_p_Char, @function
_Out_23908F94_p_Char:
_Char:
    entry a1, 32
    s32i a2, a1, 0
    movi a2, _Out_s_bss
3:
    call4 _FifoCount
    mov a3, a7
    movi a4, 120
    bge a4, a3, 4f
    j 3b
4:
    l8ui a3, a1, 0
    movi a4, 1072955392
    s32i a3, a4, 0
    retw
    .size _Char, .-_Char

    .align 4
    .global _Out_23908F94_p_String
    .type _Out_23908F94_p_String, @function
_Out_23908F94_p_String:
_String:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Out_s_bss
    movi a3, 0
    s32i a3, a1, 8
5:
    l32i a3, a1, 4
    l32i a4, a1, 8
    bge a4, a3, 6f
    l32i a3, a1, 8
    l32i a4, a1, 0
    add a3, a4, a3
    l8ui a3, a3, 0
    movi a4, 0
    beq a3, a4, 6f
7:
    l32i a6, a1, 8
    l32i a7, a1, 0
    add a6, a7, a6
    l8ui a6, a6, 0
    call4 _Char
    l32i a3, a1, 8
    addi a3, a3, 1
    s32i a3, a1, 8
    j 5b
6:
    retw
    .size _String, .-_String

    .align 4
    .global _Out_23908F94_p_Int
    .type _Out_23908F94_p_Int, @function
_Out_23908F94_p_Int:
_Int:
    entry a1, 48
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Out_s_bss
    movi a3, 0
    s32i a3, a1, 8
    l32i a3, a1, 0
    movi a4, 0
    bge a3, a4, 8f
    l32i a3, a1, 0
    neg a3, a3
    s32i a3, a1, 12
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j 9f
8:
    l32i a3, a1, 0
    s32i a3, a1, 12
9:
10:
    l32i a3, a1, 8
    add a3, a1, a3
    l32i a4, a1, 12
    movi a5, 10
    rems a4, a4, a5
    addi a4, a4, 48
    s8i a4, a3, 16
    l32i a3, a1, 12
    movi a4, 10
    quos a3, a3, a4
    s32i a3, a1, 12
    l32i a3, a1, 8
    addi a3, a3, 1
    s32i a3, a1, 8
    l32i a3, a1, 12
    movi a4, 0
    bne a3, a4, 10b
11:
    l32i a3, a1, 4
    l32i a4, a1, 8
    bge a4, a3, 12f
    movi a6, 32
    call4 _Char
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j 11b
12:
    l32i a3, a1, 0
    movi a4, 0
    bge a3, a4, 13f
    movi a6, 45
    call4 _Char
13:
14:
    l32i a3, a1, 8
    addi a3, a3, -1
    s32i a3, a1, 8
    l32i a6, a1, 8
    add a6, a1, a6
    l8ui a6, a6, 16
    call4 _Char
    l32i a3, a1, 8
    movi a4, 0
    bne a3, a4, 14b
    retw
    .size _Int, .-_Int

    .align 4
    .global _Out_23908F94_p_Hex
    .type _Out_23908F94_p_Hex, @function
_Out_23908F94_p_Hex:
_Hex:
    entry a1, 48
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Out_s_bss
    movi a3, 0
    s32i a3, a1, 8
15:
    l32i a3, a1, 0
    movi a4, 15
    and a3, a3, a4
    s32i a3, a1, 12
    l32i a3, a1, 12
    movi a4, 10
    bge a3, a4, 16f
    l32i a3, a1, 8
    add a3, a1, a3
    l32i a4, a1, 12
    addi a4, a4, 48
    s8i a4, a3, 16
    j 17f
16:
    l32i a3, a1, 8
    add a3, a1, a3
    l32i a4, a1, 12
    addi a4, a4, 55
    s8i a4, a3, 16
17:
    l32i a3, a1, 0
    srai a3, a3, 4
    s32i a3, a1, 0
    l32i a3, a1, 8
    addi a3, a3, 1
    s32i a3, a1, 8
    l32i a3, a1, 8
    movi a4, 8
    bne a3, a4, 15b
18:
    l32i a3, a1, 4
    movi a4, 8
    bge a4, a3, 19f
    movi a6, 32
    call4 _Char
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j 18b
19:
20:
    l32i a3, a1, 8
    addi a3, a3, -1
    s32i a3, a1, 8
    l32i a6, a1, 8
    add a6, a1, a6
    l8ui a6, a6, 16
    call4 _Char
    l32i a3, a1, 8
    movi a4, 0
    bne a3, a4, 20b
    retw
    .size _Hex, .-_Hex

    .align 4
_Ten:
    entry a1, 32
    s32i a2, a1, 0
    movi a2, _Out_s_bss
    movi a3, 1065353216
    s32i a3, a1, 4
    movi a3, 1092616192
    s32i a3, a1, 8
21:
    l32i a3, a1, 0
    movi a4, 0
    bge a4, a3, 22f
    l32i a3, a1, 0
    movi a4, 1
    and a3, a3, a4
    beqz a3, 23f
    l32i a3, a1, 8
    l32i a4, a1, 4
    wfr f0, a3
    wfr f1, a4
    mul.s f0, f0, f1
    rfr a3, f2
    s32i a3, a1, 4
23:
    l32i a3, a1, 8
    l32i a4, a1, 8
    wfr f0, a3
    wfr f1, a4
    mul.s f0, f0, f1
    rfr a3, f2
    s32i a3, a1, 8
    l32i a3, a1, 0
    srai a3, a3, 1
    s32i a3, a1, 0
    j 21b
22:
    l32i a3, a1, 4
    retw
    .size _Ten, .-_Ten

    .align 4
    .global _Out_23908F94_p_Real
    .type _Out_23908F94_p_Real, @function
_Out_23908F94_p_Real:
_Real:
    entry a1, 64
    s32i a2, a1, 0
    s32i a3, a1, 4
    s32i a4, a1, 8
    movi a2, _Out_s_bss
    l32i a3, a1, 0
    movi a4, 0
    bne a3, a4, 24f
    movi a6, _Out_s_str
    movi a7, 4
    call4 _String
    j 25f
24:
    l32i a3, a1, 0
    movi a4, 0
    bge a3, a4, 26f
    l32i a3, a1, 0
    wfr f0, a3
    neg.s f0, f0
    rfr a3, f0
    s32i a3, a1, 0
    movi a3, 1
    s8i a3, a1, 20
    j 27f
26:
    movi a3, 0
    s8i a3, a1, 20
27:
    l32i a3, a1, 8
    movi a4, 7
    bge a4, a3, 28f
    movi a3, 7
    s32i a3, a1, 8
28:
    l32i a6, a1, 8
    call4 _Ten
    mov a3, a7
    l32i a4, a1, 0
    wfr f0, a3
    wfr f1, a4
    mul.s f0, f0, f1
    rfr a3, f2
    s32i a3, a1, 0
    l32i a3, a1, 0
    movi a4, 1056964608
    wfr f0, a3
    wfr f1, a4
    add.s f0, f0, f1
    rfr a3, f2
    wfr f0, a3
    floor.s a3, f0, 0
    s32i a3, a1, 16
    movi a3, 0
    s32i a3, a1, 12
29:
    l32i a3, a1, 12
    add a3, a1, a3
    l32i a4, a1, 16
    movi a5, 10
    rems a4, a4, a5
    addi a4, a4, 48
    s8i a4, a3, 24
    l32i a3, a1, 16
    movi a4, 10
    quos a3, a3, a4
    s32i a3, a1, 16
    l32i a3, a1, 12
    addi a3, a3, 1
    s32i a3, a1, 12
    l32i a3, a1, 16
    movi a4, 0
    bne a3, a4, 29b
    movi a6, 32
    call4 _Char
30:
    l32i a3, a1, 12
    addi a3, a3, 3
    l32i a4, a1, 4
    bge a4, a3, 31f
    movi a6, 32
    call4 _Char
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j 30b
31:
    l8ui a3, a1, 20
    beqz a3, 32f
    movi a6, 45
    call4 _Char
    l32i a3, a1, 4
    addi a3, a3, -1
    s32i a3, a1, 4
    j 33f
32:
    movi a6, 32
    call4 _Char
33:
34:
    l32i a3, a1, 12
    l32i a4, a1, 8
    bge a4, a3, 35f
    l32i a3, a1, 12
    addi a3, a3, -1
    s32i a3, a1, 12
    l32i a6, a1, 12
    add a6, a1, a6
    l8ui a6, a6, 24
    call4 _Char
    j 34b
35:
    movi a6, 46
    call4 _Char
36:
    l32i a3, a1, 8
    l32i a4, a1, 12
    bge a4, a3, 37f
    l32i a3, a1, 8
    addi a3, a3, -1
    s32i a3, a1, 8
    movi a6, 48
    call4 _Char
    j 36b
37:
38:
    l32i a3, a1, 12
    movi a4, 0
    bge a4, a3, 39f
    l32i a3, a1, 12
    addi a3, a3, -1
    s32i a3, a1, 12
    l32i a6, a1, 12
    add a6, a1, a6
    l8ui a6, a6, 24
    call4 _Char
    j 38b
39:
25:
    retw
    .size _Real, .-_Real

    .align 4
    .global _Out_23908F94_p_Ln
    .type _Out_23908F94_p_Ln, @function
_Out_23908F94_p_Ln:
_Ln:
    entry a1, 16
    movi a2, _Out_s_bss
    movi a6, 13
    call4 _Char
    movi a6, 10
    call4 _Char
    retw
    .size _Ln, .-_Ln

    .align 4
    .global _Out_23908F94_p_SetBaudRate
    .type _Out_23908F94_p_SetBaudRate, @function
_Out_23908F94_p_SetBaudRate:
_SetBaudRate:
    entry a1, 32
    s32i a2, a1, 0
    movi a2, _Out_s_bss
    movi a3, 1072955412
    l32i a4, a1, 0
    s32i a4, a3, 0
    retw
    .size _SetBaudRate, .-_SetBaudRate

    .align 4
    .global _Out_23908F94_p_Setup
    .type _Out_23908F94_p_Setup, @function
_Out_23908F94_p_Setup:
_Setup:
    entry a1, 16
    movi a2, _Out_s_bss
    movi a6, 694
    call4 _SetBaudRate
    retw
    .size _Setup, .-_Setup


    .align 4
    .section .init_Out_23908F94

_Out_init:
    entry a1, 16
    movi a2, _Out_s_bss
    call4 _Setup
    retw
    .size _Out_init, .-_Out_init


    .align 4
    .section .init_table_Out_23908F94
    .int _Out_init

