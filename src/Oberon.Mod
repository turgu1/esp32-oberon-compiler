MODULE Oberon;

  IMPORT SYSTEM, Out, extArgs, ORP;

CONST
  DEBUG = FALSE;

VAR
  argCount : INTEGER;
  i        : INTEGER;
  res      : INTEGER;

  outputFolder, filename, objName, arg : ARRAY 256 OF CHAR;
  importPath : ARRAY 1024 OF CHAR;

  overrideSymbolFile : BOOLEAN;
  generateCheckCode  : BOOLEAN; 
  filePresent        : BOOLEAN;
  verbose            : BOOLEAN;
  sourceToAssembly   : BOOLEAN;
  regOptimization    : BOOLEAN;
  regOptList         : BOOLEAN;

PROCEDURE Usage;
BEGIN
  Out.Ln;
  Out.String("Usage: OberonESP32 [-c][-l][-o folder][-O ObjectFileName][-p path][-s][-v][-x][-z] filename"); 
  Out.Ln; Out.Ln;
  Out.String("-c : Generate Verification Code"                            ); Out.Ln;
  Out.String("-l : Add source code to the assembler output"               ); Out.Ln;
  Out.String("-o : Output folder of generated code"                       ); Out.Ln;
  Out.String("-O : Object code filename"                                  ); Out.Ln;
  Out.String("-p : Folder Path for imported modules (e.g. f1:f2:f3)"      ); Out.Ln;
  Out.String("-s : Update Symbols File"                                   ); Out.Ln;
  Out.String("-v : Show compiler version and output information"          ); Out.Ln;
  Out.String("-x : Register use optimization"                             ); Out.Ln;
  Out.String("-z : Add Register optimization info to the assembler output"); Out.Ln
END Usage;

BEGIN

  IF (SYSTEM.SIZE(INTEGER) # 4) OR (SYSTEM.SIZE(REAL) # 4) THEN
    Out.Ln;
    Out.String("INTEGER or REAL not of size 4!!"); Out.Ln;
    Out.String("INTEGER: "); Out.Int(SYSTEM.SIZE(INTEGER), 0); Out.Ln;
    Out.String("REAL: "   ); Out.Int(SYSTEM.SIZE(REAL), 0);    Out.Ln
  ELSE
    overrideSymbolFile := FALSE;
    generateCheckCode  := FALSE;
    filePresent        := FALSE;
    verbose            := FALSE;
    sourceToAssembly   := FALSE;
    argCount           := extArgs.count;

    outputFolder := ".";
    objName := "";

    IF (argCount > 0) THEN
      i := 0;
      WHILE i < argCount DO
        extArgs.Get(i, arg, res);

        IF DEBUG THEN
          Out.String("Argument "); Out.Int(i + 1, 0); Out.String(": "); 
          Out.String(arg); Out.Ln
        END ;

        IF (arg = "-c") THEN
          generateCheckCode := TRUE;
          IF DEBUG THEN Out.String("Generating Check Code"); Out.Ln END
        ELSIF (arg = "-l") THEN
          sourceToAssembly := TRUE;
          IF DEBUG THEN Out.String("Add Source code to assembler output"); Out.Ln END
        ELSIF (arg = "-o") THEN
          INC(i);
          IF i < argCount THEN
            extArgs.Get(i, outputFolder, res);
            IF DEBUG THEN Out.String("Output Folder"); Out.Ln END
          END
        ELSIF (arg = "-O") THEN
          INC(i);
          IF i < argCount THEN
            extArgs.Get(i, objName, res);
            IF DEBUG THEN Out.String("Object Filename"); Out.Ln END
          END
        ELSIF (arg = "-p") THEN
          INC(i);
          IF i < argCount THEN
            extArgs.Get(i, importPath, res);
            IF DEBUG THEN Out.String("Import Path"); Out.Ln END
          END
        ELSIF (arg = "-s") THEN
          overrideSymbolFile := TRUE;
          IF DEBUG THEN Out.String("Overriding Symbol File"); Out.Ln END
        ELSIF (arg = "-v") THEN
          verbose := TRUE;
          IF DEBUG THEN Out.String("Generating Check Code"); Out.Ln END
        ELSIF (arg = "-x") THEN
          regOptimization := TRUE;
          IF DEBUG THEN Out.String("Register Optimization"); Out.Ln END
        ELSIF (arg = "-z") THEN
          regOptList := TRUE;
          IF DEBUG THEN Out.String("Reg Opt output to assembler output"); Out.Ln END
        ELSIF arg[0] # "-" THEN
          filename    := arg;
          filePresent := TRUE;
        ELSE
          i := argCount
        END ;

        INC(i)
      END ;

      IF filePresent THEN
        IF verbose THEN
          Out.String("Compiling "); Out.String(filename); Out.String(" ..."); Out.Ln
        END ;
        
        ORP.Compile(  (* Never return *)
          filename, 
          overrideSymbolFile,
          generateCheckCode, 
          regOptimization,
          regOptList,
          verbose,
          sourceToAssembly,
          outputFolder,
          importPath,
          objName)
      ELSE
        Usage
      END
    ELSE
      Usage
    END
  END
END Oberon.