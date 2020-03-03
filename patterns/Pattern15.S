    .title "Module Pattern15, Key A5E3D3EA"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .str_Pattern15_A5E3D3EA
    .global _Pattern15_A5E3D3EA_s_str
_Pattern15_A5E3D3EA_s_str:
_Pattern15_s_str:
    db 65,66,67,68,69,70,0,0,48,49,50,51,52,53,0,0
    db 37,0,0,0,

    .section .bss_Pattern15_A5E3D3EA
    .global _Pattern15_A5E3D3EA_s_bss
_Pattern15_A5E3D3EA_s_bss:
_Pattern15_s_bss:
    .space 64

    .section .text_Pattern15_A5E3D3EA
    .global _Pattern15_A5E3D3EA_s_text
_Pattern15_A5E3D3EA_s_text:

_P:
    entry a1, 16
    s32i a2, a1, 0
    s32i a3, a1, 4
    retw

    .section .init_Pattern15_A5E3D3EA
    .global _Pattern15_A5E3D3EA_s_init
_Pattern15_A5E3D3EA_s_init:

_Pattern15_init:
    entry a1, 16
    movi a15, _Pattern15_s_bss
    addi a2, a15, 0
    movi a3, _Pattern15_s_str
    addi a3, a3, 0
    movi a4, 2
    loop a4, 1f
    l32i a5, a3, 0
    addi a3, a3, 4
    s32i a5, a2, 0
    addi a2, a2, 4
1:
    addi a2, a15, 0
    addi a3, a15, 32
    movi a4, 8
    loop a4, 2f
    l32i a5, a3, 0
    addi a3, a3, 4
    s32i a5, a2, 0
    addi a2, a2, 4
2:
    addi a6, a15, 32
    movi a7, 32
    call4 _P
    movi a6, _Pattern15_s_str
    addi a6, a6, 8
    movi a7, 7
    call4 _P
    movi a6, _Pattern15_s_str
    addi a6, a6, 16
    movi a7, 2
    call4 _P
    retw

    .section .init_table_Pattern15_A5E3D3EA
    .global _Pattern15_A5E3D3EA_s_init_table
_Pattern15_A5E3D3EA_s_init_table:
    .int .init_Pattern15_A5E3D3EA

