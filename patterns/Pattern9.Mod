MODULE Pattern9;
VAR
  x: REAL;
  
  PROCEDURE F(x: REAL): REAL;
  BEGIN
    IF x >= 1.0 THEN
      x := F(F(x))
    END;
    RETURN x
  END F;
  
END Pattern9.

(* 
    .section .bss_module_Pattern9
    .align 4

x:  space 4

    .section .text_module_Pattern9
    .align 4

F:  .entry a1, 0
    retw
    
    .section .init_module_Pattern9
    .align 4

_module_Pattern9_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern9
    .int _module_Pattern9_init 
*)