MODULE DivMul;
  IMPORT Out;
  CONST eight = 8;

  PROCEDURE PrintDiv(a,b : INTEGER);
  BEGIN
    Out.Int(a);
    Out.Int(b);
    Out.Int(a DIV b);
    Out.Int(a MOD b);
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
    Out.Int(10 DIV 8);
    Out.Int(10 MOD eight);
    Out.Ln;
    x := 8;
    Out.Int(10 DIV x);
    Out.Int(10 MOD x);
    x := 10;
    Out.Int(x DIV 8);
    Out.Int(x MOD eight);
    y := 8;
    Out.Int(x DIV y);
    Out.Int(x MOD y);
    Out.Ln;
    a[0] := 8;
    Out.Int(10 DIV a[0]);
    Out.Int(10 MOD a[0]);
    a[0] := 10;
    Out.Int(a[0] DIV 8);
    Out.Int(a[0] MOD eight);
    a[1] := 8;
    Out.Int(a[0] DIV a[1]);
    Out.Int(a[0] MOD a[1]);
  END Division;
  
  PROCEDURE Multiplication; 
    TYPE V = RECORD x : INTEGER END;
    VAR x,y : INTEGER;
        a : ARRAY 2 OF INTEGER;
        b : V;
  BEGIN
    Out.Int(4 * 8);
    Out.Int(4 * eight);
    Out.Ln;
    x := 8;
    b.x := 8;
    Out.Int(4 * x);
    Out.Int(4 * b.x);
    x := 4;
    b.x := 4;
    Out.Int(x * 8);
    Out.Int(b.x * eight);
    y := 8;
    Out.Int(x * y);
    Out.Int(y * b.x);
    Out.Ln;
    a[0] := 8;
    Out.Int(4 * a[0]);
    Out.Int(b.x * a[0]);
    a[0] := 4;
    b.x := 8;
    Out.Int(a[0] * 8);
    Out.Int(a[0] * b.x);
    a[1] := 8;
    Out.Int(a[0] * a[1]);
  END Multiplication;
BEGIN
  Division;
  Out.Ln;
  Multiplication
END DivMul.