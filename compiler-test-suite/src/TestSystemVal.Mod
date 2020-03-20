MODULE TestSystemVal;
  IMPORT Out, SYSTEM;

  TYPE

    pR0 = POINTER TO R0;
    pR1 = POINTER TO R1;
    R0 = RECORD x: INTEGER END;
    R1 = RECORD(R0) y: INTEGER END;

  VAR

    a, b, c, i: INTEGER;
    r: REAL;
    p0: pR0;
    p1, p: pR1;

BEGIN

  (* converting SET to INTEGER and vice versa *)

  b := SYSTEM.VAL(INTEGER, {0, 5});
  c := SYSTEM.VAL(INTEGER, {1..4});
  a := SYSTEM.VAL(INTEGER, SYSTEM.VAL(SET, b) + SYSTEM.VAL(SET, c));
  IF 2 IN SYSTEM.VAL(SET, a) THEN
    Out.Int(a, 10); (* 63 *)
    Out.Char(CHR(a)); (* ? *)
  END;

  (* converting REAL to INTEGER and back *)

  i := 8;
  r := SYSTEM.VAL(REAL, i);
  Out.Real(r, 10);
  i := SYSTEM.VAL(INTEGER, r);
  Out.Int(i, 10); Out.Ln;

  (* converting extension types *)

  NEW(p1);
  p1.y := 25;
  p0 := p1;
  p := SYSTEM.VAL(pR1, p0);
  Out.Int(p.y, 10); (* 25 *)

  NEW(p1);
  p1.y := 26;
  p := SYSTEM.VAL(pR1, p1);
  Out.Int(p.y, 10) (* 26 *)

END TestSystemVal.