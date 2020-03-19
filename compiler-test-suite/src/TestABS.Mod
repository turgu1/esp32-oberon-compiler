MODULE TestABS;
  IMPORT Out;
  CONST r = -1.2; i = -2;
  VAR x, y : INTEGER;
      a, b : REAL;
      z : BYTE;
   
BEGIN
  b := r;
  y := i;
  a := ABS(r);
  Out.Real(a, 10);
  a := ABS(b);
  Out.Real(a, 10);
  x := ABS(i);
  Out.Int(x, 10);
  x := ABS(y);
  Out.Int(x, 10);
  Out.Ln;
  b := 7.3;
  y := 8;
  Out.Real(ABS(b), 10);
  Out.Int(ABS(y), 10);
  z := 10;
  Out.Int(ABS(z), 10)
END TestABS.