    .title "Module ArrayAssignment, Key 42C88989"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_types_ArrayAssignment_42C88989
    .global _ArrayAssignment_42C88989_s_data_types
_ArrayAssignment_42C88989_s_data_types:
_ArrayAssignment_s_types:
    .int 32,-1,-1,-1,-1

    .align 4
    .section .bss_ArrayAssignment_42C88989
    .global _ArrayAssignment_42C88989_s_bss
_ArrayAssignment_42C88989_s_bss:
_ArrayAssignment_s_bss:
    .space 1008


    .align 4
    .section .text_ArrayAssignment_42C88989
    .global _ArrayAssignment_42C88989_s_text
_ArrayAssignment_42C88989_s_text:

_localAssignment:
    entry a1, 1040
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _ArrayAssignment_s_bss
    movi a3, 5
    s32i a3, a1, 48
    addi a3, a1, 8
    addi a4, a1, 48
    movi a5, 2
    loop a5, L1
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L1:
    l32i a6, a1, 8
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    movi a3, 6
    s32i a3, a1, 8
    l32i a6, a1, 48
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    addi a3, a1, 8
    l32i a4, a1, 0
    movi a5, 2
    loop a5, L2
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L2:
    l32i a6, a1, 8
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    movi a3, 6
    s32i a3, a1, 8
    l32i a6, a1, 0
    l32i a6, a6, 0
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    l32i a3, a1, 0
    addi a4, a1, 8
    movi a5, 2
    loop a5, L3
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L3:
    movi a3, 8
    s32i a3, a1, 8
    l32i a6, a1, 0
    l32i a6, a6, 0
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    l32i a6, a1, 8
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    addi a3, a1, 80
    addi a4, a1, 48
    movi a5, 2
    loop a5, L4
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L4:
    l32i a6, a1, 80
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    movi a3, 10
    s32i a3, a1, 80
    l32i a6, a1, 48
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    addi a3, a1, 8
    addi a4, a1, 80
    movi a5, 2
    loop a5, L5
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L5:
    l32i a6, a1, 8
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    movi a3, 11
    s32i a3, a1, 72
    addi a3, a1, 64
    addi a4, a1, 72
    movi a5, 2
    loop a5, L6
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L6:
    l32i a6, a1, 64
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    movi a3, 12
    s32i a3, a1, 64
    l32i a6, a1, 72
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    l32i a6, a1, 64
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    movi a3, 15
    s32i a3, a1, 108
    addi a3, a1, 56
    addi a4, a1, 104
    movi a5, 12
    loop a5, L7
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L7:
    l32i a6, a1, 60
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    movi a3, 16
    s32i a3, a1, 60
    l32i a6, a1, 108
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    l32i a6, a1, 60
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    movi a3, 25
    s32i a3, a1, 780
    movi a3, 152
    add a3, a3, a1
    movi a4, 584
    add a4, a4, a1
    movi a5, 108
    loop a5, L8
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L8:
    l32i a6, a1, 348
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    movi a3, 26
    s32i a3, a1, 348
    l32i a6, a1, 780
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    l32i a6, a1, 348
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    addi a3, a1, 16
    l32i a4, a1, 4
    movi a5, 8
    loop a5, L9
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L9:
    l32i a6, a1, 20
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    movi a3, 66
    s32i a3, a1, 20
    l32i a6, a1, 4
    l32i a6, a6, 4
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    l32i a3, a1, 4
    addi a4, a1, 16
    movi a5, 8
    loop a5, L10
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L10:
    movi a3, 88
    s32i a3, a1, 20
    l32i a6, a1, 4
    l32i a6, a6, 4
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    l32i a6, a1, 20
    movi a7, 0
    call4 _Out_70D42FFB_p_Int
    retw
    .size _localAssignment, .-_localAssignment


    .align 4
    .section .init_ArrayAssignment_42C88989

_ArrayAssignment_init:
    entry a1, 16
    movi a2, _ArrayAssignment_s_bss
    movi a3, 7
    s32i a3, a2, 0
    movi a3, 77
    s32i a3, a2, 12
    mov a6, a2
    addi a7, a2, 8
    call4 _localAssignment
    mov a3, a2
    addi a4, a2, 40
    movi a5, 2
    loop a5, L11
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L11:
    addi a3, a2, 72
    addi a4, a2, 40
    movi a5, 2
    loop a5, L12
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L12:
    mov a3, a2
    addi a4, a2, 72
    movi a5, 2
    loop a5, L13
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L13:
    addi a3, a2, 56
    addi a4, a2, 64
    movi a5, 2
    loop a5, L14
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L14:
    addi a3, a2, 48
    addi a4, a2, 96
    movi a5, 12
    loop a5, L15
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L15:
    movi a4, 168
    add a3, a2, a4
    addi a4, a2, 40
    movi a5, 2
    loop a5, L16
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L16:
    mov a3, a2
    movi a5, 168
    add a4, a2, a5
    movi a5, 2
    loop a5, L17
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L17:
    movi a4, 152
    add a3, a2, a4
    movi a5, 160
    add a4, a2, a5
    movi a5, 2
    loop a5, L18
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L18:
    movi a4, 152
    add a3, a2, a4
    movi a5, 152
    add a4, a2, a5
    movi a5, 4
    loop a5, L19
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L19:
    movi a4, 152
    add a3, a2, a4
    movi a5, 584
    add a4, a2, a5
    movi a5, 4
    loop a5, L20
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L20:
    movi a4, 144
    add a3, a2, a4
    movi a5, 576
    add a4, a2, a5
    movi a5, 108
    loop a5, L21
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L21:
    retw
    .size _ArrayAssignment_init, .-_ArrayAssignment_init


    .align 4
    .section .init_table_ArrayAssignment_42C88989
    .int _ArrayAssignment_init

