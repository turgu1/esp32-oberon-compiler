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
    .section .bss_module_Pattern10
    .align 4

a:  space 48

    .section .text_module_Pattern10
    .align 4

P:  entry a1, 8
    retw
    
    .section .init_module_Pattern10
    .align 4

_module_Pattern10_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern10
    .int _module_Pattern10_init 
*)