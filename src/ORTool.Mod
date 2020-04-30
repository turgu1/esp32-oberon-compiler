MODULE ORTool;  (* NW 18.2.2013  GT 1.2.2020 *)
  IMPORT SYSTEM, Strings, extArgs, Files, Texts, ORB, Out, Config;
  VAR
    Form: INTEGER;  (* result of ReadType *)
    (* mnemo0, mnemo1: ARRAY 16, 4 OF CHAR;*)  (* mnemonics *)
    filename : ARRAY 255 OF CHAR;
    ext      : ARRAY 4 OF CHAR;
    res      : INTEGER;
    ref      : INTEGER;

  PROCEDURE Read(VAR R: Files.Rider; VAR n: INTEGER);
    VAR b: BYTE;
  BEGIN Files.Read(R, b);
    IF b < 80H THEN n := b ELSE n := b - 100H END
  END Read;

  PROCEDURE ReadType(VAR R: Files.Rider);
    VAR key, len, lev, size, off: INTEGER;
      mno, class, form, readonly: INTEGER;
      name, modname: ARRAY 32 OF CHAR;
  BEGIN Read(R, ref); Out.Char(" "); Out.Char("[");
    IF ref < 0 THEN Out.Char("^"); Out.Int(-ref, 1)
    ELSE Out.Int(ref, 1);
      Read(R, form); Out.String("  form = "); Out.Int(form, 1);
      IF (form = ORB.Pointer) OR (form = ORB.CPointer) THEN ReadType(R)
      ELSIF (form = ORB.Array) OR (form = ORB.CArray) THEN
        ReadType(R); Files.ReadNum(R, len); Files.ReadNum(R, size);
        Out.String("  len = "); Out.Int(len, 1);
        Out.String("  size = "); Out.Int(size, 1)
      ELSIF (form = ORB.Record) OR (form = ORB.CRecord) THEN
        ReadType(R);  (*base type*)
        Files.ReadNum(R, off); Out.String("  exno = "); Out.Int(off, 1); 
        Files.ReadNum(R, off); Out.String("  extlev = "); Out.Int(off, 1);
        Files.ReadNum(R, size); Out.String("  size = "); Out.Int(size, 1);
        Out.Char(" "); Out.Char("{"); Read(R, class);
        WHILE class # 0 DO (*fields*)
          Files.ReadString(R, name);
          IF name[0] # 0X THEN Out.Char(" "); Out.String(name); ReadType(R)
          ELSE Out.String(" --")
          END ;
          Files.ReadNum(R, off); Out.Int(off, 4); Read(R, class)
        END ;
        Out.Char("}")
      ELSIF (form = ORB.Proc) OR (form = ORB.CProc) THEN
        ReadType(R); Out.Char("("); Read(R, class);
        WHILE class # 0 DO
          Out.String(" class = "); Out.Int(class, 1); Read(R, readonly);
          IF readonly = 1 THEN Out.Char("#") END ;
          ReadType(R); Read(R, class)
        END ;
        Out.Char(")")
      END ;
      Files.ReadString(R, modname);
      IF modname[0] # 0X THEN
        Files.ReadInt(R, key); Files.ReadString(R, name);
        Out.Char(" "); Out.String(modname); Out.Char("."); Out.String(name);
        Out.Hex(key)
      END
    END ;
    Form := form; Out.Char("]")
  END ReadType;

  PROCEDURE DecSym*(VAR filename : ARRAY OF CHAR);  (*decode symbol file*)
    VAR class, typno, k, l: INTEGER;
      name: ARRAY 32 OF CHAR;
      F: Files.File; R: Files.Rider;
      S: Texts.Scanner;
  BEGIN 
    (*Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
    IF S.class = Texts.Name THEN *)
      Out.String("OR-decode "); Out.String(filename);
      Out.Ln;
      F := Files.Old(filename);
      IF F # NIL THEN
        Files.Set(R, F, 0); Files.ReadInt(R, k); Files.ReadInt(R, k);
        Files.ReadString(R, name); Out.String(name); Out.Hex(k);
        Read(R, class); Out.Int(class, 3); (*sym file version*)
        IF class = Config.SmbVersionKey THEN
          Read(R, class); IF class = 1 THEN Out.String(" CDECL Module") END ; (* cdecl flag *)
          Read(R, class); 
          IF class > 0 THEN
            Out.Ln; Out.String("Imported Modules:");
            WHILE class > 0 DO
              Files.ReadString(R, name); Out.Char(" "); Out.String(name);
              DEC(class)
            END
          END ;
          Out.Ln; Read(R, class);
          WHILE class # 0 DO
            Out.Int(class, 4); Files.ReadString(R, name); Out.Char(" "); Out.String(name);
            ReadType(R);
            IF class = ORB.Typ THEN
              Out.Char("("); Read(R, class);
              WHILE class # 0 DO  (*pointer base fixup*)
                Out.String(" ->"); Out.Int(class, 4); Read(R, class)
              END ;
              Out.Char(")")
            ELSIF (class = ORB.Const) THEN
              IF -ref = ORB.LongInt THEN
                Files.ReadNum(R, k); Files.ReadNum(R, l); 
                Out.Hex(l); Out.Char("H"); Out.Hex(k); Out.Char("H")
              ELSE
                Files.ReadNum(R, k); Out.Int(k, 5);  (*Reals, Strings!*)
              END
            ELSIF (class = ORB.Var) THEN
              Files.ReadNum(R, k); Out.Int(k, 5);  (*Reals, Strings!*)
            END ;
            Out.Ln;
            Read(R, class)
          END
        ELSE Out.String(" bad symfile version")
        END
      ELSE Out.String(" not found")
      END ;
      Out.Ln; 
    (* END *)
  END DecSym;
  
