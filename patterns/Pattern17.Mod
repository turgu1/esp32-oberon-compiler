MODULE Pattern17;
VAR
  m, n: INTEGER;
  x, y: REAL;
  b: BOOLEAN;
  ch: CHAR;
  
BEGIN
  n := ABS(m);
  y := ABS(x);
  b := ODD(n);
  n := ORD(ch);
  n := FLOOR(x);
  y := FLT(m);
  n := LSL(m, 3);
  n := ASR(m, 8);
  m := ROR(m, n);
END Pattern17.

(* 
    .section .bss_module_Pattern17
    .align 4
    
m:  .space 4
n:  .space 4
x:  .space 4
y:  .space 4
b:  .space 1
ch: .space 1

    .section .init_module_Pattern17
    .align 4

_module_Pattern17_init:
    entry a1, 0
    retw

    .section .init_table_module_Pattern17
    .int _module_Pattern17_init 
*)