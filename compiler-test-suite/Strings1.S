    .title "Module Strings1, Key 9AE5DCC1"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_strs_Strings1_9AE5DCC1
_Strings1_s_str:
    .byte 72,101,108,108,111,0,0,0,72,101,108,108,111,0,0,0
    .byte 72,101,108,108,111,0,0,0,72,101,108,108,111,0,0,0
    .byte 72,101,108,108,111,0,0,0,72,101,108,108,111,0,0,0
    .byte 72,101,108,108,111,0,0,0,72,101,108,108,111,0,0,0
    .byte 72,101,108,108,111,0,0,0,72,101,108,108,111,0,0,0
    .byte 72,101,108,108,111,0,0,0,72,101,108,108,111,0,0,0
    .byte 72,101,108,108,111,0,0,0,72,101,108,108,111,0,0,0
    .byte 72,101,108,108,111,0,0,0,72,101,108,108,111,0,0,0
    .byte 72,101,108,108,111,0,0,0,72,101,108,108,111,0,0,0
    .byte 72,101,108,108,111,0,0,0,72,101,108,108,111,0,0,0
    .byte 72,101,108,108,111,0,0,0,72,101,108,108,111,0,0,0
    .byte 72,101,108,108,111,0,0,0,72,101,108,108,111,0,0,0
    .byte 72,101,108,108,111,0,0,0,72,69,76,76,0,0,0,0
    .byte 72,69,76,76,79,0,0,0,72,101,108,108,111,0,0,0
    .byte 87,111,114,108,100,0,0,0,72,101,108,108,111,0,0,0
    .byte 0,0,0,0,90,65,66,0,65,66,67,0,65,66,67,0
    .byte 65,66,67,0,90,66,67,0,65,0,0,0,90,0,0,0

    .align 4
    .section .bss_Strings1_9AE5DCC1
    .global _Strings1_9AE5DCC1_s_bss
_Strings1_9AE5DCC1_s_bss:
_Strings1_s_bss:
    .space 88


    .align 4
    .section .text_Strings1_9AE5DCC1
    .global _Strings1_9AE5DCC1_s_text
_Strings1_9AE5DCC1_s_text:

_PrintMid:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Strings1_s_bss
    l32i a6, a1, 4
    srai a6, a6, 1
    l32i a7, a1, 0
    add a6, a7, a6
    l8ui a6, a6, 0
    call4 _Out_23908F94_p_Char
    retw
    .size _PrintMid, .-_PrintMid

    .align 4
_Cmp:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    s32i a4, a1, 8
    s32i a5, a1, 12
    movi a2, _Strings1_s_bss
    l32i a5, a1, 0
    l32i a6, a1, 8
1:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 2f
    bnez a3, 1b
2:
    bne a3, a4, 3f
    movi a6, -1
    movi a7, 0
    call4 _Out_23908F94_p_Int
3:
    l32i a5, a1, 8
    l32i a6, a1, 0
4:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 5f
    bnez a3, 4b
5:
    bne a3, a4, 6f
    movi a6, -2
    movi a7, 0
    call4 _Out_23908F94_p_Int
6:
    l32i a5, a1, 0
    l32i a6, a1, 8
7:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 8f
    bnez a3, 7b
8:
    beq a3, a4, 9f
    movi a6, -3
    movi a7, 0
    call4 _Out_23908F94_p_Int
9:
    l32i a5, a1, 8
    l32i a6, a1, 0
10:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 11f
    bnez a3, 10b
11:
    beq a3, a4, 12f
    movi a6, -4
    movi a7, 0
    call4 _Out_23908F94_p_Int
12:
    l32i a5, a1, 0
    l32i a6, a1, 8
13:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 14f
    bnez a3, 13b
14:
    bge a4, a3, 15f
    movi a6, -5
    movi a7, 0
    call4 _Out_23908F94_p_Int
15:
    l32i a5, a1, 8
    l32i a6, a1, 0
16:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 17f
    bnez a3, 16b
17:
    bge a4, a3, 18f
    movi a6, -6
    movi a7, 0
    call4 _Out_23908F94_p_Int
18:
    l32i a5, a1, 0
    l32i a6, a1, 8
19:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 20f
    bnez a3, 19b
20:
    bge a3, a4, 21f
    movi a6, -7
    movi a7, 0
    call4 _Out_23908F94_p_Int
