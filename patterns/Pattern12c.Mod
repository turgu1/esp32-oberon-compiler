MODULE Pattern12c;
  IMPORT Pattern12a, Pattern12b;
  
VAR
  i: INTEGER;
  y: REAL;
  
BEGIN 
  i := Pattern12a.k;
  y := Pattern12b.x;
END Pattern12c.

(* 
    .section .bss_module_Pattern12c
    .align 4

i:  .space 4
y:  .space 4

    .section .init_module_Pattern12c
    .align 4

    .extern _module_pattern12a_k, _module_pattern12b_x
    
_module_Pattern12c_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern12c
    .int _module_Pattern12c_init 
*)