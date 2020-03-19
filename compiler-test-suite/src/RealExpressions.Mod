MODULE RealExpressions;
  IMPORT Out;
  CONST NaN* = 0.0 / 0.0;
  PROCEDURE One() : REAL;
    RETURN 1.0
  END One;
  PROCEDURE Arithmetic;
    VAR  r, x, y : REAL;
  BEGIN
    x := 3.0;
    y := 2.0;
    r := x + y + One();
    Out.Real(r, 10); Out.Ln;
    r := x - y;
    Out.Real(r, 10); Out.Ln;
    r := x * y;
    Out.Real(r, 10); Out.Ln;
    r := x / y;
    Out.Real(r, 10); Out.Ln;
    Out.Real(3.5 + 10.0 * 2.0); Out.Ln
  END Arithmetic;
  PROCEDURE Relations;
    VAR  x, y : REAL;
  BEGIN
    x := 3.0;
    y := NaN;
    IF x = y THEN Out.Int(1, 10) END;
    IF x <= y THEN Out.Int(1, 10) END;
    IF x < y THEN Out.Int(1, 10) END;
    IF x >= y THEN Out.Int(1, 10) END;
    IF x > y THEN Out.Int(1, 10) END;
    y := 1.E0;
    IF x = y THEN Out.Int(1, 10) END;
    IF x <= y THEN Out.Int(2, 10) END;
    IF x < y THEN Out.Int(3, 10) END;
    IF x >= y THEN Out.Int(4, 10) END;
    IF x > y THEN Out.Int(5, 10) END;
    Out.Ln
  END Relations;
BEGIN
  Arithmetic;
  Relations
END RealExpressions.
