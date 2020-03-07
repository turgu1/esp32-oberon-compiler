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
    .title "Module Pattern3, Key A7E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern3_A7E2D4B5
    .global _Pattern3_A7E2D4B5_s_bss
_Pattern3_A7E2D4B5_s_bss:
_Pattern3_s_bss:
    .space 4456

    .align 4
    .section .init_Pattern3_A7E2D4B5

_Pattern3_init:
    entry a1, 16
    movi a2, _Pattern3_s_bss
    l32i a3, a2, 0     # a3 = i
    slli a3, a3, 2     # a3 = i * 4
    add a3, a2, a3
    l32i a3, a3, 16    # a3 := a[i]
    s32i a3, a2, 8     # k := a[i]
    l32i a3, a2, 36    # a3 := a[5]
    s32i a3, a2, 12    # n := a[5]
    
    l32i a3, a2, 0     # a3 = i
    movi a4, 40
    mull a3, a3, a4    # a3 = i * 40
    add a3, a2, a3     # a3 = ~x[i, 0]
    l32i a4, a2, 4     # a4 = j
    slli a4, a4, 2     # a4 = j * 4
    add a3, a3, a4     # a3 = ~x[i, j]
    movi a4, 2         # a4 = 2
    s32i a4, a3, 56    # x[i, j] = 2

    l32i a3, a2, 0     # a3 = i
    movi a4, 400       
    mull a3, a3, a4    # a3 = i * 400
    add a3, a2, a3     # a3 = ~y[i, 0, 0]
    l32i a4, a2, 4     # a4 = j
    movi a5, 40
    mull a4, a4, a5    # a4 = j * 40
    add a3, a3, a4     # a3 = ~y[i, j, 0]
    l32i a4, a2, 8     # a4 = k
    slli a4, a4, 2     # a4 = k * 4
    add a3, a3, a4     # a3 = ~y[i, j, k]
    movi a4, 3
    s32i a4, a3, 456   # y[i, j, k] := 3
    
    movi a3, 6
    addmi a4, a2, 1792 # a4 := 1792 + base address
    s32i a3, a4, 44    # x[3, 4, 5] := 6
    retw
    .size _Pattern3_init, .-_Pattern3_init

    .align 4
    .section .init_table_Pattern3_A7E2D4B5
    .int _Pattern3_init

*)