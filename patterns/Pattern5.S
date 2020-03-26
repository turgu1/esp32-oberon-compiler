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
    bne a3, a4, 1$
    mov a3, a2
    l32i a4, a3, 0
    addi a4, a4, 1
    s32i a4, a3, 0
1$:
    l32i a3, a2, 0
    movi a4, 0
    blt a3, a4, 2$
    l32i a3, a2, 0
    movi a4, 100
    bge a3, a4, 2$
    mov a3, a2
    l32i a4, a3, 0
    addi a4, a4, -1
    s32i a4, a3, 0
2$:
    l32i a3, a2, 0
    movi a4, 1
    and a3, a3, a4
    bnez a3, 3$
    l32i a3, a2, 4
    l32i a4, a2, 0
    bbc a3, a4, 4$
3$:
    movi a3, -1000
    s32i a3, a2, 0
4$:
    l32i a3, a2, 0
    movi a4, 0
    bge a3, a4, 5$
    movi a3, 0
    s32i a3, a2, 4
    j 6$
5$:
    l32i a3, a2, 0
    movi a4, 10
    bge a3, a4, 7$
    movi a3, 1
    s32i a3, a2, 4
    j 6$
7$:
    l32i a3, a2, 0
    movi a4, 100
    bge a3, a4, 8$
    movi a3, 2
    s32i a3, a2, 4
    j 6$
8$:
    movi a3, 4
    s32i a3, a2, 4
6$:
    retw
    .size _Pattern5_init, .-_Pattern5_init


    .align 4
    .section .init_table_Pattern5_A9E2D4B5
    .int _Pattern5_init

