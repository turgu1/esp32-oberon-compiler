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
    movi a15, _Pattern3_s_bss
    l32i a2, a15, 0    # a2 = i
    slli a2, a2, 2     # a2 = i * 4
    add a2, a15, a2
    l32i a2, a2, 16    # a2 := a[i]
    s32i a2, a15, 8    # k := a[i]
    l32i a2, a15, 36   # a2 := a[5]
    s32i a2, a15, 12   # n := a[5]
    
    l32i a2, a15, 0    # a2 = i
    movi a3, 40
    mull a2, a2, a3    # a2 = i * 40
    add a2, a15, a2    # a2 = ~x[i, 0]
    l32i a3, a15, 4    # a3 = j
    slli a3, a3, 2     # a3 = j * 4
    add a2, a2, a3     # a2 = ~x[i, j]
    movi a3, 2         # a3 = 2
    s32i a3, a2, 56    # x[i, j] = 2

    l32i a2, a15, 0    # a2 = i
    movi a3, 400       
    mull a2, a2, a3    # a2 = i * 400
    add a2, a15, a2    # a2 = ~y[i, 0, 0]
    l32i a3, a15, 4    # a3 = j
    movi a4, 40
    mull a3, a3, a4    # a3 = j * 40
    add a2, a2, a3     # a2 = ~y[i, j, 0]
    l32i a3, a15, 8    # a3 = k
    slli a3, a3, 2     # a3 = k * 4
    add a2, a2, a3     # a2 = ~y[i, j, k]
    movi a3, 3
    s32i a3, a2, 456   # y[i, j, k] := 3
    
    movi a2, 6
    addmi a4, a15, 1792 # a4 := 1792 + base address
    s32i a2, a4, 44    # x[3, 4, 5] := 6
    retw
    .size _Pattern3_init, .-_Pattern3_init

    .align 4
    .section .init_table_Pattern3_A7E2D4B5
    .int _Pattern3_init

*)