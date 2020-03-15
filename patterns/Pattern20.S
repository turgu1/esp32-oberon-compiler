    .title "Module Pattern20, Key A6E3D3E5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern20_A6E3D3E5
    .global _Pattern20_A6E3D3E5_s_bss
_Pattern20_A6E3D3E5_s_bss:
_Pattern20_s_bss:
    .space 20


    .align 4
    .section .text_Pattern20_A6E3D3E5
    .global _Pattern20_A6E3D3E5_s_text
_Pattern20_A6E3D3E5_s_text:

_qa:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Pattern20_s_bss
    l8ui a3, a1, 0
    beqz a3, L1
    l8ui a3, a1, 4
    beqz a3, L1
    movi a3, 1
    j L3
L1:
    movi a3, 0
L3:
    retw
    .size _qa, .-_qa

    .align 4
_qb:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Pattern20_s_bss
    l8ui a3, a1, 0
    bnez a3, L4
    l8ui a3, a1, 4
    beqz a3, L5
    movi a3, 1
    j L6
L5:
    movi a3, 0
L6:
    retw
    .size _qb, .-_qb

    .align 4
_q:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Pattern20_s_bss
    movi a3, 1
    s32i a3, a2, 4
    movi a6, 1
    movi a7, 0
    call4 _qa
    mov a3, a7
    s8i a3, a1, 8
    movi a6, 1
    movi a7, 0
    call4 _qb
    mov a3, a7
    s8i a3, a1, 8
    retw
    .size _q, .-_q


    .align 4
    .section .init_Pattern20_A6E3D3E5

_Pattern20_init:
    entry a1, 16
    movi a2, _Pattern20_s_bss
    addi a3, a2, 16
    l32i a4, a3, 0
    movi a5, 1
    slli a5, a5, 3
    or a4, a4, a5
    s32i a4, a3, 0
    addi a3, a2, 16
    l32i a4, a3, 0
    movi a5, 1
    l32i a6, a2, 4
    ssl a6
    sll a5, a5
    or a4, a4, a5
    s32i a4, a3, 0
    addi a3, a2, 16
    l32i a4, a3, 0
    movi a5, 1
    slli a5, a5, 3
    movi a6, -1
    xor a5, a5, a6
    and a4, a4, a5
    s32i a4, a3, 0
    addi a3, a2, 16
    l32i a4, a3, 0
    movi a5, 1
    l32i a6, a2, 4
    ssl a6
    sll a5, a5
    movi a6, -1
    xor a5, a5, a6
    and a4, a4, a5
    s32i a4, a3, 0
    l32i a3, a2, 4
    l32i a4, a2, 8
    bge a3, a4, L7
    movi a3, 1
    j L8
L7:
    movi a3, 0
L8:
    s8i a3, a2, 0
    movi a3, 1
    s8i a3, a2, 0
    movi a3, _q
    s32i a3, a2, 12
    movi a6, 1
    movi a7, 2
    l32i a8, a2, 12
    callx4 a8
    retw
    .size _Pattern20_init, .-_Pattern20_init


    .align 4
    .section .init_table_Pattern20_A6E3D3E5
    .int _Pattern20_init

