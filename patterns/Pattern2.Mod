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
    movi a2, _Pattern2_s_bss
    l32i a3, a2, 0         # a3 := i
    addi a3, a3, 1         # a3 := i + 1
    l32i a4, a2, 0         # a4 := i
    addi a4, a4, -1        # a4 := i - 1
    mull a3, a3, a4        # a3 := (i + 1) * (i - 1)
    s32i a3, a2, 0         # i := (i + 1) * (i - 1)
    l32i a3, a2, 8         # a3 := k
    movi a4, 17            # a4 := 17
    quos a3, a3, a4        # a3 := k DIV 17
    s32i a3, a2, 8         # k := k DIV 17 
    l32i a3, a2, 12        # a3 := n
    slli a3, a3, 3         # a3 := n * 8
    s32i a3, a2, 8         # k := n * 8
    l32i a3, a2, 12        # a3 := n
    srai a3, a3, 1         # a3 := n DIV 2
    s32i a3, a2, 8         # k := n DIV 2
    l32i a3, a2, 12        # a3 := n
    movi a4, 15            # a4 := 15
    and a3, a3, a4         # a3 := a3 MOD 16
    s32i a3, a2, 8         # k := a3 MOD 16
    l32i a3, a2, 16        # a3 := x
    movi a4, 1065353216    # a4 := 1.0
    wfr f0, a3             # f0 := x
    wfr f1, a4             # f1 := 1.0
    sub.s f0, f0, f1       # f0 := x - 1.0
    rfr a3, f2             # a3 := x - 1.0
    l32i a4, a2, 20        # a4 := y
    wfr f0, a4             # f0 := y
    wfr f1, a3             # f1 := x - 1.0
    call __fdiv32          # f2 := y / x - 1.0
    rfr a3, f2             # a3 := y / x - 1.0
    wfr f0, a3             # f0 := y / x - 1.0
    neg.s f0, f0           # f0 := -(y / x - 1.0)
    rfr a3, f0             # a3 := -(y / x - 1.0)
    s32i a3, a2, 16        # x := -(y / x - 1.0)
    l32i a3, a2, 28        # a3 := t
    l32i a4, a2, 32        # a4 := u
    and a3, a3, a4         # a3 := t * u
    l32i a4, a2, 24        # a4 := s
    or a3, a4, a3          # a3 := s + (t * u)
    s32i a3, a2, 24        # s := s + (t * u)
    retw
    .size _Pattern2_init, .-_Pattern2_init

    .align 4
    .section .init_table_Pattern2_A6E2D4B5
    .int _Pattern2_init

*)