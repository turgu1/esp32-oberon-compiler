    .title "Module Pattern11, Key A5E3D3E6"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern11_A5E3D3E6
    .global _Pattern11_A5E3D3E6_s_bss
_Pattern11_A5E3D3E6_s_bss:
_Pattern11_s_bss:
    .space 12


    .section .init_Pattern11_A5E3D3E6
    .global _Pattern11_A5E3D3E6_s_init
_Pattern11_A5E3D3E6_s_init:

_Pattern11_init:
    entry a1, 0
    movi a2, _Pattern11_s_bss
    l32i a2, a2, 4
    movi a3, 1
    ssl a2
    sll a2, a3
    movi a3, _Pattern11_s_bss
    s32i a2, a3, 0
    movi a2, -1
    movi a3, _Pattern11_s_bss
    l32i a3, a3, 8
    bgei a3, 31, 1f
    movi a4, -1
    addi a3, a3, 1
    ssl a3
    sll a3, a4
    xor a2, a2, a3
1:
    movi a3, _Pattern11_s_bss
    s32i a2, a3, 0
    movi a2, _Pattern11_s_bss
    l32i a2, a2, 4
    movi a3, -1
    ssl a2
    sll a2, a3
    movi a3, _Pattern11_s_bss
    s32i a2, a3, 0
    movi a2, _Pattern11_s_bss
    l32i a2, a2, 4
    movi a3, -1
    ssl a2
    sll a2, a3
    movi a3, _Pattern11_s_bss
    l32i a3, a3, 8
    bgei a3, 31, 2f
    movi a4, -1
    addi a3, a3, 1
    ssl a3
    sll a3, a4
    xor a2, a2, a3
2:
    movi a3, _Pattern11_s_bss
    s32i a2, a3, 0
    movi a2, 10412
    movi a3, _Pattern11_s_bss
    l32i a3, a3, 8
    bbc a2, a3, 3f
    movi a2, 1
    movi a3, _Pattern11_s_bss
    s32i a2, a3, 4
3:
    retw

    .section .init_table_Pattern11_A5E3D3E6
    .global _Pattern11_A5E3D3E6_s_init_table
_Pattern11_A5E3D3E6_s_init_table:
    .int .init_Pattern11_A5E3D3E6

