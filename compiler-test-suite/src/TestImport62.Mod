MODULE TestImport62;
  IMPORT Out, TestImport60, TestImport61;
  VAR p1* : TestImport61.P1;
BEGIN
  NEW(p1);
  p1.y := "A";
  Out.Char(p1.y);
  IF p1 IS TestImport61.P1 THEN Out.Char("Y") END;
  Out.Real(TestImport60.PI, 10);
  Out.Int(TestImport60.N, 10)
END TestImport62.