    .title "Module Pattern5, Key A9E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern5_A9E2D4B5
    .global _Pattern5_A9E2D4B5_s_bss
_Pattern5_A9E2D4B5_s_bss:
_Pattern5_s_bss:
    .space 8

# -->    1: MODULE Pattern5;
# -->    2: VAR
# -->    3:   n: INTEGER;
# -->    4:   s: SET;
# -->    5:     
# -->    6: BEGIN


    .align 4
    .section .init_Pattern5_A9E2D4B5

_Pattern5_init:
    entry a1, 16
    movi a2, _Pattern5_s_bss
# -->    7:   IF n = 0 THEN
    l32i a3, a2, 0
    movi a4, 0
    bne a3, a4, 1$
# -->    8:     INC(n)
# -->    9:   END;
    mov a3, a2
    l32i a4, a3, 0
    addi a4, a4, 1
    s32i a4, a3, 0
1$:
# -->   10:   IF (n >= 0) & (n < 100) THEN
    l32i a3, a2, 0
    movi a4, 0
    blt a3, a4, 2$
    l32i a3, a2, 0
    movi a4, 100
    bge a3, a4, 2$
# -->   11:     DEC(n)
# -->   12:   END;
    mov a3, a2
    l32i a4, a3, 0
    addi a4, a4, -1
    s32i a4, a3, 0
2$:
# -->   13:   IF ODD(n) OR (n IN s) THEN
    l32i a3, a2, 0
    movi a4, 1
    and a3, a3, a4
    bnez a3, 3$
    l32i a3, a2, 4
    l32i a4, a2, 0
    bbc a3, a4, 4$
3$:
# -->   14:     n := -1000
# -->   15:   END;
    movi a3, -1000
    s32i a3, a2, 0
4$:
# -->   16:   IF n < 0 THEN
    l32i a3, a2, 0
    movi a4, 0
    bge a3, a4, 5$
# -->   17:     s := {}
# -->   18:   ELSIF n < 10 THEN
    movi a3, 0
    s32i a3, a2, 4
    j 6$
5$:
    l32i a3, a2, 0
    movi a4, 10
    bge a3, a4, 7$
# -->   19:     s := {0}
# -->   20:   ELSIF n < 100 THEN
    movi a3, 1
    s32i a3, a2, 4
    j 6$
7$:
    l32i a3, a2, 0
    movi a4, 100
    bge a3, a4, 8$
# -->   21:     s := {1}
# -->   22:   ELSE
    movi a3, 2
    s32i a3, a2, 4
# -->   23:     s := {2}
    j 6$
8$:
# -->   24:   END
    movi a3, 4
    s32i a3, a2, 4
6$:
# -->   25: END Pattern5.
    retw
    .size _Pattern5_init, .-_Pattern5_init


    .align 4
    .section .init_table_Pattern5_A9E2D4B5
    .int _Pattern5_init

