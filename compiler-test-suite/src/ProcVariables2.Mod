MODULE ProcVariables2;
  IMPORT Out;
  TYPE 
    MyFun = PROCEDURE(x : INTEGER) : INTEGER;
    R = RECORD 
          i : INTEGER; 
          p : ARRAY 2 OF PROCEDURE(x : INTEGER) : INTEGER
        END;
    R1 = RECORD(R) j : CHAR END;
  VAR
    r : R;
    k : R1;
    i : BYTE;
    f : MyFun;

  PROCEDURE F1(x : INTEGER) : INTEGER;
    RETURN x+1
  END F1;
  
  PROCEDURE F2(x : INTEGER) : INTEGER;
    RETURN x+2
  END F2;
  
  PROCEDURE P1(x : INTEGER; y : MyFun) : INTEGER;
    RETURN y(x)
  END P1;
  
  PROCEDURE P2(x : INTEGER; VAR y : MyFun) : INTEGER;
    RETURN y(x)
  END P2;
  
  PROCEDURE Run;
    VAR
      r0 : R;
      k0 : R1;
      f0 : MyFun;
  BEGIN
    k0.i := 1;
    k0.p[0] := F1;
    k0.p[1] := F2;
    r0 := k0;
    FOR i := 0 TO 1 DO
      Out.Int(r0.p[i](r0.i), 10)
    END;
  Out.Ln;
  Out.Int(P1(1, F1), 10);
  f0 := F2;
  Out.Int(P2(1, f0), 10)
  END Run;
BEGIN
  Run;
  Out.Ln;
  k.i := 1;
  k.p[0] := F1;
  k.p[1] := F2;
  r := k;
  FOR i := 0 TO 1 DO
    Out.Int(r.p[i](r.i), 10)
  END;
  Out.Ln;
  Out.Int(P1(1, F1), 10);
  f := F2;
  Out.Int(P2(1, f), 10)
END ProcVariables2.