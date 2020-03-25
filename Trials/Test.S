    .title "Module Test, Key 74736654"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Test_74736654
    .global _Test_74736654_s_bss
_Test_74736654_s_bss:
_Test_s_bss:
    .space 12



    .align 4
    .section .init_Test_74736654

_Test_init:
    entry a1, 16
    movi a2, _Test_s_bss
    l8ui a3, a2, 0
    beqz a3, 1$
    l8ui a3, a2, 1
    beqz a3, 2$
    l8ui a3, a2, 2
    bnez a3, 3$
    l8ui a3, a2, 6
    beqz a3, 4$
3$:
    l8ui a3, a2, 3
    beqz a3, 4$
3$:
    l8ui a3, a2, 4
    beqz a3, 4$
5$:
    movi a3, 7
    s32i a3, a2, 8
4$:
6$:
3$:
    retw
    .size _Test_init, .-_Test_init


    .align 4
    .section .init_table_Test_74736654
    .int _Test_init

