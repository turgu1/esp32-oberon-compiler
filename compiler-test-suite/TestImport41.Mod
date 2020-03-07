MODULE TestImport41;
  IMPORT Out;
IMPORT TestImport40;
  PROCEDURE P*(VAR t: TestImport40.T);
  BEGIN Out.Int(t.x)
  END P;
END TestImport41.