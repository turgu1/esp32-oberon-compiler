MODULE Pattern5;
VAR
  n: INTEGER;
  s: SET;
    
BEGIN
  IF n = 0 THEN
    INC(n)
  END;
  IF (n >= 0) & (n < 100) THEN
    DEC(n)
  END;
  IF ODD(n) OR (n IN s) THEN
    n := -1000
  END;
  IF n < 0 THEN
    s := {}
  ELSIF n < 10 THEN
    s := {0}
  ELSIF n < 100 THEN
    s := {1}
  ELSE
    s := {2}
  END
END Pattern5.

(* 
    .section .bss_module_Pattern5
    .align 4

n:  space 4
s:  space 4

    .section .init_module_Pattern5
    .align 4

_module_Pattern5_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern5
    .int _module_Pattern5_init 
*)