(* ---------------------------------------------------*)

(*
  PROCEDURE WriteReg(r: INTEGER);
  BEGIN Out.Char(" ");
    IF r < 12 THEN Out.String(" R"); Out.Int(r MOD 10H, 1)
    ELSIF r = 12 THEN Out.String("MT")
    ELSIF r = 13 THEN Out.String("SB")
    ELSIF r = 14 THEN Out.String("SP")
    ELSE Out.String("LNK")
    END
  END WriteReg;

  PROCEDURE opcode(w: INTEGER);
    VAR k, op, u, a, b, c: INTEGER;
  BEGIN
      k := w DIV 40000000H MOD 4;
      a := w DIV 1000000H MOD 10H;
      b := w DIV 100000H MOD 10H;
      op := w DIV 10000H MOD 10H;
      u := w DIV 20000000H MOD 2;
      IF k = 0 THEN
        Out.String(mnemo0[op]);
        IF u = 1 THEN Out.Char("'") END ;
        WriteReg(a); WriteReg(b); WriteReg(w MOD 10H)
      ELSIF k = 1 THEN
        Out.String(mnemo0[op]);
        IF u = 1 THEN Out.Char("'") END ;
        WriteReg(a); WriteReg(b); w := w MOD 10000H;
        IF w >= 8000H THEN w := w - 10000H END ;
        Out.Int(w, 7)
      ELSIF k = 2 THEN  (*LDR/STR*)
        IF u = 1 THEN Out.String("STR ") ELSE Out.String("LDR") END ;
        WriteReg(a); WriteReg(b); w := w MOD 100000H;
        IF w >= 80000H THEN w := w - 100000H END ;
        Out.Int(w, 8)
      ELSIF k = 3 THEN  (*Branch instr*)
        Out.Char("B");
        IF ODD(w DIV 10000000H) THEN Out.Char("L") END ;
        Out.String(mnemo1[a]);
        IF u = 0 THEN WriteReg(w MOD 10H) ELSE
          w := w MOD 100000H;
          IF w >= 80000H THEN w := w - 100000H END ;
          Out.Int(w, 8)
        END
      END
  END opcode;

  PROCEDURE Sync(VAR R: Files.Rider);
    VAR b: BYTE;
  BEGIN Files.Read(R, b); Out.String("Sync "); Out.Char(CHR(b)); Out.Ln
  END Sync;
  
  PROCEDURE Write(VAR R: Files.Rider; x: INTEGER);
  BEGIN Files.Write(R, x)  (* -128 <= x < 128 *)
  END Write;

  PROCEDURE DecObj*(VAR filename : ARRAY OF CHAR);   (*decode object file*)
    VAR class, i, n, key, size, fix, adr, data, len: INTEGER;
      ch: CHAR; b: BYTE;
      name: ARRAY 32 OF CHAR;
      F: Files.File; R: Files.Rider;
      S: Texts.Scanner;
  BEGIN (* Texts.OpenScanner(S, Oberon.Par.text, Oberon.Par.pos); Texts.Scan(S);
    IF S.class = Texts.Name THEN *)
      Out.String("decode "); Out.String(filename); F := Files.Old(filename);
      IF F # NIL THEN
        Files.Set(R, F, 0); Files.ReadString(R, name); Out.Ln; Out.String(name);
        Files.ReadInt(R, key); Out.Hex(key); Read(R, class); Out.Int(class, 4); (*version*)
        Files.ReadInt(R, size); Out.Int(size, 6); Out.Ln;
        Out.String("imports:"); Out.Ln; Files.ReadString(R, name);
        WHILE name[0] # 0X DO
          Out.Char(9X); Out.String(name);
          Files.ReadInt(R, key); Out.Hex(key); Out.Ln;
          Files.ReadString(R, name)
        END ;
      (* Sync(R); *)
        Out.String("type descriptors"); Out.Ln;
        Files.ReadInt(R, n); n := n DIV 4; i := 0;
        WHILE i < n DO Files.ReadInt(R, data); Out.Hex(data); INC(i) END ;
        Out.Ln;
        Out.String("data"); Files.ReadInt(R, data); Out.Int(data, 6); Out.Ln;
        Out.String("strings"); Out.Ln;
        Files.ReadInt(R, n); i := 0;
        WHILE i < n DO Files.Read(R, b); Out.Char(CHR(b)); INC(i) END ;
        Out.Ln;
        Out.String("code"); Out.Ln;
        Files.ReadInt(R, n); i := 0;
        WHILE i < n DO
          Files.ReadInt(R, data); Out.Int(i, 4); Out.Char(9X); Out.Hex(data);
          Out.Char(9X); opcode(data); Out.Ln; INC(i)
        END ;
      (* Sync(R); *)
        Out.String("commands:"); Out.Ln;
        Files.ReadString(R, name);
        WHILE name[0] # 0X DO
          Out.Char(9X); Out.String(name);
          Files.ReadInt(R, adr); Out.Int(adr, 5); Out.Ln;
          Files.ReadString(R, name)
        END ;
      (* Sync(R); *)
        Out.String("entries"); Out.Ln;
        Files.ReadInt(R, n); i := 0;
        WHILE i < n DO
          Files.ReadInt(R, adr); Out.Int(adr, 6); INC(i)
        END ;
        Out.Ln;
      (* Sync(R); *)
        Out.String("pointer refs"); Out.Ln; Files.ReadInt(R, adr);
        WHILE adr # -1 DO Out.Int(adr, 6); Files.ReadInt(R, adr) END ;
        Out.Ln;
      (* Sync(R); *)
        Files.ReadInt(R, data); Out.String("fixP = "); Out.Int(data, 8); Out.Ln;
        Files.ReadInt(R, data); Out.String("fixD = "); Out.Int(data, 8); Out.Ln;
        Files.ReadInt(R, data); Out.String("fixT = "); Out.Int(data, 8); Out.Ln;
        Files.ReadInt(R, data); Out.String("entry = "); Out.Int(data, 8); Out.Ln;
        Files.Read(R, b);
        IF CHR(b) # "O" THEN Out.String("format eror"); Out.Ln END
      (* Sync(R); *)
      ELSE Out.String(" not found"); Out.Ln
      END
    (* END *)
  END DecObj;
*)
BEGIN 
  Out.String("ORTool 1.2.2020");
  Out.Ln;
