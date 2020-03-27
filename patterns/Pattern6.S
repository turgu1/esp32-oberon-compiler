    .title "Module Pattern6, Key AAE2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern6_AAE2D4B5
    .global _Pattern6_AAE2D4B5_s_bss
_Pattern6_AAE2D4B5_s_bss:
_Pattern6_s_bss:
    .space 4

# -->    1: MODULE Pattern6;
# -->    2: VAR
# -->    3:   i: INTEGER;
# -->    4: BEGIN 


    .align 4
    .section .init_Pattern6_AAE2D4B5

_Pattern6_init:
    entry a1, 16
    movi a2, _Pattern6_s_bss
# -->    5:   i := 0;
    movi a3, 0
    s32i a3, a2, 0
# -->    6:   WHILE i < 10 DO
1$:
    l32i a3, a2, 0
    movi a4, 10
    bge a3, a4, 2$
# -->    7:     i := i + 2
# -->    8:   END;
    l32i a3, a2, 0
    addi a3, a3, 2
    s32i a3, a2, 0
    j 1$
2$:
# -->    9:   REPEAT
# -->   10:     i := i - 1
3$:
# -->   11:   UNTIL i = 0
    l32i a3, a2, 0
    addi a3, a3, -1
    s32i a3, a2, 0
# -->   12: END Pattern6.
    l32i a3, a2, 0
    movi a4, 0
    bne a3, a4, 3$
    retw
    .size _Pattern6_init, .-_Pattern6_init


    .align 4
    .section .init_table_Pattern6_AAE2D4B5
    .int _Pattern6_init

