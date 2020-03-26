    .title "Module Main, Key 6E69624D"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_strs_Main_6E69624D
_Main_data_strs:
    .byte 62,32,0,0,91,84,105,109,101,79,117,116,93,0,0,0

    .align 4
    .section .bss_Main_6E69624D
    .global _Main_6E69624D_s_bss
_Main_6E69624D_s_bss:
_Main_s_bss:
    .space 124



    .align 4
    .section .init_Main_6E69624D

_Main_init:
    entry a1, 16
    movi a2, _Main_s_bss
    call4 _Kernel_551E92D7_p_Init
1$:
    movi a3, 1
    beqz a3, 2$
    call4 _Out_70D42FFB_p_Ln
    movi a6, _Main_data_strs
    movi a7, 3
    call4 _Out_70D42FFB_p_String
    addi a6, a2, 120
    call4 _In_1F5D98E4_p_Int
    movi a3, _In_1F5D98E4_s_bss
    l8ui a3, a3, 4
    beqz a3, 3$
    l32i a6, a2, 120
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    j 4$
3$:
    movi a6, _Main_data_strs
    addi a6, a6, 4
    movi a7, 10
    call4 _Out_70D42FFB_p_String
4$:
    j 1$
2$:
    retw
    .size _Main_init, .-_Main_init


    .align 4
    .section .init_table_Main_6E69624D
    .int _Main_init

