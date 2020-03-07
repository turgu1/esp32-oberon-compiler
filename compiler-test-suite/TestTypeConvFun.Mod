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
  Out.Int(FLOOR(8.9));
  Out.Int(FLOOR(x));
  Out.Real(FLT(6));
  Out.Real(FLT(y));
  Out.Int(ORD(c));
  Out.Int(ORD(c2));
  Out.Int(ORD("A"));
  Out.Int(ORD(b));
  Out.Int(ORD(s));
  Out.Int(ORD("A") + 1);
  Out.Char(CHR(ORD(c) + 1));
  c := CHR(ORD(c) + 2);
  Out.Char(c);
END TestTypeConvFun.