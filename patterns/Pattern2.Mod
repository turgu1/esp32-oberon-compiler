MODULE Pattern2;
VAR
  i, j, k, n: INTEGER;
  x, y: REAL;
  s, t, u: SET;

BEGIN
  i := (i + 1) * (i - 1);
  k := k DIV 17;
  k := 8 * n;
  k := n DIV 2;
  k := n MOD 16;
  x := -y / (x - 1.0);
  s := s + t * u
END Pattern2.

(* 
    .section .bss_module_Pattern2
    .align 4

i:  space 4
j:  space 4
k:  space 4
n:  space 4
x:  space 4
y:  space 4
s:  space 4
t:  space 4
u:  space 4

    .section .init_module_Pattern2
    .align 4

_module_Pattern2_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern2
    .int _module_Pattern2_init 
*)