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
  Out.Real(a);
  a := ABS(b);
  Out.Real(a);
  x := ABS(i);
  Out.Int(x);
  x := ABS(y);
  Out.Int(x);
  Out.Ln;
  b := 7.3;
  y := 8;
  Out.Real(ABS(b));
  Out.Int(ABS(y));
  z := 10;
  Out.Int(ABS(z))
END TestABS.