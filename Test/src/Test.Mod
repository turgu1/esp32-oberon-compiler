MODULE Test;
  IMPORT Test2, Test3;
VAR
  a,b,c,d: INTEGER;
  i : INTEGER;

PROCEDURE Toto*(i, j: INTEGER);
BEGIN
END Toto;

PROCEDURE [5] IntRoutine;
BEGIN
END IntRoutine;

BEGIN
  Toto(i,Test2.aa);
  i := Test2.Add(1, 2);
  i := Test3.Div(3, 4);
END Test.

