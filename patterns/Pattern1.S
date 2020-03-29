
    .title "Module Pattern1, Key A5E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern1_A5E2D4B5
    .global _Pattern1_A5E2D4B5_s_bss
_Pattern1_A5E2D4B5_s_bss:
_Pattern1_s_bss:
    .space 16

# -->    1: MODULE Pattern1;
# -->    2: VAR
# -->    3:   ch: CHAR;
# -->    4:   k:  INTEGER;
# -->    5:   x:  REAL;
# -->    6:   s:  SET;
# -->    7: BEGIN 


    .align 4
    .section .init_Pattern1_A5E2D4B5
_Pattern1_init:
    entry a1, 16
    movi a2, _Pattern1_s_bss
# -->    8:   ch := "0";
    movi a3, 48
    s8i a3, a2, 0
# -->    9:   k  :=  10;
    movi a3, 10
    s32i a3, a2, 4
# -->   10:   x  := 1.0;
    movi a3, 1065353216
    s32i a3, a2, 8
# -->   11:   s  := {0, 4, 8}
# -->   12: END Pattern1.
    movi a3, 273
    s32i a3, a2, 12
    retw
    .size _Pattern1_init, .-_Pattern1_init



    .align 4
    .section .init_table_Pattern1_A5E2D4B5
    .int _Pattern1_init