(*
  mnemo0[0] := "MOV";
  mnemo0[1] := "LSL";
  mnemo0[2] := "ASR";
  mnemo0[3] := "ROR";
  mnemo0[4] := "AND";
  mnemo0[5] := "ANN";
  mnemo0[6] := "IOR";
  mnemo0[7] := "XOR";
  mnemo0[8] := "ADD";
  mnemo0[9] := "SUB";
  mnemo0[10] := "MUL";
  mnemo0[11] := "DIV";
  mnemo0[12] := "FAD";
  mnemo0[13] := "FSB";
  mnemo0[14] := "FML";
  mnemo0[15] := "FDV";
  mnemo1[0] := "MI ";
  mnemo1[8] := "PL";
  mnemo1[1] := "EQ ";
  mnemo1[9] := "NE ";
  mnemo1[2] := "LS ";
  mnemo1[10] := "HI ";
  mnemo1[5] := "LT ";
  mnemo1[13] := "GE ";
  mnemo1[6] := "LE ";
  mnemo1[14] := "GT ";
  mnemo1[15] := "NO ";
  
  IF extArgs.count = 1 THEN
    extArgs.Get(0, filename, res);
    Strings.Extract(filename, Strings.Length(filename) - 3, 3, ext);
    IF ext = "rsc" THEN
      DecObj(filename)
    ELSE
      DecSym(filename)
    END
  END  
*)

  IF extArgs.count = 1 THEN
    extArgs.Get(0, filename, res);
    Strings.Extract(filename, Strings.Length(filename) - 3, 3, ext);
    IF ext = "smb" THEN
      DecSym(filename)
    ELSE
      Out.Ln;
      Out.String("Only .smb files can be described.")
    END
  END  

END ORTool.
