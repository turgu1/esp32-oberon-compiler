MODULE TestImport11;
  IMPORT Out;
IMPORT I := TestImport10;
  VAR
    r : I.R;
    s : I.S;
    p : I.P;
    a : I.A;
    b : I.B;
    c : I.C;
    d : I.D;
BEGIN
  Out.Int(I.x, 10); (* 5 *)
  r.v := {1..9};
  IF 6 IN r.v THEN Out.Int(6, 10) END;
  s.w[2].u := 7;
  Out.Int(s.w[2].u, 10);  (* 7 *)
  NEW(p);
  p.u := 8;
  Out.Int(p.u, 10);  (* 8 *)
  a[4] := 9;
  Out.Int(a[4], 10);  (* 9 *)
  b[1, 2] := 20.0-10.0;
  Out.Real(b[1][2], 10);  (* 10.0 *)
  c[9].w[2].u := 11;
  Out.Int(c[9].w[2].u, 10); (* 11 *)
  Out.Ln;
  d[1] := "A";
  Out.Char(d[1]); (* A *)
  Out.Char(I.Dollar); (* $ *)
  Out.Int(I.Ten + 1, 10); (* 11, compile time sum *)
  I.Q0;
  Out.Int(I.x, 10); (* 15 *)
  Out.Int(I.Q1(8, 9), 10) (* 17 *)
END TestImport11.