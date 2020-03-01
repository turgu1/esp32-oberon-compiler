MODULE Pattern7;
VAR 
  i, m, n: INTEGER;
  
BEGIN
  FOR i := 0 TO n - 1 DO
    m := 2 * m
  END
END Pattern7.

(* 
    .title "Module Pattern7, Key ABE2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern7_ABE2D4B5
    .global _Pattern7_ABE2D4B5_s_bss
_Pattern7_ABE2D4B5_s_bss:
_Pattern7_s_bss:
    .space 12


    .section .init_Pattern7_ABE2D4B5
    .global _Pattern7_ABE2D4B5_s_init
_Pattern7_ABE2D4B5_s_init:

_Pattern7_init:
    entry a1, 0
    movi a15, _Pattern7_s_bss
    movi a2, 0                 # a2 = 0  -> x := y
1:
    l32i a3, a15, 8            # a3 := n
    addi a3, a3, -1            # subtract 1
    blt a3 a2, 2f              # branch if (n - 1) < x
    s32i a2, a15, 0            # save x
    l32i a2, a15, 4            # a2 := m
    slli a2, a2, 1             # a2 := m * 2
    s32i a2, a15, 4            # m := m * 2
    l32i a2, a15, 0            # a2 := x
    addi a2, a2, 1             # a2 := x + 1
    j 1b                       # loop...
2:
    retw

    .section .init_table_Pattern7_ABE2D4B5
    .global _Pattern7_ABE2D4B5_s_init_table
_Pattern7_ABE2D4B5_s_init_table:
    .int .init_Pattern7_ABE2D4B5

*)