21:
    l32i a5, a1, 8
    l32i a6, a1, 0
22:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 23f
    bnez a3, 22b
23:
    bge a3, a4, 24f
    movi a6, -8
    movi a7, 0
    call4 _Out_23908F94_p_Int
24:
    l32i a5, a1, 0
    l32i a6, a1, 8
25:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 26f
    bnez a3, 25b
26:
    blt a3, a4, 27f
    movi a6, -9
    movi a7, 0
    call4 _Out_23908F94_p_Int
27:
    l32i a5, a1, 8
    l32i a6, a1, 0
28:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 29f
    bnez a3, 28b
29:
    blt a3, a4, 30f
    movi a6, -10
    movi a7, 0
    call4 _Out_23908F94_p_Int
30:
    l32i a5, a1, 0
    l32i a6, a1, 8
31:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 32f
    bnez a3, 31b
32:
    blt a4, a3, 33f
    movi a6, -11
    movi a7, 0
    call4 _Out_23908F94_p_Int
33:
    l32i a5, a1, 8
    l32i a6, a1, 0
34:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 35f
    bnez a3, 34b
35:
    blt a4, a3, 36f
    movi a6, -12
    movi a7, 0
    call4 _Out_23908F94_p_Int
36:
    retw
    .size _Cmp, .-_Cmp


    .align 4
    .section .init_Strings1_9AE5DCC1

_Strings1_init:
    entry a1, 16
    movi a2, _Strings1_s_bss
    movi a6, _Strings1_s_str
    movi a7, 6
    call4 _PrintMid
    call4 _Out_23908F94_p_Ln
    mov a5, a2
    movi a6, _Strings1_s_str
    addi a6, a6, 8
37:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 38f
    bnez a3, 37b
38:
    bne a3, a4, 39f
    movi a6, 0
    movi a7, 0
    call4 _Out_23908F94_p_Int
39:
    movi a5, _Strings1_s_str
    addi a5, a5, 16
    movi a6, _Strings1_s_str
    addi a6, a6, 24
40:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 41f
    bnez a3, 40b
41:
    bne a3, a4, 42f
    movi a6, 1
    movi a7, 0
    call4 _Out_23908F94_p_Int
42:
    movi a5, _Strings1_s_str
    addi a5, a5, 32
    mov a6, a2
43:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 44f
    bnez a3, 43b
44:
    bne a3, a4, 45f
    movi a6, 2
    movi a7, 0
    call4 _Out_23908F94_p_Int
45:
    mov a5, a2
    movi a6, _Strings1_s_str
    addi a6, a6, 40
46:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 47f
    bnez a3, 46b
47:
    beq a3, a4, 48f
    movi a6, 3
    movi a7, 0
    call4 _Out_23908F94_p_Int
48:
    movi a5, _Strings1_s_str
    addi a5, a5, 48
    movi a6, _Strings1_s_str
    addi a6, a6, 56
49:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 50f
    bnez a3, 49b
50:
    beq a3, a4, 51f
    movi a6, 4
    movi a7, 0
    call4 _Out_23908F94_p_Int
51:
    movi a5, _Strings1_s_str
    addi a5, a5, 64
    mov a6, a2
52:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 53f
    bnez a3, 52b
53:
    beq a3, a4, 54f
    movi a6, 5
    movi a7, 0
    call4 _Out_23908F94_p_Int
54:
    mov a5, a2
    movi a6, _Strings1_s_str
    addi a6, a6, 72
55:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 56f
    bnez a3, 55b
56:
    bge a4, a3, 57f
    movi a6, 6
    movi a7, 0
    call4 _Out_23908F94_p_Int
57:
    movi a5, _Strings1_s_str
    addi a5, a5, 80
    movi a6, _Strings1_s_str
    addi a6, a6, 88
58:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 59f
    bnez a3, 58b
59:
    bge a4, a3, 60f
    movi a6, 7
    movi a7, 0
    call4 _Out_23908F94_p_Int
60:
    movi a5, _Strings1_s_str
    addi a5, a5, 96
    mov a6, a2
61:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 62f
    bnez a3, 61b
62:
    bge a4, a3, 63f
    movi a6, 8
    movi a7, 0
    call4 _Out_23908F94_p_Int
63:
    mov a5, a2
    movi a6, _Strings1_s_str
    addi a6, a6, 104
64:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 65f
    bnez a3, 64b
65:
    bge a3, a4, 66f
    movi a6, 9
    movi a7, 0
    call4 _Out_23908F94_p_Int
66:
    movi a5, _Strings1_s_str
    addi a5, a5, 112
    movi a6, _Strings1_s_str
    addi a6, a6, 120
67:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 68f
    bnez a3, 67b
68:
    bge a3, a4, 69f
    movi a6, 10
    movi a7, 0
    call4 _Out_23908F94_p_Int
69:
    movi a5, _Strings1_s_str
    movi a6, 128
    add a5, a5, a6
    mov a6, a2
70:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 71f
    bnez a3, 70b
71:
    bge a3, a4, 72f
    movi a6, 11
    movi a7, 0
    call4 _Out_23908F94_p_Int
72:
    mov a5, a2
    movi a6, _Strings1_s_str
    movi a7, 136
    add a6, a6, a7
73:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 74f
    bnez a3, 73b
74:
    blt a3, a4, 75f
    movi a6, 12
    movi a7, 0
    call4 _Out_23908F94_p_Int
75:
    movi a5, _Strings1_s_str
    movi a6, 144
    add a5, a5, a6
    movi a6, _Strings1_s_str
    movi a7, 152
    add a6, a6, a7
76:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 77f
    bnez a3, 76b
77:
    blt a3, a4, 78f
    movi a6, 13
    movi a7, 0
    call4 _Out_23908F94_p_Int
78:
    movi a5, _Strings1_s_str
    movi a6, 160
    add a5, a5, a6
    mov a6, a2
79:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 80f
    bnez a3, 79b
80:
    blt a3, a4, 81f
    movi a6, 14
    movi a7, 0
    call4 _Out_23908F94_p_Int
81:
    mov a5, a2
    movi a6, _Strings1_s_str
    movi a7, 168
    add a6, a6, a7
82:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 83f
    bnez a3, 82b
83:
    blt a4, a3, 84f
    movi a6, 15
    movi a7, 0
    call4 _Out_23908F94_p_Int
84:
    movi a5, _Strings1_s_str
    movi a6, 176
    add a5, a5, a6
    movi a6, _Strings1_s_str
    movi a7, 184
    add a6, a6, a7
85:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 86f
    bnez a3, 85b
86:
    blt a4, a3, 87f
    movi a6, 16
    movi a7, 0
    call4 _Out_23908F94_p_Int
87:
    movi a5, _Strings1_s_str
    movi a6, 192
    add a5, a5, a6
    mov a6, a2
88:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 89f
    bnez a3, 88b
89:
    blt a4, a3, 90f
    movi a6, 17
    movi a7, 0
    call4 _Out_23908F94_p_Int
90:
    movi a5, _Strings1_s_str
    movi a6, 200
    add a5, a5, a6
    movi a6, _Strings1_s_str
    movi a7, 208
    add a6, a6, a7
91:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 92f
    bnez a3, 91b
92:
    bne a3, a4, 93f
    movi a6, 18
    movi a7, 0
    call4 _Out_23908F94_p_Int
93:
    call4 _Out_23908F94_p_Ln
    mov a3, a2
    movi a4, _Strings1_s_str
    movi a5, 216
    add a4, a4, a5
    movi a5, 2
    loop a5, 94f
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
94:
    addi a3, a2, 12
    movi a4, _Strings1_s_str
    movi a5, 224
    add a4, a4, a5
    movi a5, 2
    loop a5, 95f
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
95:
    mov a6, a2
    movi a7, 10
    addi a8, a2, 12
    movi a9, 10
    call4 _Cmp
    call4 _Out_23908F94_p_Ln
    addi a3, a2, 12
    movi a4, _Strings1_s_str
    movi a5, 232
    add a4, a4, a5
    movi a5, 2
    loop a5, 96f
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
96:
    mov a6, a2
    movi a7, 10
    addi a8, a2, 12
    movi a9, 10
    call4 _Cmp
    call4 _Out_23908F94_p_Ln
    addi a3, a2, 12
    movi a4, _Strings1_s_str
    movi a5, 240
    add a4, a4, a5
    movi a5, 1
    loop a5, 97f
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
97:
    mov a6, a2
    movi a7, 10
    addi a8, a2, 12
    movi a9, 10
    call4 _Cmp
    call4 _Out_23908F94_p_Ln
    mov a6, a2
    movi a7, 10
    addi a8, a2, 24
    movi a9, 0
    call4 _Cmp
    call4 _Out_23908F94_p_Ln
    movi a3, 65
    s8i a3, a2, 24
    movi a3, 66
    s8i a3, a2, 25
    movi a3, 65
    s8i a3, a2, 28
    movi a3, 68
    s8i a3, a2, 29
    addi a6, a2, 24
    movi a7, 2
    addi a8, a2, 28
    movi a9, 2
    call4 _Cmp
    call4 _Out_23908F94_p_Ln
    movi a3, 65
    s8i a3, a2, 32
    l8ui a3, a2, 32
    movi a4, 65
    bne a3, a4, 98f
    movi a6, 1
    movi a7, 0
    call4 _Out_23908F94_p_Int
