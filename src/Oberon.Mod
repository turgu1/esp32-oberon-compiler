MODULE Oberon;

  IMPORT SYSTEM, Out, extArgs, ORP;

CONST
  DEBUG = FALSE;

VAR
  argCount : INTEGER;
  i        : INTEGER;
  res      : INTEGER;
  outputFolder, filename, arg, importPath : ARRAY 256 OF CHAR;

  overrideSymbolFile : BOOLEAN;
  generateCheckCode  : BOOLEAN; 
  filePresent        : BOOLEAN;
  verbose            : BOOLEAN;

PROCEDURE Usage;
BEGIN
  Out.Ln;
  Out.String("Usage: Oberon [-c][-o folder][-p path][-s][-v] filename"); Out.Ln;
  Out.String("-c : Generate Verification Code"                        ); Out.Ln;
  Out.String("-o : Output folder of generated code"                   ); Out.Ln;
  Out.String("-p : Folder Path for imported modules (e.g. f1:f2:f3)"  ); Out.Ln;
  Out.String("-s : Update Symbols File"                               ); Out.Ln;
  Out.String("-v : Show compiler version and output information"      ); Out.Ln;
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
    verbose            := FALSE;
    argCount           := extArgs.count;

    IF (argCount > 0) THEN
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

        IF (arg = "-c") THEN
          generateCheckCode := TRUE;
          IF DEBUG THEN
            Out.String("Generating Check Code");
            Out.Ln;
          END
        ELSIF (arg = "-o") THEN
          INC(i);
          IF i < argCount THEN
            extArgs.Get(i, outputFolder, res);
            IF DEBUG THEN
              Out.String("Output Folder");
              Out.Ln;
            END
          END
        ELSIF (arg = "-p") THEN
          INC(i);
          IF i < argCount THEN
            extArgs.Get(i, importPath, res);
            IF DEBUG THEN
              Out.String("Import Path");
              Out.Ln;
            END
          END
        ELSIF (arg = "-s") THEN
          overrideSymbolFile := TRUE;
          IF DEBUG THEN
            Out.String("Overriding Symbol File");
            Out.Ln;
          END
        ELSIF (arg = "-s") THEN
          overrideSymbolFile := TRUE;
          IF DEBUG THEN
            Out.String("Overriding Symbol File");
            Out.Ln;
          END
        ELSIF (arg = "-v") THEN
          verbose := TRUE;
          IF DEBUG THEN
            Out.String("Generating Check Code");
            Out.Ln;
          END
        ELSIF arg[0] # "-" THEN
          filename    := arg;
          filePresent := TRUE;
        ELSE
          i := argCount
        END;

        INC(i)
      END;

      IF filePresent THEN
        IF verbose THEN
          Out.String("Compiling "); 
          Out.String(filename); 
          Out.String("..."); 
          Out.Ln;
        END;
        
        ORP.Compile(
          filename, 
          overrideSymbolFile, 
          generateCheckCode, 
          verbose,
          outputFolder,
          importPath);
      ELSE
        Usage;
      END
    ELSE
      Usage;
    END
  END
END Oberon.