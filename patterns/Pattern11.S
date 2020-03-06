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
    movi a15, _Pattern11_s_bss
    l32i a2, a15, 4
    movi a3, 1
    ssl a2
    sll a2, a3
    s32i a2, a15, 0
    movi a2, -1
    l32i a3, a15, 8
    bgei a3, 31, 1f
    movi a4, -1
    addi a3, a3, 1
    ssl a3
    sll a3, a4
    xor a2, a2, a3
1:
    s32i a2, a15, 0
    l32i a2, a15, 4
    movi a3, -1
    ssl a2
    sll a2, a3
    s32i a2, a15, 0
    l32i a2, a15, 4
    movi a3, -1
    ssl a2
    sll a2, a3
    l32i a3, a15, 8
    bgei a3, 31, 2f
    movi a4, -1
    addi a3, a3, 1
    ssl a3
    sll a3, a4
    xor a2, a2, a3
2:
    s32i a2, a15, 0
    movi a2, 10412
    l32i a3, a15, 8
    bbc a2, a3, 3f
    movi a2, 1
    s32i a2, a15, 4
3:
    retw
    .size _Pattern11_init, .-_Pattern11_init


    .align 4
    .section .init_table_Pattern11_A5E3D3E6
    .int _Pattern11_init

