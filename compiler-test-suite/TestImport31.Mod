MODULE TestImport31;
  IMPORT Out;
IMPORT TestImport30;
  VAR y : TestImport30.T;
BEGIN
  y := TestImport30.x;
  Out.Char(y.c)
END TestImport31.