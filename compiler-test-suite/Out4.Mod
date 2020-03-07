MODULE Out4;
  IMPORT Out;
  TYPE
    R0 = RECORD x, y : INTEGER END;
    R1 = RECORD r0 : R0 END;
    R8 = RECORD x : ARRAY 2 OF INTEGER END;
    R9 = ARRAY 3 OF INTEGER;
    R11 = RECORD v : ARRAY 4 OF R0 END;
    ARR = ARRAY 2 OF R11;
  VAR
    i : INTEGER;

  PROCEDURE P0();
    VAR
      a : R8;
      b : R9;
      j : INTEGER;
      r1 : R1;
      s : ARR;
    PROCEDURE P1(o : BOOLEAN ; VAR z0, z2, z3 : INTEGER; VAR z1 : R9; VAR s : ARR);
    BEGIN
      o := TRUE;
      z0 := 20;
      z1[2] := 23;
      z2 := 21;
      z3 := 22;
      z0 := s[i].v[3].x + 6;
      s[i].v[3].x  := z0 + 4;
    END P1;
  BEGIN
    i := 1;
    j := 10;
    Out.Int(j);
    a.x[1] := 11;
    Out.Int(a.x[1]);
    r1.r0.x := 12;
    Out.Int(r1.r0.x);
    b[2] := 13;
    Out.Int(b[2]);
    s[i].v[3].x := 14;
    Out.Int(s[i].v[3].x);
    P1(TRUE, j, a.x[1], r1.r0.x, b, s);
    Out.Int(j);
    Out.Int(a.x[1]);
    Out.Int(r1.r0.x);
    Out.Int(b[2]);
    Out.Int(s[i].v[3].x)
  END P0;

  PROCEDURE P9(o : BOOLEAN ; VAR z0 : INTEGER);
  BEGIN
    o := FALSE;
    z0 := z0 + 1;
    IF z0 # 4 THEN P9(o, z0) END
  END P9;
  PROCEDURE P10(VAR z0 : INTEGER);
  BEGIN
    z0 := z0 + 10
  END P10;

  PROCEDURE P8();
    VAR
      a, i, j : INTEGER;
      s : ARR;
  BEGIN
    a := 1;
    Out.Int(a);
    P9(TRUE, a);
    Out.Int(a);
    i := 1; j := 1;
    s[i*1].v[j-1].x := 90;
    P10(s[i*1].v[j-1].x);
    Out.Int(s[i*1].v[j-1].x)
  END P8;
BEGIN
  P8(); P0()
END Out4.