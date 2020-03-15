    .title "Module Pattern15, Key A5E3D3EA"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_strs_Pattern15_A5E3D3EA
_Pattern15_s_str:
    .byte 65,66,67,68,69,70,0,0,48,49,50,51,52,53,0,0
    .byte 37,0,0,0

    .align 4
    .section .bss_Pattern15_A5E3D3EA
    .global _Pattern15_A5E3D3EA_s_bss
_Pattern15_A5E3D3EA_s_bss:
_Pattern15_s_bss:
    .space 64


    .align 4
    .section .text_Pattern15_A5E3D3EA
    .global _Pattern15_A5E3D3EA_s_text
_Pattern15_A5E3D3EA_s_text:

_P:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Pattern15_s_bss
    retw
    .size _P, .-_P


    .align 4
    .section .init_Pattern15_A5E3D3EA

_Pattern15_init:
    entry a1, 16
    movi a2, _Pattern15_s_bss
    mov a3, a2
    movi a4, _Pattern15_s_str
    movi a5, 2
    loop a5, L1
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L1:
    mov a3, a2
    addi a4, a2, 32
    movi a5, 8
    loop a5, L2
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L2:
    addi a6, a2, 32
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
    .size _Pattern15_init, .-_Pattern15_init


    .align 4
    .section .init_table_Pattern15_A5E3D3EA
    .int _Pattern15_init

