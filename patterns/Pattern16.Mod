MODULE Pattern16;
VAR
  m, n: INTEGER;
  x: REAL;
  u: SET;
  a, b: ARRAY 10 OF INTEGER;
  s, t: ARRAY 16 OF CHAR;
  
BEGIN
  INC(m);
  DEC(n, 10);
  INCL(u, 3);
  EXCL(u, 7);
  ASSERT(m < n);
  UNPK(x, n);
  PACK(x, n);
  s := "0123456789";
  IF s < t THEN
    m := 1
  END
END Pattern16.

(* 
    .section .bss_module_Pattern16
    .align 4

m:  .space 4
n:  .space 4
x:  .space 4
u:  .space 4
a:  .space 40
b:  .space 40
s:  .space 16
t:  .space 16

    .section .init_module_Pattern16
    .align 4

_module_Pattern16_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern16
    .int _module_Pattern16_init 
*)