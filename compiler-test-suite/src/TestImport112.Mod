MODULE TestImport112;
  IMPORT TestImport110, TestImport111, Out;
  VAR
    x: TestImport110.X;
    y: TestImport111.Y;

BEGIN
  y := TestImport111.TWELVE;
  x.i := y;
  Out.Int(x.i, 10)
END TestImport112.