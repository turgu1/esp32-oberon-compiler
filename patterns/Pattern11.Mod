MODULE Pattern11;
VAR
  s: SET; 
  m, n: INTEGER;
  
BEGIN
  s := {m};
  s := {0 .. n};
  s := {m .. 31};
  s := {m .. n};
  IF n IN {2, 3, 5, 7, 11, 13} THEN
    m := 1
  END
END Pattern11.

(* 
    .section .bss_module_Pattern11
    .align 4

s:  space 4
m:  space 4
n:  space 4

    .section .init_module_Pattern11
    .align 4

_module_Pattern11_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern11
    .int _module_Pattern11_init 
*)