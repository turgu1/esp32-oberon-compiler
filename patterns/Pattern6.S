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
    movi a15, _Pattern6_s_bss
    movi a2, 0
    s32i a2, a15, 0
1:
    l32i a2, a15, 0
    movi a3, 10
    bge a2, a3, 2f
    l32i a2, a15, 0
    addi a2, a2, 2
    s32i a2, a15, 0
    j 1b
2:
3:
    l32i a2, a15, 0
    addi a2, a2, -1
    s32i a2, a15, 0
    l32i a2, a15, 0
    movi a3, 0
    bne a2, a3, 3b
    retw
    .size _Pattern6_init, .-_Pattern6_init


    .align 4
    .section .init_table_Pattern6_AAE2D4B5
    .int _Pattern6_init

