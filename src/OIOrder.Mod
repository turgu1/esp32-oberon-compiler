MODULE OIOrder;

  IMPORT Files, Texts, Out, extArgs, SYS;

(* Oberon Init Code Ordering *)

  CONST 
    DEBUG = FALSE;
    versionkey = 2;  (* .smb file version, as defined in ORB compiler module *)
  TYPE
    Ident   = ARRAY 64 OF CHAR;
    ModPtr  = POINTER TO ModNode;
    ModNode = RECORD name: Ident; key: INTEGER; initialized: BOOLEAN; next: ModPtr END;
    ArgStr  = ARRAY 256 OF CHAR;
  VAR
    importPaths: ARRAY 20, 256 OF CHAR;
    filePresent: BOOLEAN;
    head: ModPtr;
    outputFolder, outputName: ArgStr;

  PROCEDURE Error(msg: ARRAY OF CHAR);
  BEGIN
    Out.Ln; Out.String("Error: "); Out.String(msg); 
    SYS.Exit(1)
  END Error;

  PROCEDURE Error2(msg, msg2: ARRAY OF CHAR);
  BEGIN
    Out.Ln; Out.String("Error: "); Out.String(msg); Out.String(msg2); Out.Char(".");
    SYS.Exit(1)
  END Error2;
  
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

  PROCEDURE RemoveModNode(mod: ModPtr);
    VAR p: ModPtr;
  BEGIN
    p := head;
    IF head = mod THEN head := mod.next
    ELSE
      WHILE (p # NIL) & (p.next # mod) DO p := p.next END;
      IF p = NIL THEN Error("OIOrder Internal problem."); SYS.Exit(1)
      ELSE p := mod.next END
    END;
  END RemoveModNode;

  PROCEDURE GetModNode(moduleName: Ident) : ModPtr;
    VAR p, q: ModPtr;
  BEGIN
    p := head;
    q := NIL;
    WHILE (p # NIL) & (p.name # moduleName) DO q := p; p := p.next END;
    IF p = NIL THEN 
      NEW(p); p.initialized := FALSE; p.next := NIL;
      IF q = NIL THEN head := q ELSE q.next := p END;
     END;
    RETURN p
  END GetModNode;

  PROCEDURE Read(VAR R: Files.Rider; VAR x: INTEGER);
    VAR b: BYTE;
  BEGIN Files.Read(R, b);
    IF b < 80H THEN x := b ELSE x := b - 100H END
  END Read;
  
  PROCEDURE AdjustLocation(mod, mod2: ModPtr);
    VAR p, q, r: ModPtr;
  BEGIN
    p := head; q := NIL; r := NIL;
    WHILE p # mod DO
      IF p = mod2 THEN
        r := mod2;
        q.next := mod2.next;
        p := mod;
      ELSE
        q := p;
        p := p.next;
      END
    END;
    IF r # NIL THEN
      r.next := mod.next; mod.next := r
    END
  END AdjustLocation;

  PROCEDURE ProcessModule(moduleName: Ident);
    VAR 
      version,
      cnt:       INTEGER;
      mod, mod2: ModPtr;
      F:         Files.File; 
      R:         Files.Rider;
      fname:     ArgStr;
      modname:   Ident;
      cdecl:     BOOLEAN;
  BEGIN
    mod := GetModNode(moduleName);
    IF ~mod.initialized THEN
      FindFileName(fname, moduleName, ".smb"); 
      F := Files.Old(fname);
      IF F # NIL THEN
        Files.Set(R, F, 0); Files.ReadInt(R, cnt); Files.ReadInt(R, mod.key);

        Files.ReadString(R, modname);
        IF modname # moduleName THEN Error("Reading wrong module .smb file.") END;
        
        Read(R, version); (* version key *)
        IF version # versionkey THEN Error("Wrong .smb version.") END;
        
        Read(R, cnt);   (* cdecl *)
        cdecl := cnt = 1;
        IF cdecl THEN
          RemoveModNode(mod)
        ELSE
          Read(R, cnt);   (* imported module count *)
          WHILE cnt > 0 DO
            Files.ReadString(R, modname);
            mod2 := GetModNode(modname);
            AdjustLocation(mod, mod2);
            DEC(cnt)
          END
        END;
        mod.initialized := TRUE
      ELSE
        Error2("Unable to find .smb file for module", moduleName);
      END
    END
  END ProcessModule;

  PROCEDURE CompleteInfo;
    VAR
      mod : ModPtr;
      cnt: INTEGER;
  BEGIN
    cnt := 1;
    WHILE cnt > 0 DO
      cnt := 0; mod := head;
      WHILE mod # NIL DO
        IF ~mod.initialized THEN
          ProcessModule(mod.name); 
          INC(cnt)
        END;
        mod := mod.next
      END
    END
  END CompleteInfo;

  PROCEDURE WriteHex (VAR W: Texts.Writer; x: INTEGER);
    VAR 
      i: INTEGER; 
      y: INTEGER;
      a: ARRAY 10 OF CHAR;
  BEGIN 
    i := 0;
    REPEAT 
      y := x MOD 10H;
      IF y < 10 THEN a[i] := CHR(y + 30H) ELSE a[i] := CHR(y + 37H) END;
      x := x DIV 10H; INC(i)
    UNTIL i = 8;
    REPEAT DEC(i); Texts.Write(W, a[i]) UNTIL i = 0
  END WriteHex;

  PROCEDURE GenerateInitFile;
    VAR
      F:         Files.File; 
      W:         Texts.Writer;
      fname:     ArgStr;
      mod:       ModPtr;
  BEGIN
    mod := head;
    MakeFileName(fname, outputFolder, outputName, "");
    F := Files.New(fname);
    Texts.OpenWriterToFile(W, F);

    Texts.WriteString(W, "    .section .text_init_table" ); Texts.WriteLn(W);
    Texts.WriteString(W, "    .global _sitable, _eitable"); Texts.WriteLn(W);
    Texts.WriteString(W, "    .align 4"                  ); Texts.WriteLn(W);
    Texts.WriteString(W, "_sitable:"                     ); Texts.WriteLn(W);

    WHILE mod # NIL DO
      Texts.WriteString(W, "    .int ");
      Texts.Write(      W, "_"        );
      Texts.WriteString(W, mod.name   );
      Texts.Write(      W, "_"        );
      WriteHex(         W, mod.key    );
      Texts.WriteString(W, "_p__init" );
      Texts.WriteLn(W);

      mod := mod.next
    END;
    Texts.WriteString(W, "_eitable:"); Texts.WriteLn(W);

    Files.Register(F);
    Files.Close(F)
  END GenerateInitFile;

  PROCEDURE CopyStr(from: ARRAY OF CHAR; VAR to: ARRAY OF CHAR);
    VAR i: INTEGER;
  BEGIN
    i := 0;
    WHILE (i < (LEN(to) - 1)) & (from[i] # 0X) DO to[i] := from[i]; INC(i) END;
    to[i] := 0X
  END CopyStr;

  PROCEDURE Usage;
  BEGIN
    Out.Ln;
    Out.String("Usage: OIOrder [-o folder][-p path] -O outputFileName {moduleName ...}"); 
    Out.Ln; Out.Ln;
    Out.String("-o : Output folder of generated code"                 ); Out.Ln;
    Out.String("-O : Output init table filename"                      ); Out.Ln;
    Out.String("-p : Folder Path for imported modules (e.g. f1:f2:f3)"); Out.Ln;
    SYS.Exit(1)
  END Usage;

  PROCEDURE ProcessCommand;
    VAR
      res, i, argCount: INTEGER;
      arg, importPath: ArgStr;
      moduleName: Ident;
      firstModuleName: BOOLEAN;
  BEGIN
    argCount := extArgs.count;

    outputFolder    := ".";
    outputName      := "";
    importPath      := "";
    firstModuleName := TRUE;
  
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
            CopyStr(arg, moduleName);
            IF firstModuleName THEN
              firstModuleName := FALSE;
              DecodePath(importPath)
            END;
            ProcessModule(moduleName);
            filePresent := TRUE
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
  head := NIL;
  ProcessCommand;
  IF filePresent THEN 
    CompleteInfo;
    GenerateInitFile
  ELSE
    Out.Ln; Out.String("Error: At least one module name required.");
    Usage
  END;

  SYS.Exit(0);
END OIOrder.