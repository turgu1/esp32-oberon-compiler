    .title "Module Pattern13, Key A5E3D3E8"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_types_Pattern13_A5E3D3E8
    .global _Pattern13_A5E3D3E8_s_data_types
_Pattern13_A5E3D3E8_s_data_types:
_Pattern13_s_types:
    .int 32,-1,-1,-1,-1,32,81926,-1
    .int -1,-1,32,81925,163841,-1,-1

    .align 4
    .section .bss_Pattern13_A5E3D3E8
    .global _Pattern13_A5E3D3E8_s_bss
_Pattern13_A5E3D3E8_s_bss:
_Pattern13_s_bss:
    .space 12



    .align 4
    .section .init_Pattern13_A5E3D3E8

_Pattern13_init:
    entry a1, 16
    movi a2, _Pattern13_s_bss
    l32i a3, a2, 0
    movi a4, 0
    s32i a4, a3, 0
    l32i a3, a2, 4
    movi a4, 1
    s32i a4, a3, 4
    l32i a3, a2, 0
    bnez a3, L1
    movi a3, _Pattern13_s_types
    addi a3, a3, 20
    j L2
L1:
    addi a3, a3, -8
    l32i a3, a3, 0
    l32i a3, a3, 4
L2:
    movi a4, _Pattern13_s_types
    addi a4, a4, 20
    movi a4, 3
    s32i a4, a3, 4
    l32i a3, a2, 0
    bnez a3, L3
    movi a3, _Pattern13_s_types
    addi a3, a3, 40
    j L4
L3:
    addi a3, a3, -8
    l32i a3, a3, 0
    l32i a3, a3, 8
L4:
    movi a4, _Pattern13_s_types
    addi a4, a4, 40
    movi a4, 5
    s32i a4, a3, 8
    l32i a3, a2, 4
    bnez a3, L5
    movi a3, _Pattern13_s_types
    addi a3, a3, 40
    j L6
L5:
    addi a3, a3, -8
    l32i a3, a3, 0
    l32i a3, a3, 8
L6:
    movi a4, _Pattern13_s_types
    addi a4, a4, 40
    bne a3, a4, L7
    l32i a3, a2, 8
    s32i a3, a2, 0
L7:
    retw
    .size _Pattern13_init, .-_Pattern13_init


    .align 4
    .section .init_table_Pattern13_A5E3D3E8
    .int _Pattern13_init

