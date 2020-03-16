    .title "Module Pattern21, Key A6E3D3E6"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_types_Pattern21_A6E3D3E6
    .global _Pattern21_A6E3D3E6_s_data_types
_Pattern21_A6E3D3E6_s_data_types:
_Pattern21_s_types:
    .int 32,-1,-1,-1,-1,32,81926,-1
    .int -1,-1,32,163845,-1,-1,-1,32
    .int 245765,-1,-1,-1

    .align 4
    .section .bss_Pattern21_A6E3D3E6
    .global _Pattern21_A6E3D3E6_s_bss
_Pattern21_A6E3D3E6_s_bss:
_Pattern21_s_bss:
    .space 4



    .align 4
    .section .init_Pattern21_A6E3D3E6

_Pattern21_init:
    entry a1, 16
    movi a2, _Pattern21_s_bss
    l32i a3, a2, 0
    movi a4, 0
    mov a5, 4
    beqz a3, L2
    addi a4, a3, -8
    l32i a4, a4, 0
    l32i a4, a4, 4
    movi a5, _Pattern21_s_types
    addi a5, a5, 20
L2:
    bne a3, a4, L3
    l32i a3, a2, 0
    movi a4, 10
    s32i a4, a3, 4
    j L1
L3:
    l32i a3, a2, 0
    movi a4, 0
    mov a5, 4
    beqz a3, L4
    addi a4, a3, -8
    l32i a4, a4, 0
    l32i a4, a4, 4
    movi a5, _Pattern21_s_types
    addi a5, a5, 40
L4:
    bne a3, a4, L5
    l32i a3, a2, 0
    movi a4, 1075838976
    s32i a4, a3, 4
    j L1
L5:
    l32i a3, a2, 0
    movi a4, 0
    mov a5, 4
    beqz a3, L6
    addi a4, a3, -8
    l32i a4, a4, 0
    l32i a4, a4, 4
    movi a5, _Pattern21_s_types
    addi a5, a5, 60
L6:
    bne a3, a4, L7
    l32i a3, a2, 0
    movi a4, 5
    s32i a4, a3, 4
    j L1
L7:
L1:
    retw
    .size _Pattern21_init, .-_Pattern21_init


    .align 4
    .section .init_table_Pattern21_A6E3D3E6
    .int _Pattern21_init

