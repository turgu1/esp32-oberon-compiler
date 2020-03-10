MODULE TestReturn0;
  IMPORT Out;

  VAR x: INTEGER;
     
  PROCEDURE P1(): INTEGER;
  BEGIN RETURN x
  END P1;

  PROCEDURE P2(): INTEGER;
    RETURN x
  END P2;

  PROCEDURE P3(): INTEGER;
  VAR dummy: INTEGER;
    RETURN x+dummy
  END P3;
BEGIN
  x := 1;
  Out.Int(P1());
  Out.Int(P2());
  Out.Int(P3());
END TestReturn0.
