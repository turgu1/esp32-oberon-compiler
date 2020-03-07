MODULE TestExprVarPar;
  IMPORT Out;
  VAR a: INTEGER;

  PROCEDURE G(VAR i: INTEGER); END G;

BEGIN
  G(a+1)
END TestExprVarPar.
