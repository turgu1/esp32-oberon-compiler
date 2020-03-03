    .title "Module Main, Key 6E69624D"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .str_Main_6E69624D, "4"
    .global _Main_6E69624D_s_str
_Main_6E69624D_s_str:
_Main_s_str:
    .byte 69,83,80,51,50,32,79,98,101,114,111,110,32,67,111,109
    .byte 112,105,108,101,114,32,84,101,115,116,32,83,117,105,116,101
    .byte 46,0,0,0,83,116,97,114,116,0,0,0,91,84,104,101
    .byte 32,69,110,100,93,0,0,0

    .section .bss_Main_6E69624D, "4"
    .global _Main_6E69624D_s_bss
_Main_6E69624D_s_bss:
_Main_s_bss:
    .space 4


    .section .init_Main_6E69624D, "4"
    .global _Main_6E69624D_s_init
_Main_6E69624D_s_init:

_Main_init:
    entry a1, 16
    movi a15, _Main_s_bss
    call4 _Out_6D1528C7_p_Setup
    movi a15, _Main_s_bss
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
    call4 _Test_DC7FAF87_p_Exec
    movi a15, _Main_s_bss
    mov a2, a6
    s32i a2, a15, 0
    call4 _Test_DC7FAF87_p_Completed
    movi a15, _Main_s_bss
    mov a2, a6
    s32i a2, a15, 0
    movi a6, _Main_s_str
    addi a6, a6, 44
    movi a7, 10
    call4 _Out_6D1528C7_p_String
    movi a15, _Main_s_bss
    call4 _Out_6D1528C7_p_Ln
    movi a15, _Main_s_bss
1:
    movi a2, 1
    beqz a2, 2f
    j 1b
2:
    retw

    .section .init_table_Main_6E69624D, "4"
    .global _Main_6E69624D_s_init_table
_Main_6E69624D_s_init_table:
    .int .init_Main_6E69624D

