MODULE Pattern6;
VAR
  i: INTEGER;

BEGIN 
  i := 0;
  WHILE i < 10 DO
    i := i + 2
  END;
  REPEAT
    i := i - 1
  UNTIL i = 0
END Pattern6.

(* 
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
    movi a15, _Pattern6_s_bss
    movi a2, 0                 # a3 := 0
    s32i a2, a15, 0            # i := 0
1:
    l32i a2, a15, 0            # a2 := i
    movi a3, 10                # a3 := 10
    bge a2 a3, 2f              # branch if a2 >= 10
    l32i a2, a15, 0            # a2 := i
    addi a2, a2, 2             # a2 := i + 2
    s32i a2, a15, 0            # i := i + 2
    j 1b                       # loop to while test
2:
3:
    l32i a2, a15, 0            # a2 := i
    addi a2, a2, -1            # a2 := i - 1
    s32i a2, a15, 0            # i := i - 1
    l32i a2, a15, 0            # a2 := i
    movi a3, 0                 # a3 := 0
    bne a2 a3, 3b              # branch if i # 0
    retw

    .section .init_table_Pattern6_AAE2D4B5
    .global _Pattern6_AAE2D4B5_s_init_table
_Pattern6_AAE2D4B5_s_init_table:
    .int .init_Pattern6_AAE2D4B5
*)