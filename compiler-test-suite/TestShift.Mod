MODULE TestShift;
  IMPORT Out;

  VAR x : INTEGER;
   
BEGIN
  x := 8;
  Out.Int(LSL(x, x DIV 4));
  Out.Int(ASR(x, 1));
  Out.Int(ROR(65280, x))
END TestShift.