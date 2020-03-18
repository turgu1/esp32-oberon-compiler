MODULE DivMul;
  IMPORT Out;
  CONST eight = 8;

  PROCEDURE PrintDiv(a,b : INTEGER);
  BEGIN
    Out.Int(a, 10);
    Out.Int(b, 10);
    Out.Int(a DIV b, 10);
    Out.Int(a MOD b, 10);
    Out.Ln
  END PrintDiv;
  
  PROCEDURE Division; 
    VAR x,y : INTEGER;
        a : ARRAY 2 OF INTEGER;
  BEGIN
    PrintDiv(8, 3);
    PrintDiv(8, -3);
    PrintDiv(-8, 3);
    PrintDiv(-8, -3);
    PrintDiv(1, 2);
    PrintDiv(1, -2);
    PrintDiv(-1, 2);
    PrintDiv(-1, -2);
    Out.Int(10 DIV 8, 10);
    Out.Int(10 MOD eight, 10);
    Out.Ln;
    x := 8;
    Out.Int(10 DIV x, 10);
    Out.Int(10 MOD x, 10);
    x := 10;
    Out.Int(x DIV 8, 10);
    Out.Int(x MOD eight, 10);
    y := 8;
    Out.Int(x DIV y, 10);
    Out.Int(x MOD y, 10);
    Out.Ln;
    a[0] := 8;
    Out.Int(10 DIV a[0], 10);
    Out.Int(10 MOD a[0], 10);
    a[0] := 10;
    Out.Int(a[0] DIV 8, 10);
    Out.Int(a[0] MOD eight, 10);
    a[1] := 8;
    Out.Int(a[0] DIV a[1], 10);
    Out.Int(a[0] MOD a[1], 10);
  END Division;
  
  PROCEDURE Multiplication; 
    TYPE V = RECORD x : INTEGER END;
    VAR x,y : INTEGER;
        a : ARRAY 2 OF INTEGER;
        b : V;
  BEGIN
    Out.Int(4 * 8, 10);
    Out.Int(4 * eight, 10);
    Out.Ln;
    x := 8;
    b.x := 8;
    Out.Int(4 * x, 10);
    Out.Int(4 * b.x, 10);
    x := 4;
    b.x := 4;
    Out.Int(x * 8, 10);
    Out.Int(b.x * eight, 10);
    y := 8;
    Out.Int(x * y, 10);
    Out.Int(y * b.x, 10);
    Out.Ln;
    a[0] := 8;
    Out.Int(4 * a[0], 10);
    Out.Int(b.x * a[0], 10);
    a[0] := 4;
    b.x := 8;
    Out.Int(a[0] * 8, 10);
    Out.Int(a[0] * b.x, 10);
    a[1] := 8;
    Out.Int(a[0] * a[1], 10);
  END Multiplication;
BEGIN
  Division;
  Out.Ln;
  Multiplication
END DivMul.