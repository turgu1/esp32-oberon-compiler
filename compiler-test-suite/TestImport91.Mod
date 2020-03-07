MODULE TestImport91;
  IMPORT imp := TestImport90, Out;
  VAR i: INTEGER;
      str: ARRAY 10 OF CHAR;
BEGIN
  str := imp.h;
  i := 0;
  WHILE str[i] # 0X DO
    Out.Char(str[i]);
    INC(i)
  END ;
  Out.Char(imp.x);
  Out.Ln
END TestImport91.