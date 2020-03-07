MODULE TestByteType;
  IMPORT Out;
  VAR x : INTEGER;
      y : BYTE;
      r : RECORD y : BYTE END;
      ar : ARRAY 1 OF BYTE;

  PROCEDURE P1(i : BYTE): INTEGER;
  BEGIN
    RETURN i + 1
  END P1;

  PROCEDURE P2(i : INTEGER): BYTE;
  BEGIN
    RETURN i + 1
  END P2;

  PROCEDURE Par1(b : BYTE);
  BEGIN
    Out.Int(b)
  END Par1;

  PROCEDURE Par2(b : INTEGER);
  BEGIN
    Out.Int(b)
  END Par2;

  PROCEDURE Ret1(): BYTE;
  BEGIN
    RETURN 8
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
    Out.Int(P1(255));
    Out.Int(P2(256));
    Out.Ln;
    y := 255;
    Out.Int(y);
    x := 129;
    Out.Int(x);
    y := x;
    x := y + 1;
    Out.Int(x);
    x := y;
    Out.Int(x);
    Out.Ln;
    r.y := 255;
    Out.Int(r.y);
    x := 129;
    Out.Int(x);
    r.y := x;
    x := r.y + 1;
    Out.Int(x);
    x := r.y;
    Out.Int(x);
    Out.Ln;
    ar[0] := 255;
    Out.Int(ar[0]);
    x := 129;
    Out.Int(x);
    ar[0] := x;
    x := ar[0] + 1;
    Out.Int(x);
    x := ar[0];
    Out.Int(x);
    x := y;
    IF x = y THEN Out.Int(1) END
  END P3;

BEGIN
  Out.Int(P1(255));
  Out.Int(P2(256));
  Out.Ln;
  y := 255;
  Out.Int(y);
  x := 129;
  Out.Int(x);
  y := x;
  x := y + 1;
  Out.Int(x);
  x := y;
  Out.Int(x);
  Out.Ln;
  r.y := 255;
  Out.Int(r.y);
  x := 129;
  Out.Int(x);
  r.y := x;
  x := r.y + 1;
  Out.Int(x);
  x := r.y;
  Out.Int(x);
  Out.Ln;
  ar[0] := 255;
  Out.Int(ar[0]);
  x := 129;
  Out.Int(x);
  ar[0] := x;
  x := ar[0] + 1;
  Out.Int(x);
  x := ar[0];
  Out.Int(x);
  x := y;
  IF x = y THEN Out.Int(1) END;
  Out.Ln;
  P3;
  Out.Ln;
  Out.Int(Ret1());
  Out.Int(Ret2());
  Par1(8);
  Par2(800);
  y := 8;
  Out.Int(y);
  x := 800;
  Out.Int(x)
END TestByteType.
