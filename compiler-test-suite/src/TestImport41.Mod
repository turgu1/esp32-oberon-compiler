MODULE TestImport41;
  IMPORT Out, TestImport40;
  PROCEDURE P*(VAR t: TestImport40.T);
  BEGIN Out.Int(t.x, 10)
  END P;
END TestImport41.