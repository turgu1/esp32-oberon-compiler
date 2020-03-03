MODULE Oberon;

  IMPORT SYSTEM, Out, extArgs, ORP;

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
  generateCheckCode  : BOOLEAN; 
  filePresent        : BOOLEAN;

  filename : Filename;

PROCEDURE Usage;
BEGIN
  Out.Ln;
  Out.String("Usage: Oberon [-s][-c] filename"); Out.Ln;
  Out.String("-s : Update Symbols File"       ); Out.Ln;
  Out.String("-c : Generate Verification Code"); Out.Ln;
END Usage;

BEGIN

  IF (SYSTEM.SIZE(INTEGER) # 4) OR
     (SYSTEM.SIZE(REAL) # 4) THEN
     Out.Ln;
     Out.String("INTEGER or REAL not of size 4!!"); Out.Ln;
     Out.String("INTEGER: "); Out.Int(SYSTEM.SIZE(INTEGER), 0); Out.Ln;
     Out.String("REAL: "   ); Out.Int(SYSTEM.SIZE(REAL), 0);    Out.Ln;
  ELSE
    overrideSymbolFile := FALSE;
    generateCheckCode  := FALSE;
    filePresent        := FALSE;
    argCount           := extArgs.count;

    IF (argCount > 0) & (argCount <= 3) THEN
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
        ELSIF (arg = "-c") THEN
          generateCheckCode := TRUE;
          IF DEBUG THEN
            Out.String("Generating Check Code");
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
        
        ORP.Compile(filename, overrideSymbolFile, generateCheckCode);
      ELSE
        Usage;
      END
    ELSE
      Usage;
    END
  END
END Oberon.