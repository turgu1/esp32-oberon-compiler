MODULE Oberon;

  IMPORT Out, extArgs, ORP;

CONST
  DEBUG = FALSE;

TYPE
  Filename = ARRAY 256 OF CHAR;

VAR
  argCount : INTEGER;
  arg      : Filename;
  i        : INTEGER;
  res      : INTEGER;


  overrideSymbolFile : BOOLEAN;
  filePresent        : BOOLEAN;

  filename : Filename;

PROCEDURE Usage;
BEGIN
  Out.String("Usage: Oberon [-s] filename");
  Out.Ln;
END Usage;

BEGIN
  overrideSymbolFile := FALSE;
  filePresent        := FALSE;
  argCount           := extArgs.count;

  IF (argCount > 0) & (argCount <= 2) THEN
    i := 0;
    WHILE i < argCount DO
      extArgs.Get(i, arg, res);

      IF DEBUG THEN
        Out.String("Argument "); 
        Out.Int(i + 1, 0); 
        Out.String(": "); 
        Out.String(arg);
        Out.Ln;
      END;

      IF (arg = "-s") THEN
        overrideSymbolFile := TRUE;
        IF DEBUG THEN
          Out.String("Overriding Symbol File");
          Out.Ln;
        END
      ELSE
        filename    := arg;
        filePresent := TRUE;
      END;

      INC(i)
    END;

    IF filePresent THEN
      IF DEBUG THEN
        Out.String("Compiling "); 
        Out.String(filename); 
        Out.String("..."); 
        Out.Ln;
      END;
      
      ORP.Compile(filename, overrideSymbolFile);
    ELSE
      Usage;
    END
  ELSE
    Usage;
  END
END Oberon.