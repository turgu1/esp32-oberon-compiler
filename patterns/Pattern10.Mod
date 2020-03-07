MODULE Pattern10;
VAR
  a: ARRAY 12 OF INTEGER;
  
  (* VAR must be there to allow edition of the array, the opposite 
     of the description in the PO.Application.pdf document *)
     
  PROCEDURE P(VAR x: ARRAY OF INTEGER);
  VAR
    i, n: INTEGER;
  BEGIN
    n := x[i];
    x[i + 1] := n + 5
  END P;
  
BEGIN
  P(a);
END Pattern10.

(* 
    .title "Module Pattern10, Key A5E3D3E5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern10_A5E3D3E5
    .global _Pattern10_A5E3D3E5_s_bss
_Pattern10_A5E3D3E5_s_bss:
_Pattern10_s_bss:
    .space 48

    .align 4
    .section .text_Pattern10_A5E3D3E5
    .global _Pattern10_A5E3D3E5_s_text
_Pattern10_A5E3D3E5_s_text:

_P:
    entry a1, 16
    s32i a2, a1, 0     # SP[0] := Address of x
    s32i a3, a1, 4     # SP[4] := Length of x
    movi a2, _Pattern10_s_bss
    l32i a3, a1, 8     # a3 := i
    slli a3, a3, 2     # a3 := a3 * 4
    l32i a4, a1, 0     # a4 := address of x
    add a3, a4, a3     # a3 := adress of x[i]
    l32i a3, a3, 0     # a3 := x[i]
    s32i a3, a1, 12    # n  := x[i]
    l32i a3, a1, 8     # a3 := i
    addi a3, a3, 1     # a3 := i + 1
    slli a3, a3, 2     # a3 := a3 * 4
    l32i a4, a1, 0     # a4 := address of x
    add a3, a4, a3     # a3 := adress of x[i + 1]
    l32i a4, a1, 12    # a4 := n
    addi a4, a4, 5     # a4 := n + 5
    s32i a4, a3, 0     # x[x + 1] := n + 5
    retw
    .size _P, .-_P

    .align 4
    .section .init_Pattern10_A5E3D3E5

_Pattern10_init:
    entry a1, 16
    movi a15, _Pattern10_s_bss
    addi a6, a15, 0   # a6 = Address of a (will be a2 in _P)
    movi a7, 12       # a7 = Length of a (will be a4 in _P)
    call4 _P
    retw
    .size _Pattern10_init, .-_Pattern10_init

    .align 4
    .section .init_table_Pattern10_A5E3D3E5
    .int _Pattern10_init

*)