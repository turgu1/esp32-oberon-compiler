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
    movi a15, _Pattern5_s_bss
    l32i a2, a15, 0
    movi a3, 0
    bne a2, a3, 1f
    mov a2, a15
    l32i a3, a2, 0
    addi a3, a3, 1
    s32i a3, a2, 0
1:
    l32i a2, a15, 0
    movi a3, 0
    blt a2, a3, 2f
    l32i a2, a15, 0
    movi a3, 100
    bge a2, a3, 2f
3:
    mov a2, a15
    l32i a3, a2, 0
    addi a3, a3, -1
    s32i a3, a2, 0
2:
    l32i a2, a15, 0
    movi a3, 1
    and a2, a2, a3
    bnez a2, 4f
    l32i a2, a15, 4
    l32i a3, a15, 0
    bbc a2, a3, 5f
4:
    movi a2, -1000
    s32i a2, a15, 0
5:
    l32i a2, a15, 0
    movi a3, 0
    bge a2, a3, 6f
    movi a2, 0
    s32i a2, a15, 4
    j 7f
6:
    l32i a2, a15, 0
    movi a3, 10
    bge a2, a3, 8f
    movi a2, 1
    s32i a2, a15, 4
    j 7f
8:
    l32i a2, a15, 0
    movi a3, 100
    bge a2, a3, 9f
    movi a2, 2
    s32i a2, a15, 4
    j 7f
9:
    movi a2, 4
    s32i a2, a15, 4
7:
    retw
    .size _Pattern5_init, .-_Pattern5_init


    .align 4
    .section .init_table_Pattern5_A9E2D4B5
    .int _Pattern5_init

