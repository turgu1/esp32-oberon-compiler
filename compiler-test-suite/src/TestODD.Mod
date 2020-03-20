MODULE TestODD;
  IMPORT Out;

  VAR x: INTEGER;
      y: SET;
   
BEGIN
  x := 14;
  y := {1..20};
  IF ODD(8) THEN Out.Int(1, 10) END;
  IF ODD(9) THEN Out.Int(2, 10) END;
  IF ~ODD(8) THEN Out.Int(3, 10) END;
  IF ODD(x) OR (x IN y) & (x > 8) THEN Out.Int(4, 10) END
END TestODD.