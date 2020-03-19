MODULE ProcVariables3;
   IMPORT Out;
 TYPE PT = PROCEDURE (m, n: INTEGER);
      REC = RECORD w: INTEGER; p: PT END;
      Object = POINTER TO REC;
  VAR obj: Object; a: ARRAY 4 OF PT;

  PROCEDURE P(m, n: INTEGER; q: PT; VAR obj: Object);
  BEGIN q(m, n); obj.p(m+1, n); a[m](m+2, n)
  END P;

  PROCEDURE X( x1,x2 : INTEGER);
  BEGIN
    Out.Int(x1, 10);
    Out.Int(x2, 10);
    Out.Ln;
  END X;

BEGIN
  NEW(obj);
  obj.p := X;
  a[1] := X;
  P(1, 8, X, obj)
END ProcVariables3.