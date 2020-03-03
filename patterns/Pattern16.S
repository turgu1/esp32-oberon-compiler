    .title "Module Pattern16, Key A5E3D3EB"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .str_Pattern16_A5E3D3EB
    .global _Pattern16_A5E3D3EB_s_str
_Pattern16_A5E3D3EB_s_str:
_Pattern16_s_str:
    db 48,49,50,51,52,53,54,55,56,57,0,0,

    .section .bss_Pattern16_A5E3D3EB
    .global _Pattern16_A5E3D3EB_s_bss
_Pattern16_A5E3D3EB_s_bss:
_Pattern16_s_bss:
    .space 128


    .section .init_Pattern16_A5E3D3EB
    .global _Pattern16_A5E3D3EB_s_init
_Pattern16_A5E3D3EB_s_init:

_Pattern16_init:
    entry a1, 16
    movi a15, _Pattern16_s_bss
    addi a2, a15, 0
    l32i a3, a2, 0
    addi a3, a3, 1
    s32i a3, a2, 0
    addi a2, a15, 4
    l32i a3, a2, 0
    addi a3, a3, -10
    s32i a3, a2, 0
    addi a2, a15, 12
    l32i a3, a2, 0
    movi a4, 1
    slli a4, a4, 3
    or a3, a3, a4
    s32i a3, a2, 0
    addi a2, a15, 12
    l32i a3, a2, 0
    movi a4, 1
    slli a4, a4, 7
    movi a5, -1
    xor a4, a4, a5
    and a3, a3, a4
    s32i a3, a2, 0
    l32i a2, a15, 0
    l32i a3, a15, 4
    blt a2, a3, 1f
    addi a1, a1, -4
    s32i a2, a1, 0
    movi a2, 7
    j __TRAP__
1:
    l32i a2, a15, 8
    srai a3, a2, 23
    addi a3, a3, -127
    s32i a3, a15, 4
    slli a3, a3, 23
    sub a2, a2, a3
    s32i a2, a15, 8
    l32i a2, a15, 8
    l32i a3, a15, 4
    slli a3, a3, 23
    add a2, a2, a3
    s32i a2, a15, 8
    addi a2, a15, 96
    movi a3, _Pattern16_s_str
    addi a3, a3, 0
    movi a4, 3
    loop a4, 2f
    l32i a5, a3, 0
    addi a3, a3, 4
    s32i a5, a2, 0
    addi a2, a2, 4
2:
    addi a4, a15, 96
    addi a5, a15, 112
3:
    l8ui a2, a4, 0
    addi a4, a4, 1
    l8ui a3, a5, 0
    addi a5, a5, 1
    bne a2, a3, 4f
    bnez a2, 3b
4:
    bge a2, a3, 5f
    movi a2, 1
    s32i a2, a15, 0
5:
    retw

    .section .init_table_Pattern16_A5E3D3EB
    .global _Pattern16_A5E3D3EB_s_init_table
_Pattern16_A5E3D3EB_s_init_table:
    .int .init_Pattern16_A5E3D3EB

