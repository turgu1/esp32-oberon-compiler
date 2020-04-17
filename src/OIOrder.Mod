MODULE OIOrder;

  IMPORT Files, Texts, Out, extArgs, SYS;

(* Oberon Init Code Ordering *)

  CONST DEBUG = FALSE;

  TYPE
    Ident = ARRAY 64 OF CHAR;
    KeyStr = ARRAY 9 OF CHAR;
    Mod = RECORD name: Ident; key: KeyStr; initialized: BOOLEAN END;
    ModNode = RECORD mod: POINTER TO Mod; prev: POINTER TO ModNode END;
    ArgStr = ARRAY 256 OF CHAR;
  VAR
    importPaths: ARRAY 20, 256 OF CHAR;
    outputFolder, outputName : ArgStr;
    filePresent: BOOLEAN;
    Head: POINTER TO ModNode;

  PROCEDURE DecodePath(impPath: ARRAY OF CHAR);
    VAR i, j, k: INTEGER;
  BEGIN
    importPaths[0] := ".";
    i := 1; j := 0; k := 0;
    WHILE (i < LEN(importPaths)) & (j < LEN(impPath)) & (impPath[j] # 0X) DO
      IF impPath[j] = ":" THEN
        importPaths[i][k] := 0X; k := 0; INC(i)
      ELSE
        importPaths[i][k] := impPath[j]; INC(k)
      END;
      INC(j)
    END;
    IF i < LEN(importPaths) THEN
      importPaths[i][k] := 0X; INC(i);
      WHILE i < 10 DO importPaths[i][0] := 0X; INC(i) END
    END
  END DecodePath;

  PROCEDURE MakeFileName*(VAR FName: ARRAY OF CHAR; folder, name, ext: ARRAY OF CHAR);
    VAR 
      i, j: INTEGER;
  BEGIN 
    i := 0; j := 0;  (*assume name suffix less than 4 characters*)
    WHILE (j < LEN(FName) - 5) & (folder[j] # 0X) DO FName[j] := folder[j]; INC(j) END;
    IF (j > 0) & (FName[j - 1] # "/") THEN FName[j] := "/"; INC(j) END;
    WHILE (j < LEN(FName) - 5) & (name[i] # 0X) DO FName[j] := name[i]; INC(i); INC(j) END ;
    i := 0;
    WHILE ext[i] # 0X DO FName[j] := ext[i]; INC(i); INC(j) END;
    FName[j] := 0X
  END MakeFileName;

  PROCEDURE FindFileName*(VAR FName: ARRAY OF CHAR; name, ext: ARRAY OF CHAR);
    VAR 
      i: INTEGER;
      found: BOOLEAN;
  BEGIN
    i := 0;
    found := FALSE;
    WHILE (i < LEN(importPaths)) & (importPaths[i][0] # 0X) & ~found DO
      MakeFileName(FName, importPaths[i], name, ext);
      found := Files.Old(FName) # NIL;
      INC(i);
    END
  END FindFileName;

  PROCEDURE ProcessImpFile(filename: ArgStr);
  BEGIN
  END ProcessImpFile;

  PROCEDURE CompleteInfo;
    VAR
      filename: ArgStr;

  BEGIN
  END CompleteInfo;

  PROCEDURE Usage;
  BEGIN
    Out.Ln;
    Out.String("Usage: OISeq [-o folder][-p path] -O OutputFileName {smb-filename ...}"); 
    Out.Ln; Out.Ln;
    Out.String("-o : Output folder of generated code"                 ); Out.Ln;
    Out.String("-O : Output init table filename"                      ); Out.Ln;
    Out.String("-p : Folder Path for imported modules (e.g. f1:f2:f3)"); Out.Ln;

    SYS.Exit(1)
  END Usage;

  PROCEDURE ProcessCommand;
    VAR
      res, i, argCount: INTEGER;
      arg, importPath, filename : ArgStr;
      firstFilename: BOOLEAN;
  BEGIN
    argCount := extArgs.count;

    outputFolder  := ".";
    outputName    := "";
    importPath    := "";
    firstFilename := TRUE;
  
    IF (argCount > 0) THEN
      i := 0;
      WHILE i < argCount DO
        extArgs.Get(i, arg, res);
  
        IF DEBUG THEN
          Out.String("Argument "); Out.Int(i + 1, 0); Out.String(": "); 
          Out.String(arg); Out.Ln
        END;
  
        IF (arg = "-o") THEN INC(i);
          IF i < argCount THEN
            extArgs.Get(i, outputFolder, res);
            IF DEBUG THEN Out.String("Output Folder"); Out.Ln END
          END
        ELSIF (arg = "-O") THEN INC(i);
          IF i < argCount THEN
            extArgs.Get(i, outputName, res);
            IF DEBUG THEN Out.String("Output Filename"); Out.Ln END
          END
        ELSIF (arg = "-p") THEN INC(i);
          IF i < argCount THEN
            extArgs.Get(i, importPath, res);
            IF DEBUG THEN Out.String("Import Path"); Out.Ln END
          END
        ELSIF arg[0] # "-" THEN
          IF outputName[0] # 0X THEN
            filename := arg;
            IF firstFilename THEN
              firstFilename := FALSE;
              DecodePath(importPath, outputFolder)
            END;
            ProcessImpFile(filename);
            filePresent := TRUE;
          ELSE
            Out.Ln; Out.String("Error: Output Filename required (-O).");
            Usage
          END
        ELSE
          i := argCount
        END;
  
        INC(i)
      END (* WHILE *)
    ELSE
      Usage
    END (* IF *)
  END ProcessCommand;

BEGIN
  Head := NIL;
  ProcessCommand;
  IF filePresent THEN 
    CompleteInfo
  ELSE
    Out.Ln; Out.String("Error: At least one filename required.");
    Usage
  END;

  SYS.Exit(0);
END OIOrder.