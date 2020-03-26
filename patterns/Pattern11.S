    .title "Module Pattern11, Key A5E3D3E6"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern11_A5E3D3E6
    .global _Pattern11_A5E3D3E6_s_bss
_Pattern11_A5E3D3E6_s_bss:
_Pattern11_s_bss:
    .space 12



    .align 4
    .section .init_Pattern11_A5E3D3E6

_Pattern11_init:
    entry a1, 16
    movi a2, _Pattern11_s_bss
    l32i a3, a2, 4
    movi a4, 1
    ssl a3
    sll a3, a4
    s32i a3, a2, 0
    movi a3, -1
    l32i a4, a2, 8
    addi a4, a4, 1
    bgei a4, 32, 1$
    movi a5, -1
    ssl a4
    sll a4, a5
    xor a3, a3, a4
1$:
    s32i a3, a2, 0
    l32i a3, a2, 4
    movi a4, -1
    ssl a3
    sll a3, a4
    s32i a3, a2, 0
    l32i a3, a2, 4
    movi a4, -1
    ssl a3
    sll a3, a4
    l32i a4, a2, 8
    addi a4, a4, 1
    bgei a4, 32, 2$
    movi a5, -1
    ssl a4
    sll a4, a5
    xor a3, a3, a4
2$:
    s32i a3, a2, 0
    movi a3, 10412
    l32i a4, a2, 8
    bbc a3, a4, 3$
    movi a3, 1
    s32i a3, a2, 4
3$:
    retw
    .size _Pattern11_init, .-_Pattern11_init


    .align 4
    .section .init_table_Pattern11_A5E3D3E6
    .int _Pattern11_init

