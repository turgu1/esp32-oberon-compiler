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

    .align 4
    .section .bss_Pattern8_ACE2D4B5
    .global _Pattern8_ACE2D4B5_s_bss
_Pattern8_ACE2D4B5_s_bss:
_Pattern8_s_bss:
    .space 4

    .align 4
    .section .text_Pattern8_ACE2D4B5
    .global _Pattern8_ACE2D4B5_s_text
_Pattern8_ACE2D4B5_s_text:

_P:                        # PROCEDURE P
    entry a1, 32
    s32i a2, a1, 0         # save x
    s32i a3, a1, 4         # save y
    movi a2, _Pattern8_s_bss
    l32i a3, a1, 0         # load x
    s32i a3, a1, 8         # z := x
    l32i a3, a1, 8         # load z
    l32i a4, a1, 4         # load y
    s32i a3, a4, 0         # @y := z
    retw
    .size _P, .-_P

    .align 4
    .section .init_Pattern8_ACE2D4B5

_Pattern8_init:
    entry a1, 16
    movi a2, _Pattern8_s_bss
    movi a6, 5                   # param x := 5
    mov a7, a2                  # param y := address of i
    call4 _P
    retw
    .size _Pattern8_init, .-_Pattern8_init

    .align 4
    .section .init_table_Pattern8_ACE2D4B5
    .int _Pattern8_init

*)