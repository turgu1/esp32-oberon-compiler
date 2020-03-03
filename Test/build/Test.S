    .title "Module Test, Key DC7FAF87"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .str_Test_DC7FAF87, "4"
    .global _Test_DC7FAF87_s_str
_Test_DC7FAF87_s_str:
_Test_s_str:
    .byte 65,115,115,101,114,116,32,70,97,105,108,101,100,58,32,0
    .byte 84,101,115,116,32,67,111,109,112,108,101,116,101,100,46,32
    .byte 0,0,0,0,78,117,109,98,101,114,32,111,102,32,84,101
    .byte 115,116,32,80,114,111,99,101,100,117,114,101,115,58,32,0
    .byte 78,117,109,98,101,114,32,111,102,32,65,115,115,101,114,116
    .byte 105,111,110,32,109,97,100,101,58,32,0,0,84,104,101,114
    .byte 101,32,105,115,32,0,0,0,32,111,98,115,101,114,118,101
    .byte 100,46,0,0,78,111,32,69,114,114,111,114,33,32,76,105
    .byte 102,101,32,105,115,32,103,111,111,100,33,33,0,0,0,0

    .section .bss_Test_DC7FAF87, "4"
    .global _Test_DC7FAF87_s_bss
_Test_DC7FAF87_s_bss:
_Test_s_bss:
    .space 812

    .section .text_Test_DC7FAF87, "4"
    .global _Test_DC7FAF87_s_text
_Test_DC7FAF87_s_text:

    .global _Test_DC7FAF87_p_Register
    .type _Test_DC7FAF87_p_Register, @function
_Test_DC7FAF87_p_Register:
_Register:
    entry a1, 16
    s32i a2, a1, 0
    movi a15, _Test_s_bss
    call4 _Out_6D1528C7_p_Ln
    movi a15, _Test_s_bss
    l32i a2, a15, 8
    movi a3, 199
    bge a2, a3, 1f
    l32i a2, a15, 8
    slli a2, a2, 2
    add a2, a15, a2
    l32i a3, a1, 0
    s32i a3, a2, 12
    addi a2, a15, 8
    l32i a3, a2, 0
    addi a3, a3, 1
    s32i a3, a2, 0
1:
    retw

    .align 4
    .global _Test_DC7FAF87_p_Exec
    .type _Test_DC7FAF87_p_Exec, @function
_Test_DC7FAF87_p_Exec:
_Exec:
    entry a1, 16
    movi a15, _Test_s_bss
    movi a2, 0
    s32i a2, a15, 4
    movi a2, 0
2:
    l32i a3, a15, 8
    addi a3, a3, -1
    blt a3, a2, 3f
    s32i a2, a1, 0
    l32i a2, a1, 0
    slli a2, a2, 2
    add a2, a15, a2
    l32i a2, a2, 12
    l32i a6, a1, 0
    addi a1, a1, 4
    callx4 a6
    movi a15, _Test_s_bss
    l32i a2, a1, 0
    addi a2, a2, 1
    j 2b
3:
    l32i a2, a15, 4
    retw

    .align 4
    .global _Test_DC7FAF87_p_Assert
    .type _Test_DC7FAF87_p_Assert, @function
_Test_DC7FAF87_p_Assert:
_Assert:
    entry a1, 16
    s32i a2, a1, 0
    s32i a3, a1, 4
    s32i a4, a1, 8
    movi a15, _Test_s_bss
    addi a2, a15, 0
    l32i a3, a2, 0
    addi a3, a3, 1
    s32i a3, a2, 0
    l8ui a2, a1, 0
    bnez a2, 4f
    call4 _Out_6D1528C7_p_Ln
    movi a15, _Test_s_bss
    movi a6, _Test_s_str
    addi a6, a6, 0
    movi a7, 16
    call4 _Out_6D1528C7_p_String
    movi a15, _Test_s_bss
    l32i a6, a1, 4
    l32i a7, a1, 8
    call4 _Out_6D1528C7_p_String
    movi a15, _Test_s_bss
    addi a2, a15, 4
    l32i a3, a2, 0
    addi a3, a3, 1
    s32i a3, a2, 0
4:
    retw

    .align 4
    .global _Test_DC7FAF87_p_Completed
    .type _Test_DC7FAF87_p_Completed, @function
_Test_DC7FAF87_p_Completed:
_Completed:
    entry a1, 16
    movi a15, _Test_s_bss
    call4 _Out_6D1528C7_p_Ln
    movi a15, _Test_s_bss
    call4 _Out_6D1528C7_p_Ln
    movi a15, _Test_s_bss
    movi a6, _Test_s_str
    addi a6, a6, 16
    movi a7, 17
    call4 _Out_6D1528C7_p_String
    movi a15, _Test_s_bss
    call4 _Out_6D1528C7_p_Ln
    movi a15, _Test_s_bss
    movi a6, _Test_s_str
    addi a6, a6, 36
    movi a7, 28
    call4 _Out_6D1528C7_p_String
    movi a15, _Test_s_bss
    l32i a6, a15, 8
    movi a7, 0
    call4 _Out_6D1528C7_p_Int
    movi a15, _Test_s_bss
    call4 _Out_6D1528C7_p_Ln
    movi a15, _Test_s_bss
    movi a6, _Test_s_str
    addi a6, a6, 64
    movi a7, 27
    call4 _Out_6D1528C7_p_String
    movi a15, _Test_s_bss
    l32i a6, a15, 0
    movi a7, 0
    call4 _Out_6D1528C7_p_Int
    movi a15, _Test_s_bss
    l32i a2, a15, 4
    movi a3, 0
    bge a3, a2, 5f
    call4 _Out_6D1528C7_p_Ln
    movi a15, _Test_s_bss
    movi a6, _Test_s_str
    addi a6, a6, 92
    movi a7, 10
    call4 _Out_6D1528C7_p_String
    movi a15, _Test_s_bss
    l32i a6, a15, 4
    movi a7, 0
    call4 _Out_6D1528C7_p_Int
    movi a15, _Test_s_bss
    movi a6, _Test_s_str
    addi a6, a6, 104
    movi a7, 11
    call4 _Out_6D1528C7_p_String
    movi a15, _Test_s_bss
    j 6f
5:
    call4 _Out_6D1528C7_p_Ln
    movi a15, _Test_s_bss
    movi a6, _Test_s_str
    addi a6, a6, 116
    movi a7, 25
    call4 _Out_6D1528C7_p_String
    movi a15, _Test_s_bss
6:
    l32i a2, a15, 4
    retw

    .align 4
    .global _Test_DC7FAF87_p_Setup
    .type _Test_DC7FAF87_p_Setup, @function
_Test_DC7FAF87_p_Setup:
_Setup:
    entry a1, 16
    movi a15, _Test_s_bss
    movi a2, 0
    s32i a2, a15, 0
    movi a2, 0
    s32i a2, a15, 4
    movi a2, 0
    s32i a2, a15, 8
    retw

    .section .init_Test_DC7FAF87, "4"
    .global _Test_DC7FAF87_s_init
_Test_DC7FAF87_s_init:

_Test_init:
    entry a1, 16
    movi a15, _Test_s_bss
    call4 _Setup
    retw

    .section .init_table_Test_DC7FAF87, "4"
    .global _Test_DC7FAF87_s_init_table
_Test_DC7FAF87_s_init_table:
    .int .init_Test_DC7FAF87

