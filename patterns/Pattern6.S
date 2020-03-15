    .title "Module Pattern6, Key AAE2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern6_AAE2D4B5
    .global _Pattern6_AAE2D4B5_s_bss
_Pattern6_AAE2D4B5_s_bss:
_Pattern6_s_bss:
    .space 4



    .align 4
    .section .init_Pattern6_AAE2D4B5

_Pattern6_init:
    entry a1, 16
    movi a2, _Pattern6_s_bss
    movi a3, 0
    s32i a3, a2, 0
L1:
    l32i a3, a2, 0
    movi a4, 10
    bge a3, a4, L2
    l32i a3, a2, 0
    addi a3, a3, 2
    s32i a3, a2, 0
    j L1
L2:
L3:
    l32i a3, a2, 0
    addi a3, a3, -1
    s32i a3, a2, 0
    l32i a3, a2, 0
    movi a4, 0
    bne a3, a4, L3
    retw
    .size _Pattern6_init, .-_Pattern6_init


    .align 4
    .section .init_table_Pattern6_AAE2D4B5
    .int _Pattern6_init

