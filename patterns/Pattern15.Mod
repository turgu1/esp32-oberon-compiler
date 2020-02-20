MODULE Pattern15;
VAR
  s0, s1: ARRAY 32 OF CHAR;
  
  PROCEDURE P(x: ARRAY OF CHAR);
  END P;
  
BEGIN 
  s0 := "ABCDEF";
  s0 := s1;
  P(s1);
  P("012345");
  P("%")
END Pattern15.

(* 
    .section .bss_module_Pattern15
    .align 4

s0: .space 32
s1: .space 32

    .section .text_module_patter15
    .align 4

P:  entry a1, 0
    retw
    
    .section .init_module_Pattern15
    .align 4

_module_Pattern15_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern15
    .int _module_Pattern15_init 
*)