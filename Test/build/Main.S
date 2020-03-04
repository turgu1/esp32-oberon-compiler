    .title "Module Main, Key 6E69624D"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_strs_Main_6E69624D
    .global _Main_6E69624D_s_data_strs
_Main_6E69624D_s_data_strs:
_Main_s_str:
    .byte 69,83,80,51,50,32,79,98,101,114,111,110,32,67,111,109
    .byte 112,105,108,101,114,32,84,101,115,116,32,83,117,105,116,101
    .byte 46,0,0,0,83,116,97,114,116,0,0,0

    .align 4
    .section .bss_Main_6E69624D
    .global _Main_6E69624D_s_bss
_Main_6E69624D_s_bss:
_Main_s_bss:
    .space 4



    .align 4
    .section .init_Main_6E69624D
    .global _Main_6E69624D_s_init
_Main_6E69624D_s_init:

_Main_init:
    entry a1, 16
    movi a15, _Main_s_bss
    movi a2, 0
1:
    movi a3, 10000000
    blt a3, a2, 2f
    s32i a2, a15, 0
    l32i a2, a15, 0
    addi a2, a2, 1
    j 1b
2:
    movi a6, _Main_s_str
    addi a6, a6, 0
    movi a7, 34
    call4 _Out_6D1528C7_p_String
    movi a15, _Main_s_bss
    call4 _Out_6D1528C7_p_Ln
    movi a15, _Main_s_bss
    movi a6, _Main_s_str
    addi a6, a6, 36
    movi a7, 6
    call4 _Out_6D1528C7_p_String
    movi a15, _Main_s_bss
    call4 _Out_6D1528C7_p_Ln
    movi a15, _Main_s_bss
3:
    movi a2, 1
    beqz a2, 4f
    movi a6, 90
    call4 _Out_6D1528C7_p_Char
    movi a15, _Main_s_bss
    movi a6, 108
    call4 _Out_6D1528C7_p_Char
    movi a15, _Main_s_bss
    movi a6, 111
    call4 _Out_6D1528C7_p_Char
    movi a15, _Main_s_bss
    movi a6, 111
    call4 _Out_6D1528C7_p_Char
    movi a15, _Main_s_bss
    movi a6, 98
    call4 _Out_6D1528C7_p_Char
    movi a15, _Main_s_bss
    movi a6, 111
    call4 _Out_6D1528C7_p_Char
    movi a15, _Main_s_bss
    movi a6, 111
    call4 _Out_6D1528C7_p_Char
    movi a15, _Main_s_bss
    movi a6, 107
    call4 _Out_6D1528C7_p_Char
    movi a15, _Main_s_bss
    call4 _Out_6D1528C7_p_Ln
    movi a15, _Main_s_bss
    movi a2, 0
5:
    movi a3, 10000000
    blt a3, a2, 6f
    s32i a2, a15, 0
    l32i a2, a15, 0
    addi a2, a2, 1
    j 5b
6:
    j 3b
4:
    retw


    .align 4
    .section .init_table_Main_6E69624D
    .global _Main_6E69624D_s_init_table
_Main_6E69624D_s_init_table:
    .int _Main_init

