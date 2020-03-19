MODULE TestByteType;
  IMPORT SYSTEM, Out;
  VAR x : INTEGER;
      y : BYTE;
      r : RECORD y : BYTE END;
      ar : ARRAY 1 OF BYTE;

  PROCEDURE P1(i : BYTE): INTEGER;
  BEGIN
    RETURN ORD(i) + 1
  END P1;

  PROCEDURE P2(i : INTEGER): BYTE;
  BEGIN
    RETURN SYSTEM.VAL(BYTE, i + 1)
  END P2;

  PROCEDURE Par1(b : BYTE);
  BEGIN
    Out.Int(b, 10)
  END Par1;

  PROCEDURE Par2(b : INTEGER);
  BEGIN
    Out.Int(b, 10)
  END Par2;

  PROCEDURE Ret1(): BYTE;
  VAR b: BYTE;
  BEGIN
    b := 8;
    RETURN b
  END Ret1;

  PROCEDURE Ret2(): INTEGER;
  BEGIN
    RETURN 800
  END Ret2;

  PROCEDURE P3;
    VAR x : INTEGER;
      y : BYTE;
      r : RECORD y : BYTE END;
      ar : ARRAY 1 OF BYTE;
  BEGIN
    Out.Int(P1(255), 10);
    Out.Int(P2(256), 10);
    Out.Ln;
    y := 255;
    Out.Int(y, 10);
    x := 129;
    Out.Int(x, 10);
    y := x;
    x := y + 1;
    Out.Int(x, 10);
    x := y;
    Out.Int(x, 10);
    Out.Ln;
    r.y := 255;
    Out.Int(r.y, 10);
    x := 129;
    Out.Int(x, 10);
    r.y := x;
    x := r.y + 1;
    Out.Int(x, 10);
    x := r.y;
    Out.Int(x, 10);
    Out.Ln;
    ar[0] := 255;
    Out.Int(ar[0], 10);
    x := 129;
    Out.Int(x, 10);
    ar[0] := x;
    x := ar[0] + 1;
    Out.Int(x, 10);
    x := ar[0];
    Out.Int(x, 10);
    x := y;
    IF x = y THEN Out.Int(1, 10) END
  END P3;

BEGIN
  Out.Int(P1(255), 10);
  Out.Int(P2(256), 10);
  Out.Ln;
  y := 255;
  Out.Int(y, 10);
  x := 129;
  Out.Int(x, 10);
  y := x;
  x := y + 1;
  Out.Int(x, 10);
  x := y;
  Out.Int(x, 10);
  Out.Ln;
  r.y := 255;
  Out.Int(r.y, 10);
  x := 129;
  Out.Int(x, 10);
  r.y := x;
  x := r.y + 1;
  Out.Int(x, 10);
  x := r.y;
  Out.Int(x, 10);
  Out.Ln;
  ar[0] := 255;
  Out.Int(ar[0], 10);
  x := 129;
  Out.Int(x, 10);
  ar[0] := x;
  x := ar[0] + 1;
  Out.Int(x, 10);
  x := ar[0];
  Out.Int(x, 10);
  x := y;
  IF x = y THEN Out.Int(1, 10) END;
  Out.Ln;
  P3;
  Out.Ln;
  Out.Int(Ret1(), 10);
  Out.Int(Ret2(), 10);
  Par1(8);
  Par2(800);
  y := 8;
  Out.Int(y, 10);
  x := 800;
  Out.Int(x, 10)
END TestByteType.
