MODULE Pattern3;
VAR
  i, j, k, n: INTEGER; 
  a: ARRAY 10 OF INTEGER;
  x: ARRAY 10, 10 OF INTEGER;
  y: ARRAY 10, 10, 10 OF INTEGER;

BEGIN 
  k := a[i]; 
  n := a[5]; 
  x[i, j] := 2;
  y[i, j, k] := 3;
  y[3, 4, 5] := 6
END Pattern3.

(* 
    .section .bss_module_Pattern3
    .align 4

i:  space 4
j:  space 4
k:  space 4
n:  space 4
a:  space 40
x:  space 400
y:  space 4000

    .section .init_module_Pattern3
    .align 4

_module_Pattern3_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern3
    .int _module_Pattern3_init 
*)