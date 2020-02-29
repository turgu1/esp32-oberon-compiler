    .title "Module Pattern6, Key AAE2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern6_AAE2D4B5
    .global _Pattern6_AAE2D4B5_s_bss
_Pattern6_AAE2D4B5_s_bss:
_Pattern6_s_bss:
    .space 4


    .section .init_Pattern6_AAE2D4B5
    .global _Pattern6_AAE2D4B5_s_init
_Pattern6_AAE2D4B5_s_init:

_Pattern6_init:
    entry a1, 0
    movi a2, 0                 # a3 := 0
    movi a3, _Pattern6_s_bss
    s32i a2, a3, 0             # i := 0
1:
    movi a2, _Pattern6_s_bss
    l32i a2, a2, 0             # a2 := i
    movi a3, 10                # a3 := 10
    bge a2 a3, 2f              # branch if a2 >= 10
    movi a2, _Pattern6_s_bss
    l32i a2, a2, 0             # a2 := i
    addi a2, a2, 2             # a2 := i + 2
    movi a3, _Pattern6_s_bss
    s32i a2, a3, 0             # i := i + 2
    j 1b                       # loop to while test
2:
3:
    movi a2, _Pattern6_s_bss
    l32i a2, a2, 0             # a2 := i
    addi a2, a2, -1            # a2 := i - 1
    movi a3, _Pattern6_s_bss
    s32i a2, a3, 0             # i := i - 1
    movi a2, _Pattern6_s_bss
    l32i a2, a2, 0             # a2 := i
    movi a3, 0                 # a3 := 0
    bne a2 a3, 3b              # branch if i # 0
0:
    retw

    .section .init_table_Pattern6_AAE2D4B5
    .global _Pattern6_AAE2D4B5_s_init_table
_Pattern6_AAE2D4B5_s_init_table:
    .int .init_Pattern6_AAE2D4B5

