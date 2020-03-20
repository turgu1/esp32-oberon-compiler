MODULE TestTypeConvFun;
  IMPORT Out;

  CONST c2 = "A";
  VAR x : REAL;
      y : INTEGER;
      c : CHAR;
      b : BOOLEAN;
      s : SET;
   
BEGIN
  x := 8.9;
  y := 6;
  c := "A";
  b := TRUE;
  s := {1};
  Out.Int(FLOOR(8.9), 10);
  Out.Int(FLOOR(x), 10);
  Out.Real(FLT(6), 10);
  Out.Real(FLT(y), 10);
  Out.Int(ORD(c), 10);
  Out.Int(ORD(c2), 10);
  Out.Int(ORD("A"), 10);
  Out.Int(ORD(b), 10);
  Out.Int(ORD(s), 10);
  Out.Int(ORD("A") + 1, 10);
  Out.Char(CHR(ORD(c) + 1));
  c := CHR(ORD(c) + 2);
  Out.Char(c);
END TestTypeConvFun.