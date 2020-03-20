MODULE TestImport22;
  IMPORT Out, TestImport20, TestImport21;
  VAR
    x : TestImport20.R;
    y : TestImport21.X;
BEGIN
  x.u := 8;
  y := x;
  Out.Int(y.u, 10);
END TestImport22.