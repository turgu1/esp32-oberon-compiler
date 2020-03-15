    .title "Module Pattern18, Key A5E3D3ED"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_strs_Pattern18_A5E3D3ED
_Pattern18_s_str:
    .byte 72,101,108,108,111,0,0,0,65,108,108,111,0,0,0,0

    .align 4
    .section .bss_Pattern18_A5E3D3ED
    .global _Pattern18_A5E3D3ED_s_bss
_Pattern18_A5E3D3ED_s_bss:
_Pattern18_s_bss:
    .space 516



    .align 4
    .section .init_Pattern18_A5E3D3ED

_Pattern18_init:
    entry a1, 16
    movi a2, _Pattern18_s_bss
    mov a3, a2
    movi a4, _Pattern18_s_str
    movi a5, 2
    loop a5, L1
    l32i a6, a4, 0
    addi a4, a4, 4
    s32i a6, a3, 0
    addi a3, a3, 4
L1:
    mov a5, a2
    movi a6, _Pattern18_s_str
    addi a6, a6, 8
L2:
    l8ui a3, a5, 0
    addi a5, a5, 1
    l8ui a4, a6, 0
    addi a6, a6, 1
    bne a3, a4, L3
    bnez a3, L2
L3:
    bge a3, a4, L4
    movi a3, 3
    s32i a3, a2, 512
L4:
    retw
    .size _Pattern18_init, .-_Pattern18_init


    .align 4
    .section .init_table_Pattern18_A5E3D3ED
    .int _Pattern18_init

