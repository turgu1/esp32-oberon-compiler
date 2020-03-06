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
    .title "Module Pattern17, Key A5E3D3EC"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .align 4
    .section .bss_Pattern17_A5E3D3EC
    .global _Pattern17_A5E3D3EC_s_bss
_Pattern17_A5E3D3EC_s_bss:
_Pattern17_s_bss:
    .space 20



    .align 4
    .section .init_Pattern17_A5E3D3EC

_Pattern17_init:
    entry a1, 16
    movi a15, _Pattern17_s_bss
    l32i a2, a15, 0
    abs a2, a2
    s32i a2, a15, 4
    l32i a2, a15, 8
    slli a2, a2, 1
    srli a2, a2, 1
    s32i a2, a15, 12
    l32i a2, a15, 4
    movi a3, 1
    and a2, a2, a3
    s8i a2, a15, 16
    l8ui a2, a15, 17
    s32i a2, a15, 4
    l32i a2, a15, 8
    wfr f0, a2
    floor.s a2, f0, 0
    s32i a2, a15, 4
    l32i a2, a15, 0
    float.s f0, a2, 0
    rfr a2, f0
    s32i a2, a15, 12
    l32i a2, a15, 0
    slli a2, a2, 3
    s32i a2, a15, 4
    l32i a2, a15, 0
    srai a2, a2, 8
    s32i a2, a15, 4
    l32i a2, a15, 0
    l32i a3, a15, 4
    ssr a3
    mov a3, a2
    src a2, a2, a3
    s32i a2, a15, 0
    retw
    .size _Pattern17_init, .-_Pattern17_init


    .align 4
    .section .init_table_Pattern17_A5E3D3EC
    .int _Pattern17_init

*)