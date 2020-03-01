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
    .title "Module Pattern2, Key A6E2D4B5"
    .sbttl "Oberon ESP32 Compiler Version 0.1.0"

    .section .bss_Pattern2_A6E2D4B5
    .global _Pattern2_A6E2D4B5_s_bss
_Pattern2_A6E2D4B5_s_bss:
_Pattern2_s_bss:
    .space 36

    .section .init_Pattern2_A6E2D4B5
    .global _Pattern2_A6E2D4B5_s_init
_Pattern2_A6E2D4B5_s_init:

_Pattern2_init:
    entry a1, 0
    movi a15, _Pattern2_s_bss
    l32i a2, a2, 0
    movi a3, 1
    add a2, a2, a3
    l32i a3, a15, 0
    movi a4, 1
    sub a3, a3, a4
    mull a2, a2, a3
    s32i a2, a15, 0
    l32i a2, a15, 8
    movi a3, 17
    quos a2, a2, a3
    s32i a2, a15, 8
    l32i a2, a15, 12
    slli a2, a2, 3
    s32i a2, a15, 8
    l32i a2, a15, 12
    srai a2, a2, 1
    s32i a2, a3, 8
    l32i a2, a15, 12
    movi a3, 15
    and a2, a2, a3
    s32i a2, a15, 8
    l32i a2, a15, 16
    movi a3, 1
    wfr f0, a2
    wfr f1, a3
    sub.s f0, f0, f1
    rfr a2, f2
    l32i a3, a15, 20
    wfr f0, a3
    wfr f1, a2
    call __fdiv32
    rfr a2, f2
    wfr f0, a2
    neg.s f0, f0
    rfr a2, f0
    s32i a2, a15, 16
    l32i a2, a15, 28
    l32i a3, a15, 32
    and a2, a2, a3
    l32i a3, a15, 24
    or a2, a3, a2
    s32i a2, a15, 24
    retw

    .section .init_table_Pattern2_A6E2D4B5
    .global _Pattern2_A6E2D4B5_s_init_table
_Pattern2_A6E2D4B5_s_init_table:
    .int .init_Pattern2_A6E2D4B5

*)