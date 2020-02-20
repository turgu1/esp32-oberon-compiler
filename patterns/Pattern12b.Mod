MODULE Pattern12b;
VAR
  x*: REAL;
  
  PROCEDURE Q*;
  BEGIN
    x := 1.0
  END Q;
END Pattern12b.

(* 
    .section .bss_module_Pattern12b
    .align 4

    .global _module_Pattern12b_x
_module_Pattern12b_x: .space 4

    .section .text_module_Pattern12b
    .align 4

    .global _module_Pattern12b_Q
_module_Pattern12b_x:
    entry a1, 0
    retw
    
*)