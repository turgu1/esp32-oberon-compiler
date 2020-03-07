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

    .align 4
    .section .bss_Pattern7_ABE2D4B5
    .global _Pattern7_ABE2D4B5_s_bss
_Pattern7_ABE2D4B5_s_bss:
_Pattern7_s_bss:
    .space 12


    .align 4
    .section .init_Pattern7_ABE2D4B5

_Pattern7_init:
    entry a1, 16
    movi a2, _Pattern7_s_bss
    movi a3, 0                 # a3 = 0  -> x := y
1:
    l32i a4, a2, 8             # a4 := n
    addi a4, a4, -1            # subtract 1
    blt a4 a3, 2f              # branch if (n - 1) < x
    s32i a3, a2, 0             # save x
    l32i a3, a2, 4             # a3 := m
    slli a3, a3, 1             # a3 := m * 2
    s32i a3, a2, 4             # m := m * 2
    l32i a3, a2, 0             # a3 := x
    addi a3, a3, 1             # a3 := x + 1
    j 1b                       # loop...
2:
    retw
    .size _Pattern7_init, .-_Pattern7_init

    .align 4
    .section .init_table_Pattern7_ABE2D4B5
    .int _Pattern7_init

*)