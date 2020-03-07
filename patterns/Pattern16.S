    .title "Module Pattern16, Key A5E3D3EB"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_strs_Pattern16_A5E3D3EB
_Pattern16_s_str:
    .byte 48,49,50,51,52,53,54,55,56,57,0,0

    .align 4
    .section .bss_Pattern16_A5E3D3EB
    .global _Pattern16_A5E3D3EB_s_bss
_Pattern16_A5E3D3EB_s_bss:
_Pattern16_s_bss:
    .space 128



    .align 4
    .section .init_Pattern16_A5E3D3EB

_Pattern16_init:
    entry a1, 16
    movi a2, _Pattern16_s_bss
    mov a3, a2
    l32i a4, a3, 0
    addi a4, a4, 1
    s32i a4, a3, 0
    addi a3, a2, 4
    l32i a4, a3, 0
    addi a4, a4, -10
    s32i a4, a3, 0
    addi a3, a2, 12
    l32i a4, a3, 0
    movi a5, 1
    slli a5, a5, 3
    or a4, a4, a5
    s32i a4, a3, 0
    addi a3, a2, 12
    l32i a4, a3, 0
    movi a5, 1
    slli a5, a5, 7
    movi a6, -1
    xor a5, a5, a6
    and a4, a4, a5
    s32i a4, a3, 0
    l32i a3, a2, 0
    l32i a4, a2, 4
    blt a3, a4, 1f
    addi a1, a1, -4
    s32i a2, a1, 0
    movi a2, 7
    j __TRAP__
1:
    l32i a3, a2, 8
    srai a4, a3, 23
    addi a4, a4, -127
    s32i a4, a2, 4
    slli a4, a4, 23
    sub a3, a3, a4
    s32i a3, a2, 8
    l32i a3, a2, 8
    l32i a4, a2, 4
    slli a4, a4, 23
    add a3, a3, a4
    s32i a3, a2, 8
    addi a3, a2, 96
    movi a4, _Pattern16_s_str
    movi a5, 3
    loop a5, 2f
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
2:
    addi a5, a2, 96
    addi a6, a2, 112
3:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, 4f
    bnez a3, 3b
4:
    bge a3, a4, 5f
    movi a3, 1
    s32i a3, a2, 0
5:
    retw
    .size _Pattern16_init, .-_Pattern16_init


    .align 4
    .section .init_table_Pattern16_A5E3D3EB
    .int _Pattern16_init

