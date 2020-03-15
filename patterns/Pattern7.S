    .title "Module Pattern7, Key ABE2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern7_ABE2D4B5
    .global _Pattern7_ABE2D4B5_s_bss
_Pattern7_ABE2D4B5_s_bss:
_Pattern7_s_bss:
    .space 12



    .align 4
    .section .init_Pattern7_ABE2D4B5

_Pattern7_init:
    entry a1, 16
    movi a2, _Pattern7_s_bss
    movi a3, 0
L1:
    l32i a4, a2, 8
    addi a4, a4, -1
    blt a4, a3, L2
    s32i a3, a2, 0
    l32i a3, a2, 4
    slli a3, a3, 1
    s32i a3, a2, 4
    l32i a3, a2, 0
    addi a3, a3, 1
    j L1
L2:
    retw
    .size _Pattern7_init, .-_Pattern7_init


    .align 4
    .section .init_table_Pattern7_ABE2D4B5
    .int _Pattern7_init

