    .title "Module Pattern5, Key A9E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern5_A9E2D4B5
    .global _Pattern5_A9E2D4B5_s_bss
_Pattern5_A9E2D4B5_s_bss:
_Pattern5_s_bss:
    .space 8



    .align 4
    .section .init_Pattern5_A9E2D4B5

_Pattern5_init:
    entry a1, 16
    movi a2, _Pattern5_s_bss
    l32i a3, a2, 0
    movi a4, 0
    bne a3, a4, 1f
    mov a3, a2
    l32i a4, a3, 0
    addi a4, a4, 1
    s32i a4, a3, 0
1:
    l32i a3, a2, 0
    movi a4, 0
    blt a3, a4, 2f
    l32i a3, a2, 0
    movi a4, 100
    bge a3, a4, 2f
3:
    mov a3, a2
    l32i a4, a3, 0
    addi a4, a4, -1
    s32i a4, a3, 0
2:
    l32i a3, a2, 0
    movi a4, 1
    and a3, a3, a4
    bnez a3, 4f
    l32i a3, a2, 4
    l32i a4, a2, 0
    bbc a3, a4, 5f
4:
    movi a3, -1000
    s32i a3, a2, 0
5:
    l32i a3, a2, 0
    movi a4, 0
    bge a3, a4, 6f
    movi a3, 0
    s32i a3, a2, 4
    j 7f
6:
    l32i a3, a2, 0
    movi a4, 10
    bge a3, a4, 8f
    movi a3, 1
    s32i a3, a2, 4
    j 7f
8:
    l32i a3, a2, 0
    movi a4, 100
    bge a3, a4, 9f
    movi a3, 2
    s32i a3, a2, 4
    j 7f
9:
    movi a3, 4
    s32i a3, a2, 4
7:
    retw
    .size _Pattern5_init, .-_Pattern5_init


    .align 4
    .section .init_table_Pattern5_A9E2D4B5
    .int _Pattern5_init

