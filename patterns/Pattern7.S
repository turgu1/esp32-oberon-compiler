    .title "Module Pattern7, Key ABE2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern7_ABE2D4B5
    .global _Pattern7_ABE2D4B5_s_bss
_Pattern7_ABE2D4B5_s_bss:
_Pattern7_s_bss:
    .space 12


    .section .init_Pattern7_ABE2D4B5
    .global _Pattern7_ABE2D4B5_s_init
_Pattern7_ABE2D4B5_s_init:

_Pattern7_init:
    entry a1, 0
    movi a15, _Pattern7_s_bss
    movi a2, 0
1:
    l32i a3, a15, 8
    addi a3, a3, -1
    blt a3, a2, 2f
    s32i a2, a15, 0
    l32i a2, a15, 4
    slli a2, a2, 1
    s32i a2, a15, 4
    l32i a2, a15, 0
    addi a2, a2, 1
    j 1b
2:
    retw

    .section .init_table_Pattern7_ABE2D4B5
    .global _Pattern7_ABE2D4B5_s_init_table
_Pattern7_ABE2D4B5_s_init_table:
    .int .init_Pattern7_ABE2D4B5

