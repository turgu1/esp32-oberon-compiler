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
    movi a15, _Pattern18_s_bss
    mov a2, a15
    movi a3, _Pattern18_s_str
    movi a4, 2
    loop a4, 1f
    l32i a5, a3, 0
    addi a3, a3, 4
    s32i a5, a2, 0
    addi a2, a2, 4
1:
    mov a4, a15
    movi a5, _Pattern18_s_str
    addi a5, a5, 8
2:
    l8ui a2, a4, 0
    addi a4, a4, 1
    l8ui a3, a5, 0
    addi a5, a5, 1
    bne a2, a3, 3f
    bnez a2, 2b
3:
    bge a2, a3, 4f
    movi a2, 3
    s32i a2, a15, 512
4:
    retw
    .size _Pattern18_init, .-_Pattern18_init


    .align 4
    .section .init_table_Pattern18_A5E3D3ED
    .int _Pattern18_init

