MODULE ProcVariables4;
  IMPORT Out;
  TYPE P0 = PROCEDURE(VAR x : REAL) : INTEGER;
       P1 = PROCEDURE(VAR x : REAL; VAR y : P0) : INTEGER;
       P2 = PROCEDURE(VAR x : REAL; y : PROCEDURE(VAR x : REAL) : INTEGER) : INTEGER;
       P3 = PROCEDURE(VAR x : REAL; VAR y : PROCEDURE(VAR x : REAL) : INTEGER) : INTEGER;
VAR v: P0;
    v1: P1;
    v2: P2;
    v3: P3;
    f: REAL;

PROCEDURE Floor(VAR x : REAL) : INTEGER;
  RETURN FLOOR(x)
END Floor;

PROCEDURE Floor1(VAR x : REAL; VAR y : P0) : INTEGER;
  RETURN y(x)
END Floor1;

PROCEDURE Floor2(VAR x : REAL; y : PROCEDURE(VAR x : REAL) : INTEGER) : INTEGER;
  RETURN y(x)
END Floor2;

PROCEDURE Floor3(VAR x : REAL; VAR y : PROCEDURE(VAR x : REAL) : INTEGER) : INTEGER;
  RETURN y(x)
END Floor3;

BEGIN
  f := 8.5;
  v := Floor;
  (* Out.Int(Floor(8.0)); ERROR: read-only *) 
  Out.Int(v(f), 10); (* 8 *) 
  f := 9.5;
  v1 := Floor1;
  Out.Int(v1(f, v), 10); (* 9 *) 
  f := 10.5;
  v2 := Floor2;
  Out.Int(v2(f, v), 10); (* 10 *) 
  v3 := Floor3;
  (* Out.Int(v3(f, v)); ERROR: incompatible parameters (see rule E)) *) 
END ProcVariables4.