    .title "Module Pattern19, Key A5E3D3EE"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern19_A5E3D3EE
    .global _Pattern19_A5E3D3EE_s_bss
_Pattern19_A5E3D3EE_s_bss:
_Pattern19_s_bss:
    .space 12



    .align 4
    .section .init_Pattern19_A5E3D3EE

_Pattern19_init:
    entry a1, 16
    movi a2, _Pattern19_s_bss
    movi a3, 3
    movi a4, 5
    blt a3, a4, 1f
    addi a1, a1, -4
    s32i a2, a1, 0
    movi a2, 7
    j __TRAP__
1:
    movi a3, 3
    movi a4, 5
    bge a3, a4, 2f
    l8ui a3, a2, 8
    bnez a3, 3f
    addi a1, a1, -4
    s32i a2, a1, 0
    movi a2, 7
    j __TRAP__
3:
2:
    l32i a3, a2, 0
    l32i a4, a2, 4
    beq a3, a4, 4f
    addi a1, a1, -4
    s32i a2, a1, 0
    movi a2, 7
    j __TRAP__
4:
    l32i a3, a2, 0
    movi a4, 0
    beq a3, a4, 5f
    addi a1, a1, -4
    s32i a2, a1, 0
    movi a2, 7
    j __TRAP__
5:
    l8ui a3, a2, 8
    bnez a3, 6f
    addi a1, a1, -4
    s32i a2, a1, 0
    movi a2, 7
    j __TRAP__
6:
    retw
    .size _Pattern19_init, .-_Pattern19_init


    .align 4
    .section .init_table_Pattern19_A5E3D3EE
    .int _Pattern19_init

