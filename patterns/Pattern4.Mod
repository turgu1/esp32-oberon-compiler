MODULE Pattern4;
TYPE
  Ptr = POINTER TO Node;
  Node = RECORD 
    num: INTEGER;
    name: ARRAY 8 OF CHAR;
    next: Ptr
  END;
VAR 
  p, q: Ptr;
  r: Node;
    
BEGIN
  r.num := 10; 
  p.num := 6;
  p.name[7] := "0";
  p.next := q;
  p.next.next := NIL
END Pattern4.

(* 
    .title "Module Pattern4, Key A8E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .data_types_Pattern4_A8E2D4B5
    .global _Pattern4_A8E2D4B5_s_data_types
_Pattern4_A8E2D4B5_s_data_types:
_Pattern4_s_types:
    .int 32,-1,-1,-1,12,-1

    .align 4
    .section .bss_Pattern4_A8E2D4B5
    .global _Pattern4_A8E2D4B5_s_bss
_Pattern4_A8E2D4B5_s_bss:
_Pattern4_s_bss:
    .space 48

    .align 4
    .section .init_Pattern4_A8E2D4B5

_Pattern4_init:
    entry a1, 16
    movi a2, _Pattern4_s_bss
    movi a3, 10               # a3 := 10
    s32i a3, a2, 32           # r.num := 10
    l32i a3, a2, 24           # a3 := p
    movi a4, 6                # a4 := 6
    s32i a4, a3, 0            # p.num := 6
    l32i a3, a2, 24           # a3 := p
    movi a4, 48               # a4 := "0"
    s8i a4, a3, 11            # p.name[7] := "0"
    l32i a3, a2, 24           # a3 := p
    l32i a4, a2, 28           # a4 := q
    s32i a4, a3, 12           # p.next := q
    l32i a3, a2, 24           # a3 := p
    l32i a3, a3, 12           # a3 := p.next
    movi a4, 0                # a4 := NIL
    s32i a4, a3, 12           # p.next.next := NIL
    retw
   .size _Pattern4_init, .-_Pattern4_init

    .align 4
    .section .init_table_Pattern4_A8E2D4B5
    .int _Pattern4_init

*)