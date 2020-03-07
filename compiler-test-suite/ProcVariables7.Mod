MODULE ProcVariables7;
  IMPORT Out;
  TYPE
    ProcA = PROCEDURE;
    ProcB = PROCEDURE;

  VAR
    a: ProcA;

  PROCEDURE A;
  BEGIN
    Out.Char("A")
  END A;


  PROCEDURE B;
  BEGIN
    Out.Char("B")
  END B;

  PROCEDURE C(x: PROCEDURE(b: BYTE; c: CHAR; r: REAL));
  BEGIN
    Out.Char("C")
  END C;

BEGIN
  a := NIL;
  a := A;
  a();
  a := B;
  a;
  C(NIL)
END ProcVariables7.
