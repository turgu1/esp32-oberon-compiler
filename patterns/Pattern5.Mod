MODULE Pattern5;
VAR
  n: INTEGER;
  s: SET;
    
BEGIN
  IF n = 0 THEN
    INC(n)
  END;
  IF (n >= 0) & (n < 100) THEN
    DEC(n)
  END;
  IF ODD(n) OR (n IN s) THEN
    n := -1000
  END;
  IF n < 0 THEN
    s := {}
  ELSIF n < 10 THEN
    s := {0}
  ELSIF n < 100 THEN
    s := {1}
  ELSE
    s := {2}
  END
END Pattern5.

(* 
    .title "Module Pattern5, Key A9E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern5_A9E2D4B5
    .global _Pattern5_A9E2D4B5_s_bss
_Pattern5_A9E2D4B5_s_bss:
_Pattern5_s_bss:
    .space 8

    .section .init_Pattern5_A9E2D4B5
    .global _Pattern5_A9E2D4B5_s_init
_Pattern5_A9E2D4B5_s_init:

_Pattern5_init:
    entry a1, 0
    movi a15, _Pattern5_s_bss
    l32i a2, a2, 0            # a2 := i
    movi a3, 0                # a3 := 0
    bne a2 a3, 1f             # Branch if not equal to 0
    addi a2, a15, 0 
    l32i a3, a2, 0            # a3 := n
    addi a3, a3, 1            # INC(a3)
    s32i a3, a2, 0            # n := a3
1:
    l32i a2, a15, 0           # a2 := n
    movi a3, 0                # a3 := 0
    blt a2 a3, 2f             # branch if n < 0
    l32i a2, a15, 0           # a2 := n
    movi a3, 100              # a3 = 100
    bge a2 a3, 2f             # branch if n >= 100
3:
    addi a2, a15, 0
    l32i a3, a2, 0            # a3 := n
    addi a3, a3, -1           # DEC(a3)
    s32i a3, a2, 0            # n := a3
2:
    l32i a2, a15, 0           # a2 := n
    movi a3, 1
    and a2, a2, a3            # a2 := ODD(n)
    bnez a2, 4f               # branch if it is odd
    l32i a2, a15, 4           # a2 := s
    l32i a3, a15, 0           # a3 := n
    bbc a2 a3, 5f             # branch if bit not set
4:
    movi a2, -1000            # a2 := -1000
    s32i a2, a15, 0           # n := -1000
5:
    l32i a2, a15, 0           # a2 := n
    movi a3, 0                # a3 := 0
    bge a2 a3, 6f             # branch if n >= 0
    movi a2, 0
    s32i a2, a15, 4
    j 7f
6:
    l32i a2, a15, 0           # a2 := n
    movi a3, 10               # a3 := 10
    bge a2 a3, 8f             # branch if n >= 10
    movi a2, 1                # a2 := {0}
    s32i a2, a15, 4           # s := {0}
    j 7f
8:
    l32i a2, a15, 0           # a2 := n
    movi a3, 100              # a3 := 100
    bge a2 a3, 9f             # branch if n >= 100
    movi a2, 2                # a2 := {1}
    s32i a2, a15, 4           # s := {1}
    j 7f
9:
    movi a2, 4                # a2 := {2}
    s32i a2, a15, 4           # s := {2}
7:
    retw

    .section .init_table_Pattern5_A9E2D4B5
    .global _Pattern5_A9E2D4B5_s_init_table
_Pattern5_A9E2D4B5_s_init_table:
    .int .init_Pattern5_A9E2D4B5
*)