    .title "Module Pattern10, Key A5E3D3E5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern10_A5E3D3E5
    .global _Pattern10_A5E3D3E5_s_bss
_Pattern10_A5E3D3E5_s_bss:
_Pattern10_s_bss:
    .space 48

1:
    .section .text_Pattern10_A5E3D3E5
    .global _Pattern10_A5E3D3E5_s_text
_Pattern10_A5E3D3E5_s_text:

_P:
    entry a1, 16
    s32i a2, a1, 0
    s32i a3, a1, 4
    l32i a2, a1, 8
    slli a2, a2, 2
    l32i a3, a1, 0
    add a2, a3, a2
    l32i a2, a2, 0
    s32i a2, a1, 12
    l32i a2, a1, 8
    addi a2, a2, 1
    slli a2, a2, 2
    l32i a3, a1, 0
    add a2, a3, a2
    l32i a3, a1, 12
    addi a3, a3, 5
    s32i a3, a2, 0
    retw

    .section .init_Pattern10_A5E3D3E5
    .global _Pattern10_A5E3D3E5_s_init
_Pattern10_A5E3D3E5_s_init:

_Pattern10_init:
    entry a1, 0
    movi a15, _Pattern10_s_bss
    addi a6, a15, 0
    movi a7, 12
    call4 _P
    retw

    .section .init_table_Pattern10_A5E3D3E5
    .global _Pattern10_A5E3D3E5_s_init_table
_Pattern10_A5E3D3E5_s_init_table:
    .int .init_Pattern10_A5E3D3E5

