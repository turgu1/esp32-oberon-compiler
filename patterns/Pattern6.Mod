MODULE Pattern6;
VAR
  i: INTEGER;

BEGIN 
  i := 0;
  WHILE i < 10 DO
    i := i + 2
  END;
  REPEAT
    i := i - 1
  UNTIL i = 0
END Pattern6.

(* 
    .section .bss_module_Pattern6
    .align 4

i:  space 4

    .section .init_module_Pattern6
    .align 4

_module_Pattern6_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern6
    .int _module_Pattern6_init 
*)