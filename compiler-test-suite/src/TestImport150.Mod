MODULE TestImport150;
  IMPORT Out;

  TYPE
    Rec150* = RECORD
                a*: INTEGER;
              END ;

  PROCEDURE Two*;
  BEGIN
    Out.Int(2, 10); Out.Ln
  END Two;
END TestImport150.