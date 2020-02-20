MODULE Pattern14;
TYPE
  R0 = RECORD
        a, b, c: INTEGER
      END;
  R1 = RECORD (R0)
        d, e: INTEGER
      END;
      
VAR
  r0: R0;
  r1: R1;
  
  PROCEDURE P(VAR r: R0);
  BEGIN
    r.a := 1;
    r(R1).d := 2
  END P;
  
BEGIN
  P(r0);
  P(r1)
END Pattern14. 

(* 
    .section .bss_module_Pattern14
    .align 4

r0: .space 12
r1: .space 20

    .section .text_module_Pattern14
    .align 4

P:  entry a1, 0
    retw
    
    .section .init_module_Pattern14
    .align 4

_module_Pattern14_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern14
    .int _module_Pattern14_init 
*)