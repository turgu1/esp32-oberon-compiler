MODULE Arrays2;
  IMPORT Out;
  TYPE X = ARRAY 1 OF INTEGER;
  VAR
       a : X;
       b : ARRAY 1 OF INTEGER;
       (*i : ARRAY 3, 2 OF INTEGER;
       j : ARRAY 2, 4 OF INTEGER;*)
       i0 : ARRAY 4, 3, 2 OF INTEGER;
       j0 : ARRAY 4, 3, 2 OF INTEGER;
  PROCEDURE P(s : X);
  BEGIN  Out.Int(s[0] + 1, 0); (* 3 *)
  END P;
BEGIN
  a[0] := 1;
  b[0] := 2;
  a := b;
  Out.Int(a[0], 0); (* 2 *)
  (*i := j; illegal assignment *)
  i0[1, 1, 1] := 8;
  j0[1][1][1] := 9;
  Out.Int(i0[1, 1, 1], 0); (* 8 *);
  i0 := j0;
  Out.Int(i0[1, 1, 1], 0); (* 9 *);
  P(a);
  P(b);
END Arrays2.
