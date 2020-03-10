MODULE TestImport131;
  IMPORT Out;

  IMPORT I:=TestImport130, TestImport130;
  VAR
    x: I.TypeD;
    y: TestImport130.TypeD;

BEGIN
  x.a := "@";
  x.d := 1;
  y := x;
  Out.Char(y.a); Out.Int(y.d)
END TestImport131.
