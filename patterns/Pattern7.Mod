MODULE Pattern7;
VAR 
  i, m, n: INTEGER;
  
BEGIN
  FOR i := 0 TO n - 1 DO
    m := 2 * m
  END
END Pattern7.

(* 
    .section .bss_module_Pattern7
    .align 4

i:  space 4
m:  space 4
n:  space 4

    .section .init_module_Pattern7
    .align 4

_module_Pattern7_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern7
    .int _module_Pattern7_init 
*)