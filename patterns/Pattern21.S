    .title "Module Pattern21, Key A6E3D3E6"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_types_Pattern21_A6E3D3E6
    .global _Pattern21_A6E3D3E6_s_data_types
_Pattern21_A6E3D3E6_s_data_types:
_Pattern21_s_types:
    .int 32
    .int -1
    .int -1
    .int -1
    .int -1
    .int 32
    .int _Pattern21_s_types+20
    .int -1
    .int -1
    .int -1
    .int 32
    .int _Pattern21_s_types+40
    .int -1
    .int -1
    .int -1
    .int 32
    .int _Pattern21_s_types+60
    .int -1
    .int -1
    .int -1

    .align 4
    .section .bss_Pattern21_A6E3D3E6
    .global _Pattern21_A6E3D3E6_s_bss
_Pattern21_A6E3D3E6_s_bss:
_Pattern21_s_bss:
    .space 4

    .align 4
    .section .pointers_table_Pattern21_A6E3D3E6
    .int _Pattern21_s_bss + 0



    .align 4
    .section .init_Pattern21_A6E3D3E6

_Pattern21_init:
    entry a1, 16
    movi a2, _Pattern21_s_bss
    l32i a3, a2, 0
    movi a4, 0
    beqz a3, 2$
    addi a3, a3, -8
    l32i a3, a3, 0
    l32i a3, a3, 4
    movi a4, _Pattern21_s_types
    addi a4, a4, 20
2$:
    bne a3, a4, 3$
    l32i a3, a2, 0
    movi a4, 10
    s32i a4, a3, 4
    j 1$
3$:
    l32i a3, a2, 0
    movi a4, 0
    beqz a3, 4$
    addi a3, a3, -8
    l32i a3, a3, 0
    l32i a3, a3, 4
    movi a4, _Pattern21_s_types
    addi a4, a4, 40
4$:
    bne a3, a4, 5$
    l32i a3, a2, 0
    movi a4, 1075838976
    s32i a4, a3, 4
    j 1$
5$:
    l32i a3, a2, 0
    movi a4, 0
    beqz a3, 6$
    addi a3, a3, -8
    l32i a3, a3, 0
    l32i a3, a3, 4
    movi a4, _Pattern21_s_types
    addi a4, a4, 60
6$:
    bne a3, a4, 7$
    l32i a3, a2, 0
    movi a4, 5
    s32i a4, a3, 4
    j 1$
7$:
1$:
    retw
    .size _Pattern21_init, .-_Pattern21_init


    .align 4
    .section .init_table_Pattern21_A6E3D3E6
    .int _Pattern21_init