98:
    movi a3, 65
    l8ui a4, a2, 32
    bne a3, a4, 99f
    movi a6, 2
    movi a7, 0
    call4 _Out_23908F94_p_Int
99:
    movi a3, 65
    movi a4, 65
    bne a3, a4, 100f
    movi a6, 3
    movi a7, 0
    call4 _Out_23908F94_p_Int
100:
    addi a3, a2, 36
    movi a4, _Strings1_s_str
    movi a5, 244
    add a4, a4, a5
    movi a5, 1
    loop a5, 101f
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
101:
    movi a3, -1
    s32i a3, a2, 84
    movi a3, 1
    l32i a4, a2, 84
    add a3, a3, a4
    movi a4, 8
    mull a3, a3, a4
    add a3, a2, a3
    movi a6, _Strings1_s_str
    movi a7, 248
    add a6, a6, a7
    addi a3, a3, 36
102:
    l8ui a3, a6, 0
    addi a6, a6, 1
    l8ui a4, a3, 0
    addi a3, a3, 1
    bne a3, a4, 103f
    bnez a3, 102b
103:
    bge a3, a4, 104f
    movi a6, 4
    movi a7, 0
    call4 _Out_23908F94_p_Int
104:
    movi a3, 1
    l32i a4, a2, 84
    add a3, a3, a4
    movi a4, 8
    mull a3, a3, a4
    add a3, a2, a3
    addi a3, a3, 36
    movi a6, _Strings1_s_str
    movi a7, 252
    add a6, a6, a7
105:
    l8ui a3, a3, 0
    addi a3, a3, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 106f
    bnez a3, 105b
106:
    bge a4, a3, 107f
    movi a6, 5
    movi a7, 0
    call4 _Out_23908F94_p_Int
107:
    movi a5, _Strings1_s_str
    movi a6, 256
    add a5, a5, a6
    movi a6, _Strings1_s_str
    movi a7, 260
    add a6, a6, a7
108:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 109f
    bnez a3, 108b
109:
    bge a3, a4, 110f
    movi a6, 6
    movi a7, 0
    call4 _Out_23908F94_p_Int
110:
    movi a5, _Strings1_s_str
    movi a6, 264
    add a5, a5, a6
    movi a6, _Strings1_s_str
    movi a7, 268
    add a6, a6, a7
111:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 112f
    bnez a3, 111b
112:
    bge a3, a4, 113f
    movi a6, 7
    movi a7, 0
    call4 _Out_23908F94_p_Int
113:
    movi a3, 65
    s8i a3, a2, 76
    movi a3, 1
    l32i a4, a2, 84
    add a3, a3, a4
    add a3, a2, a3
    l8ui a3, a3, 76
    movi a4, 65
    bne a3, a4, 114f
    movi a6, 8
    movi a7, 0
    call4 _Out_23908F94_p_Int
114:
    movi a3, 1
    l32i a4, a2, 84
    add a3, a3, a4
    add a3, a2, a3
    movi a4, 65
    l8ui a3, a3, 76
    bne a4, 115f
    movi a6, 9
    movi a7, 0
    call4 _Out_23908F94_p_Int
115:
    movi a3, 65
    movi a4, 65
    bne a3, a4, 116f
    movi a6, 10
    movi a7, 0
    call4 _Out_23908F94_p_Int
116:
    retw
    .size _Strings1_init, .-_Strings1_init


    .align 4
    .section .init_table_Strings1_9AE5DCC1
    .int _Strings1_init

