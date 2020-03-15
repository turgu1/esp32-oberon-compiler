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

    .align 4
    .section .bss_Pattern5_A9E2D4B5
    .global _Pattern5_A9E2D4B5_s_bss
_Pattern5_A9E2D4B5_s_bss:
_Pattern5_s_bss:
    .space 8

    .align 4
    .section .init_Pattern5_A9E2D4B5

_Pattern5_init:
    entry a1, 16
    movi a2, _Pattern5_s_bss
    l32i a3, a2, 0            # a3 := i
    movi a4, 0                # a4 := 0
    bne a3 a4, L1             # Branch if not equal to 0
    mov a3, a2 
    l32i a4, a3, 0            # a4 := n
    addi a4, a4, 1            # INC(a4)
    s32i a4, a3, 0            # n := a4
L1:
    l32i a3, a2, 0            # a3 := n
    movi a4, 0                # a4 := 0
    blt a3 a4, L2             # branch if n < 0
    l32i a3, a2, 0            # a3 := n
    movi a4, 100              # a4 = 100
    bge a3 a4, L2             # branch if n >= 100
L3:
    mov a3, a2
    l32i a4, a3, 0            # a4 := n
    addi a4, a4, -1           # DEC(a4)
    s32i a4, a3, 0            # n := a4
L2:
    l32i a3, a2, 0            # a3 := n
    movi a4, 1
    and a3, a3, a4            # a3 := ODD(n)
    bnez a3, L4               # branch if it is odd
    l32i a3, a2, 4            # a3 := s
    l32i a4, a2, 0            # a4 := n
    bbc a3 a4, L5             # branch if bit not set
L4:
    movi a3, -1000            # a3 := -1000
    s32i a3, a2, 0            # n := -1000
L5:
    l32i a3, a2, 0            # a3 := n
    movi a4, 0                # a4 := 0
    bge a3 a4, L6             # branch if n >= 0
    movi a3, 0
    s32i a3, a2, 4
    j L7
L6:
    l32i a3, a2, 0            # a3 := n
    movi a4, 10               # a4 := 10
    bge a3 a4, L8             # branch if n >= 10
    movi a3, 1                # a3 := {0}
    s32i a3, a2, 4            # s := {0}
    j L7
L8:
    l32i a3, a2, 0            # a3 := n
    movi a4, 100              # a4 := 100
    bge a3 a4, L9             # branch if n >= 100
    movi a3, 2                # a3 := {1}
    s32i a3, a2, 4            # s := {1}
    j L7
L9:
    movi a3, 4                # a3 := {2}
    s32i a3, a2, 4            # s := {2}
L7:
    retw
   .size _Pattern5_init, .-_Pattern5_init

    .align 4
    .section .init_table_Pattern5_A9E2D4B5
    .int _Pattern5_init
*)