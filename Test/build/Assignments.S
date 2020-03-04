    .title "Module Assignments, Key CF545617"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_strs_Assignments_CF545617
    .global _Assignments_CF545617_s_data_strs
_Assignments_CF545617_s_data_strs:
_Assignments_s_str:
    .byte 84,104,105,115,32,105,115,32,97,32,116,101,115,116,0,0
    .byte 73,110,116,101,103,101,114,32,65,115,115,105,103,110,109,101
    .byte 110,116,0,0,82,101,97,108,32,65,115,115,105,103,110,109
    .byte 101,110,116,0,83,101,116,32,65,115,115,105,103,110,109,101
    .byte 110,116,0,0,65,114,114,97,121,32,65,115,115,105,103,110
    .byte 109,101,110,116,0,0,0,0,84,104,105,115,32,105,115,32
    .byte 97,32,116,101,115,116,0,0,83,116,114,105,110,103,32,65
    .byte 115,115,105,103,110,109,101,110,116,0,0,0,66,111,111,108
    .byte 101,97,110,32,97,115,115,105,103,110,109,101,110,116,0,0
    .byte 66,111,111,108,101,97,110,32,70,97,108,115,101,32,97,115
    .byte 115,105,103,110,109,101,110,116,0,0,0,0,77,101,109,111
    .byte 114,121,32,105,110,105,116,105,97,108,105,122,97,116,105,111
    .byte 110,0,0,0,82,101,99,111,114,100,32,105,110,116,101,103
    .byte 101,114,32,97,115,115,105,103,110,109,101,110,116,0,0,0
    .byte 82,101,99,111,114,100,32,98,111,111,108,101,97,110,32,97
    .byte 115,115,105,103,110,109,101,110,116,0,0,0

    .align 4
    .section .bss_Assignments_CF545617
    .global _Assignments_CF545617_s_bss
_Assignments_CF545617_s_bss:
_Assignments_s_bss:
    .space 88


    .align 4
    .section .text_Assignments_CF545617
    .global _Assignments_CF545617_s_text
_Assignments_CF545617_s_text:

_Run:
    entry a1, 16
    movi a2, 25
    s32i a2, a15, 0
    movi a2, 1077936128
    s32i a2, a15, 8
    movi a2, 14
    s32i a2, a15, 12
    movi a2, 31
    s32i a2, a15, 44
    addi a2, a15, 56
    movi a3, _Assignments_s_str
    addi a3, a3, 0
    movi a4, 4
    loop a4, 1f
    l32i a5, a3, 0
    addi a3, a3, 4
    s32i a5, a2, 0
    addi a2, a2, 4
1:
    movi a2, 3
    movi a3, 5
    bge a2, a3, 2f
    movi a2, 1
    j 3f
2:
    movi a2, 0
3:
    s8i a2, a15, 76
    l32i a2, a15, 0
    movi a3, 30
    bge a3, a2, 4f
    movi a2, 1
    j 5f
4:
    movi a2, 0
5:
    s8i a2, a15, 77
    movi a2, 21
    s32i a2, a15, 80
    movi a2, 1
    s8i a2, a15, 84
    l32i a6, a15, 0
    movi a7, 25
    bne a6, a7, 6f
    movi a6, 1
    j 7f
6:
    movi a6, 0
7:
    movi a7, _Assignments_s_str
    addi a7, a7, 16
    movi a8, 19
    call4 _Test_DC7FAF87_p_Assert
    movi a15, _Assignments_s_bss
    l32i a6, a15, 8
    movi a7, 1077936128
    bne a6, a7, 8f
    movi a6, 1
    j 9f
8:
    movi a6, 0
9:
    movi a7, _Assignments_s_str
    addi a7, a7, 36
    movi a8, 16
    call4 _Test_DC7FAF87_p_Assert
    movi a15, _Assignments_s_bss
    l32i a6, a15, 12
    movi a7, 14
    bne a6, a7, 10f
    movi a6, 1
    j 11f
10:
    movi a6, 0
11:
    movi a7, _Assignments_s_str
    addi a7, a7, 52
    movi a8, 15
    call4 _Test_DC7FAF87_p_Assert
    movi a15, _Assignments_s_bss
    l32i a6, a15, 44
    movi a7, 31
    bne a6, a7, 12f
    movi a6, 1
    j 13f
12:
    movi a6, 0
13:
    movi a7, _Assignments_s_str
    addi a7, a7, 68
    movi a8, 17
    call4 _Test_DC7FAF87_p_Assert
    movi a15, _Assignments_s_bss
    addi a8, a15, 56
    movi a9, _Assignments_s_str
    addi a9, a9, 88
14:
    l8ui a6, a8, 0
    addi a8, a8, 1
    l8ui a7, a9, 0
    addi a9, a9, 1
    bne a6, a7, 15f
    bnez a6, 14b
15:
    bne a6, a7, 16f
    movi a6, 1
    j 17f
16:
    movi a6, 0
17:
    movi a7, _Assignments_s_str
    addi a7, a7, 104
    movi a8, 18
    call4 _Test_DC7FAF87_p_Assert
    movi a15, _Assignments_s_bss
    l8ui a6, a15, 76
    movi a7, _Assignments_s_str
    addi a7, a7, 124
    movi a8, 19
    call4 _Test_DC7FAF87_p_Assert
    movi a15, _Assignments_s_bss
    l8ui a6, a15, 77
    bnez a6, 18f
    movi a6, 1
    j 19f
18:
    movi a6, 0
19:
    movi a7, _Assignments_s_str
    movi a8, 144
    add a7, a7, a8
    movi a8, 25
    call4 _Test_DC7FAF87_p_Assert
    movi a15, _Assignments_s_bss
    l32i a6, a15, 4
    movi a7, 0
    bne a6, a7, 20f
    movi a6, 1
    j 21f
20:
    movi a6, 0
21:
    movi a7, _Assignments_s_str
    movi a8, 172
    add a7, a7, a8
    movi a8, 22
    call4 _Test_DC7FAF87_p_Assert
    movi a15, _Assignments_s_bss
    l32i a6, a15, 80
    movi a7, 21
    bne a6, a7, 22f
    movi a6, 1
    j 23f
22:
    movi a6, 0
23:
    movi a7, _Assignments_s_str
    movi a8, 196
    add a7, a7, a8
    movi a8, 26
    call4 _Test_DC7FAF87_p_Assert
    movi a15, _Assignments_s_bss
    l8ui a6, a15, 84
    movi a7, _Assignments_s_str
    movi a8, 224
    add a7, a7, a8
    movi a8, 26
    call4 _Test_DC7FAF87_p_Assert
    movi a15, _Assignments_s_bss
    retw


    .align 4
    .section .init_Assignments_CF545617
    .global _Assignments_CF545617_s_init
_Assignments_CF545617_s_init:

_Assignments_init:
    entry a1, 16
    movi a15, _Assignments_s_bss
    retw


    .align 4
    .section .init_table_Assignments_CF545617
    .global _Assignments_CF545617_s_init_table
_Assignments_CF545617_s_init_table:
    .int .init_Assignments_CF545617

