    .title "Module Pattern14, Key A5E3D3E9"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern14_A5E3D3E9
    .global _Pattern14_A5E3D3E9_s_bss
_Pattern14_A5E3D3E9_s_bss:
_Pattern14_s_bss:
    .space 72

    .section .text_Pattern14_A5E3D3E9
    .global _Pattern14_A5E3D3E9_s_text
_Pattern14_A5E3D3E9_s_text:

_P:
    entry a1, 16
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, 1
    l32i a3, a1, 0
    s32i a2, a3, 0
    l32i a2, a1, 4
    l32i a2, a2, 4
    addi a3, a15, 20
    movi a2, 2
    l32i a3, a1, 0
    s32i a2, a3, 12
    retw

    .section .init_Pattern14_A5E3D3E9
    .global _Pattern14_A5E3D3E9_s_init
_Pattern14_A5E3D3E9_s_init:

_Pattern14_init:
    entry a1, 16
    movi a15, _Pattern14_s_bss
    addi a6, a15, 40
    addi a7, a15, 0
    call4 _P
    addi a6, a15, 52
    addi a7, a15, 20
    call4 _P
    retw

    .section .init_table_Pattern14_A5E3D3E9
    .global _Pattern14_A5E3D3E9_s_init_table
_Pattern14_A5E3D3E9_s_init_table:
    .int .init_Pattern14_A5E3D3E9

