MODULE TestShift;
  IMPORT Out;

  VAR x : INTEGER;
   
BEGIN
  x := 8;
  Out.Int(LSL(x, x DIV 4), 10);
  Out.Int(ASR(x, 1), 10);
  Out.Int(ROR(65280, x), 10)
END TestShift.