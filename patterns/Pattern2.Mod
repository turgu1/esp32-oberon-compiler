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

    .align 4
    .section .bss_Pattern2_A6E2D4B5
    .global _Pattern2_A6E2D4B5_s_bss
_Pattern2_A6E2D4B5_s_bss:
_Pattern2_s_bss:
    .space 36

    .align 4
    .section .init_Pattern2_A6E2D4B5

_Pattern2_init:
    entry a1, 16
    movi a15, _Pattern2_s_bss
    l32i a2, a15, 0        # a2 := i
    addi a2, a2, 1         # a2 := i + 1
    l32i a3, a15, 0        # a3 := i
    addi a3, a3, -1        # a3 := i - 1
    mull a2, a2, a3        # a2 := (i + 1) * (i - 1)
    s32i a2, a15, 0        # i := (i + 1) * (i - 1)
    l32i a2, a15, 8        # a2 := k
    movi a3, 17            # a3 := 17
    quos a2, a2, a3        # a2 := k DIV 17
    s32i a2, a15, 8        # k := k DIV 17 
    l32i a2, a15, 12       # a2 := n
    slli a2, a2, 3         # a2 := n * 8
    s32i a2, a15, 8        # k := n * 8
    l32i a2, a15, 12       # a2 := n
    srai a2, a2, 1         # a2 := n DIV 2
    s32i a2, a15, 8        # k := n DIV 2
    l32i a2, a15, 12       # a2 := n
    movi a3, 15            # a3 := 15
    and a2, a2, a3         # a2 := a2 MOD 16
    s32i a2, a15, 8        # k := a2 MOD 16
    l32i a2, a15, 16       # a2 := x
    movi a3, 1065353216    # a3 := 1.0
    wfr f0, a2             # f0 := x
    wfr f1, a3             # f1 := 1.0
    sub.s f0, f0, f1       # f0 := x - 1.0
    rfr a2, f2             # a2 := x - 1.0
    l32i a3, a15, 20       # a3 := y
    wfr f0, a3             # f0 := y
    wfr f1, a2             # f1 := x - 1.0
    call __fdiv32          # f2 := y / x - 1.0
    rfr a2, f2             # a2 := y / x - 1.0
    wfr f0, a2             # f0 := y / x - 1.0
    neg.s f0, f0           # f0 := -(y / x - 1.0)
    rfr a2, f0             # a2 := -(y / x - 1.0)
    s32i a2, a15, 16       # x := -(y / x - 1.0)
    l32i a2, a15, 28       # a2 := t
    l32i a3, a15, 32       # a3 := u
    and a2, a2, a3         # a2 := t * u
    l32i a3, a15, 24       # a3 := s
    or a2, a3, a2          # a2 := s + (t * u)
    s32i a2, a15, 24       # s := s + (t * u)
    retw
    .size _Pattern2_init, .-_Pattern2_init

    .align 4
    .section .init_table_Pattern2_A6E2D4B5
    .int _Pattern2_init

*)