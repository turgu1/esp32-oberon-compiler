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
    .section .bss_module_Pattern8
    .align 4

i:  space 4

    .section .text_module_Pattern8
    .align 4

P:  entry a1, 4
    retw
    
    .section .init_module_Pattern8
    .align 4

_module_Pattern8_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern8
    .int _module_Pattern8_init 
*)