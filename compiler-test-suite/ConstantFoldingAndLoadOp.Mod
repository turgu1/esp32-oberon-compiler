MODULE ConstantFoldingAndLoadOp;
  IMPORT Out;
  CONST con = 100;
  TYPE
    V = RECORD
          x : ARRAY 10 OF INTEGER;
        END;
  VAR
    i,j : INTEGER;
    c : ARRAY 2 OF INTEGER;
    d : V;
    e : ARRAY 2 OF BOOLEAN;
    b : BOOLEAN;

  PROCEDURE PrintBool(x : BOOLEAN);
  BEGIN IF x THEN Out.Int(1) ELSE Out.Int(0) END;
  END PrintBool;
BEGIN
  j := 2;
  c[0] := 3;
  d.x[0] := 4;
  e[0] := TRUE;
  i := 2 * 3 + 10 DIV 2;
  Out.Int(i);
  i := 2*c[0];
  Out.Int(i);
  i := 2*d.x[0];
  Out.Int(i);
  i := 2*con;
  Out.Int(i);
  i := j*c[0];
  Out.Int(i);
  i := j*d.x[0];
  Out.Int(i);
  i := j*con;
  Out.Int(i);
  Out.Ln;
  i := c[0] - 2;
  Out.Int(i);
  i := d.x[0] - 2;
  Out.Int(i);
  i := con - 2;
  Out.Int(i);
  i := c[0] - j;
  Out.Int(i);
  i := d.x[0] - j;
  Out.Int(i);
  i := con - j;
  Out.Int(i);
  i := con + 0;
  Out.Int(i);
  i := con - 0;
  Out.Int(i);
  Out.Ln;
  b := TRUE & e[0];
  PrintBool(b);
  b := b & e[0];
  PrintBool(b);
  b := e[0] & TRUE;
  PrintBool(b);
  b := e[0] & b;
  PrintBool(b);
  b := (TRUE & e[0]) OR e[0];
  PrintBool(b);
  b := TRUE OR TRUE;
  PrintBool(b);
END ConstantFoldingAndLoadOp.