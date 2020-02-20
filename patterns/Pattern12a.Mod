MODULE Pattern12a;
VAR
  k*: INTEGER;

  PROCEDURE P*;
  BEGIN
    k := 1
  END P;
END Pattern12a.

(* 
    .section .bss_module_Pattern12a
    .align 4

    .global _module_Pattern12a_k
_module_Pattern12a_k:  space 4

    .section .text_module_Patern12a
    .align 4

    .global _module_Pattern12a_P
_module_Pattern12a_P:
    entry a1, 0
    retw
*)