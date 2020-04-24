MODULE Pattern6;
VAR
  i: INTEGER;

BEGIN 
  i := 0;
  WHILE i < 10 DO
    i := i + 2
  END ;
  REPEAT
    i := i - 1
  UNTIL i = 0
END Pattern6.

(* 
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
    movi a3, 0                 # a4 := 0
    s32i a3, a2, 0             # i := 0
L1:
    l32i a3, a2, 0             # a3 := i
    movi a4, 10                # a4 := 10
    bge a3 a4, L2              # branch if a3 >= 10
    l32i a3, a2, 0             # a3 := i
    addi a3, a3, 2             # a3 := i + 2
    s32i a3, a2, 0             # i := i + 2
    j 1b                       # loop to while test
L2:
L3:
    l32i a3, a2, 0             # a3 := i
    addi a3, a3, -1            # a3 := i - 1
    s32i a3, a2, 0             # i := i - 1
    l32i a3, a2, 0             # a3 := i
    movi a4, 0                 # a4 := 0
    bne a3 a4, 3b              # branch if i # 0
    retw
    .size _Pattern6_init, .-_Pattern6_init

    .align 4
    .section .init_table_Pattern6_AAE2D4B5
    .int _Pattern6_init
*)