MODULE Pattern8;
VAR
  i: INTEGER;
  
  PROCEDURE P(x: INTEGER; VAR y: INTEGER);
  VAR
    z: INTEGER;
  BEGIN
    z := x;
    y := z
  END P;

BEGIN
  P(5, i)
END Pattern8.

(* 
     .title "Module Pattern8, Key ACE2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern8_ACE2D4B5
    .global _Pattern8_ACE2D4B5_s_bss
_Pattern8_ACE2D4B5_s_bss:
_Pattern8_s_bss:
    .space 4

1:
    .section .text_Pattern8_ACE2D4B5
    .global _Pattern8_ACE2D4B5_s_text
_Pattern8_ACE2D4B5_s_text:

_P:                        # PROCEDURE P
    entry a1, 12
    s32i a2, a1, 0         # save x
    s32i a3, a1, 4         # save y
    l32i a2, a1, 0         # load x
    s32i a2, a1, 8         # z := x
    l32i a2, a1, 8         # load z
    l32i a3, a1, 4         # load y
    s32i a2, a3, 0         # @y := z
    retw

    .section .init_Pattern8_ACE2D4B5
    .global _Pattern8_ACE2D4B5_s_init
_Pattern8_ACE2D4B5_s_init:

_Pattern8_init:
    entry a1, 0
    movi a15, _Pattern8_s_bss
    movi a6, 5                   # param x := 5
    addi a7, a15, 0              # param y := address of i
    call4 _P
    retw

    .section .init_table_Pattern8_ACE2D4B5
    .global _Pattern8_ACE2D4B5_s_init_table
_Pattern8_ACE2D4B5_s_init_table:
    .int .init_Pattern8_ACE2D4B5

*)