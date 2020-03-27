    .title "Module Pattern8, Key ACE2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern8_ACE2D4B5
    .global _Pattern8_ACE2D4B5_s_bss
_Pattern8_ACE2D4B5_s_bss:
_Pattern8_s_bss:
    .space 4

# -->    1: MODULE Pattern8;
# -->    2: VAR
# -->    3:   i: INTEGER;
# -->    4:   
# -->    5:   PROCEDURE P(x: INTEGER; VAR y: INTEGER);
# -->    6:   VAR
# -->    7:     z: INTEGER;
# -->    8:   BEGIN

    .align 4
    .section .text_Pattern8_ACE2D4B5
    .global _Pattern8_ACE2D4B5_s_text
_Pattern8_ACE2D4B5_s_text:

    .type _P, @function
_P:
    entry a1, 32
    s32i a2, a1, 0
    s32i a3, a1, 4
    movi a2, _Pattern8_s_bss
# -->    9:     z := x;
    l32i a3, a1, 0
    s32i a3, a1, 8
# -->   10:     y := z
# -->   11:   END P;
    l32i a3, a1, 8
    l32i a4, a1, 4
    s32i a3, a4, 0
    retw
    .size _P, .-_P
# -->   12: BEGIN


    .align 4
    .section .init_Pattern8_ACE2D4B5

_Pattern8_init:
    entry a1, 16
    movi a2, _Pattern8_s_bss
# -->   13:   P(5, i)
    movi a6, 5
    mov a7, a2
# -->   14: END Pattern8.
    call4 _P
    retw
    .size _Pattern8_init, .-_Pattern8_init


    .align 4
    .section .init_table_Pattern8_ACE2D4B5
    .int _Pattern8_init

