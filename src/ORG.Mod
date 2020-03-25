MODULE ORG; 
  (* N.Wirth, 16.4.2016 / 4.4.2017 / 31.5.2019  Oberon compiler; code generator for RISC*)
  (* G.Turcotte XX.X.2020 Version for the ESP32 processor chip *)

  IMPORT SYSTEM, Files, Texts, ORS, ORB, Out, SYS;
  
  (* Code generator for Oberon compiler for ESP32 processor.
     Procedural interface to Parser ORP; result in stream "CodeW".
     Procedure Close writes code-files in assembly language *)

  CONST 
    WordSize* = 4;
    SP = 1; SB = 2;   (* dedicated registers *)
    maxStrx = 5000; maxTD = 250;

    MaxLabel = 300;   (* Maximum number of local labels in a procedure *)

    Reg = 10; RegI = 11; Cond = 12;  (* internal item modes *)

    FirstRH = 3;   (* First available register for arguments *)
    LastRH  = 15;  (* Last available register for arguments  *)
    
    (* Conditional branch instructions *)

    MI  = 0; PL  =  8;  (* Minus / Plus                        2 args *)
    EQ  = 1; NE  =  9;  (* Zero / Not zero                     1 arg  *)
    BST = 2; BCL = 10;  (* Bit Set / Bit CLear                 2 args *)
    EQU = 3; NEQ = 11;  (* Equal  / Not equal                  2 args *)
    BR  = 4; BR2 = 12;  (* Non conditional branch              0 args *)
    LT  = 5; GE  = 13;  (* Lower than / Greater or equal       2 args *)
    LE  = 6; GT  = 14;  (* Lower or equal / Greater than       2 args *)
    TR  = 7; FL  = 15;  (* TRUE / FALSE  constant              1 args *)

    Marker1 = 025H; (* % *)
    Marker2 = 024H; (* $ *)
    NewLine = 0AH;

    (* Trap numbers *)

    TrIndex   = 1; (* array index out of range      *)
    TrGuard   = 2; (* type guard failure            *)
    TrCopy    = 3; (* array or string copy overflow *)
    TrNil     = 4; (* access via NIL pointer        *)
    TrCall    = 5; (* illegal procedure call        *)
    TrZeroDiv = 6; (* integer division by zero      *)
    TrAssert  = 7; (* assertionviolated             *)

    (* kind of register content *)
    IMM = 1;  (* Immediate value *)
    LOC = 2;  (* Memory address  *)
    MEM = 3;  (* Memory content, value + displacement is the address  *)
    UNK = 0;  (* Unknown *)

  TYPE 
    (*

    lf* and lt* added by Guy T. Required to be separate as this version of
    the compiler uses labels in assembly language and the algorithm of
    fixing back the code is rather different now (no fixing anymore). 
    May be back to a, b later if a working solution is found to re-merge with
    the existing fields as the original compiler.

    Item forms and meaning of fields:
      mode     r      a       b       lf     lt
      --------------------------------------------
      Const   -     value (proc adr)               (immediate value)
      Var     base   off     -                     (direct adr)
      Par      -     off0   off1                   (indirect adr)
      Reg    regno
      RegI   regno   off     -
      Cond   cond     -      -       Fchain Tchain

      Fchain: False Chain
      Tchain: True Chain  
    *)

    Item* = RECORD
      mode*: INTEGER;
      type*: ORB.Type;
      a*, 
      b*,
      lf*,
      lt*, 
      r:     INTEGER;
      name: ORS.Ident;
      rdo*:  BOOLEAN  (*read only*)
    END ;

    LabelRange* = RECORD low*, high*, label*: INTEGER END ;

    BrStr = ARRAY 5 OF CHAR;

    (* 
      Register content follow-up. This is an attempt to optimize the register load mechanism.
      Every time a register is set to someting, the strucure is updated with the following 
      information:
        - r: other register from which the content has been used to load current register. 
          if r = -1, no other register; if r = -99, entry not valid.
        - a: is a labeled locattion
        - k: kind of value: immediate, location)
      *)
    RegisterContent = ARRAY 16 OF 
      RECORD 
        r, i: INTEGER; 
        a: ARRAY 256 OF CHAR;
        k: INTEGER
      END;

  VAR 
    varsize,                 (* data index *)
    tdx, strx,               (* type description and string indexes *)
    RH,                      (* available registers R[FirstRH] ... R[LastRH] *)
    frame:   INTEGER;        (* frame offset changed in SaveRegs and RestoreRegs *)
    check:   BOOLEAN;        (* emit run-time checks *)
    
    relmap: ARRAY 6       OF INTEGER;  (* condition codes for relations *)
    data:   ARRAY maxTD   OF INTEGER;  (* type descriptors *)
    str:    ARRAY maxStrx OF CHAR;

    rc: RegisterContent;

    (* The end result of the compiler is an assembler file ready to be digested by the GNU Assembler *)
    AsF: Files.File;     (* Output file for the Assembly Language *)
    AsW: Texts.Writer;   (* Writer for the Assembly Language File *)

    (* The Code File is receiving the ESP32 instructions in assembler language. It will be
       merged with the rest of the required information ino the AsF file at the end of the
       compilation process *)

    CodeF: Files.File;   (* Code file *)
    CodeW: Texts.Writer; (* Machine code output for Procedures *)

    ProcPresent: BOOLEAN; (* There is at least one Procedure present *)

    thisModuleId: ORS.Ident; (* Module Id being compiled *)

    theNextLabel: INTEGER; (* local label number *)

    BrOp: ARRAY 16 OF BrStr;  (* ESP32 branch instructions   *)
    BrReverse,                (* Parameters must be reversed *)
    BrOneParam,               (* One parameter instructions  *)
    BrTwoParam,               (* Two parameter instructions  *)
    BrNoParam: SET;           (* Unconditional branches      *)

    UsedRegs: SET;

  (* Compiler generator debugging support tools *)

  PROCEDURE e(s: ARRAY OF CHAR);
  BEGIN 
    IF ORS.debugging THEN
      Out.Ln;
      Out.String(" -> ");
      Out.String(s)
    END
  END e;

  PROCEDURE eStr(s: ARRAY OF CHAR);
  BEGIN 
    IF ORS.debugging THEN
      Out.String(s)
    END
  END eStr;

  PROCEDURE eInt(i: INTEGER);
  BEGIN 
    IF ORS.debugging THEN
      Out.Int(i, 0)
    END
  END eInt;
  
  PROCEDURE eHex(i: INTEGER);
  BEGIN 
    IF ORS.debugging THEN
      Out.Hex(i)
    END
  END eHex;
(*
  PROCEDURE Spaces(i: INTEGER);
  BEGIN 
    WHILE i > 0 DO Out.Char(" "); DEC(i) END
  END Spaces;

  PROCEDURE ShowClass(c: INTEGER);
  BEGIN
    Out.String(" (");
    CASE c OF
    0: Out.String("Head" ); |
    1: Out.String("Const"); |
    2: Out.String("Var"  ); |
    3: Out.String("Par"  ); |
    4: Out.String("Fld"  ); |
    5: Out.String("Typ"  ); |
    6: Out.String("SProc"); |
    7: Out.String("SFunc"); |
    8: Out.String("Mod"  ); 
    END;
    Out.String(")");
  END ShowClass;

  PROCEDURE ShowForm(f: INTEGER);
  BEGIN 
    Out.String(" (");
    CASE f OF
    1: Out.String("Byte"     ); |
    2: Out.String("Bool"     ); |
    3: Out.String("Char"     ); |
    4: Out.String("Int"      ); |
    5: Out.String("Real"     ); |
    6: Out.String("Set"      ); |
    7: Out.String("Pointer"  ); |
    8: Out.String("Nil Type" ); |
    9: Out.String("NoType"   ); |
    10: Out.String("Proc"    ); |
    11: Out.String("String"  ); |
    12: Out.String("Array"   ); |
    13: Out.String("Record"  );
    END;
    Out.String(")");
  END ShowForm;

  PROCEDURE ShowMode(m: INTEGER);
  BEGIN 
    Out.String(" (");
    CASE m OF
    0: Out.String("Head"  ); |
    1: Out.String("Const" ); |
    2: Out.String("Var"   ); |
    3: Out.String("Par"   ); |
    4: Out.String("Fld"   ); |
    5: Out.String("Typ"   ); |
    6: Out.String("SProc" ); |
    7: Out.String("SFunc" ); |
    8: Out.String("Mod"   ); |
    10: Out.String("Reg"  ); |
    11: Out.String("RegI" ); |
    12: Out.String("Cond" ); 
    END;
    Out.String(")");
    
  END ShowMode;

  PROCEDURE ShowObject(o: ORB.Object; s: INTEGER);

    PROCEDURE ShowType(t: ORB.Type; s: INTEGER);
    BEGIN 
      IF s <= 20 THEN
        Spaces(s); Out.String("form: "  ); Out.Int(t.form,   0); ShowForm(t.form); Out.Ln;
        Spaces(s); Out.String("ref: "   ); Out.Int(t.ref,    0); Out.Ln;
        Spaces(s); Out.String("mno: "   ); Out.Int(t.mno,    0); Out.Ln;
        Spaces(s); Out.String("nofPar: "); Out.Int(t.nofpar, 0); Out.Ln;
        Spaces(s); Out.String("len: "   ); Out.Int(t.len,    0); Out.Ln;
        Spaces(s); Out.String("size: "  ); Out.Int(t.size,   0); Out.Ln;
        IF t.dsc # NIL THEN
          Spaces(s); Out.String("dsc:"); Out.Ln;
          ShowObject(t.dsc, s + 4);
        END;
        IF t.typobj # NIL THEN
          Spaces(s); Out.String("typobj:"); Out.Ln;
          ShowObject(t.typobj, s + 4);
        END;
        IF t.base # NIL THEN
          Spaces(s); Out.String("base:"); Out.Ln;
          ShowType(t.base, s + 4);
        END
      END
    END ShowType;

  BEGIN
    IF s <= 20 THEN
      Out.Ln;
      Spaces(s); Out.String("class: "); Out.Int(o.class, 0); ShowClass(o.class); Out.Ln;
      Spaces(s); Out.String("exno: " ); Out.Int(o.exno, 0); Out.Ln;
      Spaces(s); Out.String("expo: " ); IF o.expo THEN Out.String("YES") ELSE Out.String("NO") END; Out.Ln;
      Spaces(s); Out.String("rdo: "  ); IF o.rdo THEN Out.String("YES") ELSE Out.String("NO") END; Out.Ln;
      Spaces(s); Out.String("lev: "  ); Out.Int(o.lev, 0); Out.Ln;
      Spaces(s); Out.String("val: "  ); Out.Int(o.val, 0); Out.Ln;
      Spaces(s); Out.String("name: " ); Out.String(o.name); Out.Ln;
      IF o.dsc # NIL THEN
        Spaces(s); Out.String("dsc:"); Out.Ln;
        ShowObject(o.dsc, s + 4);
      END;
      IF o.type # NIL THEN
        Spaces(s); Out.String("type:"); Out.Ln;
        ShowType(o.type, s + 4);
      END;
      IF o.next # NIL THEN
        ShowObject(o.next, s);
      END
    END
  END ShowObject;

  PROCEDURE ShowItem(x: Item);
  BEGIN
    Out.Ln;
    Out.String("Item:"); Out.Ln;
    Out.String("  Mode: "); Out.Int(x.mode, 0); ShowMode(x.mode); Out.Ln;
    Out.String("  a: "   ); Out.Int(x.a,    0); Out.Ln;
    Out.String("  b: "   ); Out.Int(x.b,    0); Out.Ln;
    Out.String("  r: "   ); Out.Int(x.r,    0); Out.Ln;
    Out.String("  rdo: " ); IF x.rdo THEN Out.String("YES") ELSE Out.String("NO") END; Out.Ln;
    (*IF x.type # NIL THEN
      Out.String("  type:" ); Out.Ln;
      ShowType(x.type, 4);
    END*)
  END ShowItem;
*)
  (* Register optimization management *)
  PROCEDURE InitRc;
  VAR
    i: INTEGER;
  BEGIN 
    FOR i := 0 TO 15 DO rc[i].k := UNK END
  END InitRc;

  PROCEDURE ClearRc(r: INTEGER);
  BEGIN 
    rc[r].k := UNK;
  END ClearRc;

  PROCEDURE SetRcI(r, fromR, i, k: INTEGER);
  BEGIN 
    rc[r].r    := fromR;
    rc[r].i    := i;
    rc[r].a[0] := 0X;
    rc[r].k    := k;
  END SetRcI;

  PROCEDURE SetRcA(r, fromR: INTEGER; a: ARRAY OF CHAR; k: INTEGER);
  BEGIN 
    rc[r].r    := fromR;
    rc[r].i    := -1;
    rc[r].a    := a;
    rc[r].k    := k;
  END SetRcA;

  PROCEDURE ModuleInfo(idx: INTEGER; VAR moduleId: ORS.Ident; VAR moduleKey: INTEGER);
  VAR
    obj, obj1: ORB.Object;
    savedIdx: INTEGER;
    found: BOOLEAN;
  BEGIN
    moduleId := "Unknown";
    moduleKey := 0;
    savedIdx := idx;
    obj := ORB.topScope;
    obj1 := NIL;
    WHILE obj.dsc # NIL DO obj1 := obj; obj := obj.dsc END;
    IF obj # NIL THEN obj := obj1.next END;
    found := FALSE;
    WHILE (idx # 0) & (obj # NIL) DO
      IF obj.class = ORB.Mod THEN  (* imports *)
        IF obj.dsc # ORB.system THEN
          INC(idx);
          IF idx = 0 THEN 
            moduleId := obj(ORB.Module).orgname;
            moduleKey  := obj.val;
            found := TRUE
          END
        END
      END;
      obj := obj.next
    END;
    IF ~found THEN
      ORS.Mark("Unable to find IMPORT module.")
    END
  END ModuleInfo;

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
  
  PROCEDURE AppendHex(VAR s: ARRAY OF CHAR; x:INTEGER);
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
    y := 0;
    WHILE (y < LEN(s)) & (s[y] # 0X) DO INC(y) END;
    REPEAT 
      DEC(i); 
      IF y < LEN(s) THEN s[y] := a[i]; INC(y) END 
    UNTIL i = 0;
    IF y < LEN(s) THEN s[y] := 0X END
  END AppendHex;
  
  PROCEDURE AppendStr(VAR s: ARRAY OF CHAR; t: ARRAY OF CHAR);
  VAR
    i, j: INTEGER;
  BEGIN 
    i := 0;
    WHILE (i < LEN(s)) & (s[i] # 0X) DO INC(i) END;
    j := 0;
    WHILE (i < LEN(s)) & ((j < LEN(t)) & (t[j] # 0X)) DO 
      s[i] := t[j]; 
      INC(i); INC(j) 
    END;
    IF i < LEN(s) THEN s[i] := 0X END
  END AppendStr;

  PROCEDURE incR;
  BEGIN
    IF RH < LastRH THEN
      INCL(UsedRegs, RH);
      INC(RH) 
    ELSE 
      ORS.Mark("register stack overflow");
      Out.Ln; Out.String("   ==> RH: "); Out.Int(RH, 0)
    END
  END incR;

  PROCEDURE decR;
  BEGIN
    IF RH > FirstRH THEN
      DEC(RH);
      EXCL(UsedRegs, RH)
    ELSE
      ORS.Mark("register stack underflow");
      Out.Ln; Out.String("   ==> RH: "); Out.Int(RH, 0)
    END
  END decR;

(*
  PROCEDURE FirstFreeReg() : INTEGER;
  VAR
    i: INTEGER;
  BEGIN 
    i := LastRH;
    WHILE (i > FirstRH) & ~(i IN UsedRegs) DO DEC(i) END;
    RETURN i
  END FirstFreeReg;
*)
  PROCEDURE CheckRegs*;
  BEGIN
    IF RH # FirstRH THEN 
      ORS.Mark("Reg Stack"); 
      Out.Ln;
      Out.String("Reg Stack error: "); Out.Int(RH, 0);
      RH := FirstRH;
      UsedRegs := {}
    END ;
    (* IF pc >= maxCode - 40 THEN ORS.Mark("program too long") END ; *)
    IF frame # 0 THEN 
      ORS.Mark("frame error"); 
      Out.String("Frame size error: "); Out.Int(frame, 0); Out.Ln;
      frame := 0
    END
  END CheckRegs;

  (* The ESP32 is using a large amount of instruction formats... *)
  (* instruction assemblers according to formats *)

  PROCEDURE PutA(op, a: ARRAY OF CHAR);
  BEGIN 
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.Write(      CodeW, " ");
    Texts.WriteString(CodeW, a);
    Texts.WriteLn(    CodeW);
  END PutA;

  PROCEDURE PutRA(op: ARRAY OF CHAR; r: INTEGER; a: ARRAY OF CHAR);
  BEGIN 
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " a");
    Texts.WriteInt(   CodeW, r, 0);
    Texts.WriteString(CodeW, ", _");
    Texts.WriteString(CodeW, a);
    Texts.WriteLn(    CodeW);
  END PutRA;

  PROCEDURE PutRL(op: ARRAY OF CHAR; r, label: INTEGER);
  BEGIN 
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " a");
    Texts.WriteInt(   CodeW, r, 0);
    Texts.WriteString(CodeW, ", ");
    Texts.WriteInt(   CodeW, label MOD MaxLabel, 0);
    Texts.Write(      CodeW, "$");
    Texts.WriteLn(    CodeW);
  END PutRL;

  PROCEDURE PutRRR(op: ARRAY OF CHAR; r1, r2, r3: INTEGER);
  BEGIN
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " a");
    Texts.WriteInt(   CodeW, r1, 0);
    Texts.WriteString(CodeW, ", a");
    Texts.WriteInt(   CodeW, r2, 0);
    Texts.WriteString(CodeW, ", a");
    Texts.WriteInt(   CodeW, r3, 0);
    Texts.WriteLn(    CodeW);
  END PutRRR;

  PROCEDURE PutRR(op: ARRAY OF CHAR; r1, r2: INTEGER);
  BEGIN
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " a");
    Texts.WriteInt(   CodeW, r1, 0);
    Texts.WriteString(CodeW, ", a");
    Texts.WriteInt(   CodeW, r2, 0);
    Texts.WriteLn(    CodeW);
  END PutRR;

  PROCEDURE PutR(op: ARRAY OF CHAR; r: INTEGER);
  BEGIN
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " a");
    Texts.WriteInt(   CodeW, r, 0);
    Texts.WriteLn(    CodeW);
  END PutR;

  PROCEDURE PutSSS(op: ARRAY OF CHAR; f1, f2, f3: INTEGER);
  BEGIN
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " f");
    Texts.WriteInt(   CodeW, f1, 0);
    Texts.WriteString(CodeW, ", f");
    Texts.WriteInt(   CodeW, f2, 0);
    Texts.WriteString(CodeW, ", f");
    Texts.WriteInt(   CodeW, f3, 0);
    Texts.WriteLn(    CodeW);
  END PutSSS;

  PROCEDURE PutSS(op: ARRAY OF CHAR; f1, f2: INTEGER);
  BEGIN
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " f");
    Texts.WriteInt(   CodeW, f1, 0);
    Texts.WriteString(CodeW, ", f");
    Texts.WriteInt(   CodeW, f2, 0);
    Texts.WriteLn(    CodeW);
  END PutSS;

  PROCEDURE PutSR(op: ARRAY OF CHAR; f1, r2: INTEGER);
  BEGIN
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " f");
    Texts.WriteInt(   CodeW, f1, 0);
    Texts.WriteString(CodeW, ", a");
    Texts.WriteInt(   CodeW, r2, 0);
    Texts.WriteLn(    CodeW);
  END PutSR;

  PROCEDURE PutSRI(op: ARRAY OF CHAR; f1, r2, i: INTEGER);
  BEGIN
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " f");
    Texts.WriteInt(   CodeW, f1, 0);
    Texts.WriteString(CodeW, ", a");
    Texts.WriteInt(   CodeW, r2, 0);
    Texts.WriteString(CodeW, ", ");
    Texts.WriteInt(   CodeW, i, 0);
    Texts.WriteLn(    CodeW);
  END PutSRI;

  PROCEDURE PutRS(op: ARRAY OF CHAR; r1, f2: INTEGER);
  BEGIN
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " a");
    Texts.WriteInt(   CodeW, r1, 0);
    Texts.WriteString(CodeW, ", f");
    Texts.WriteInt(   CodeW, f2, 0);
    Texts.WriteLn(    CodeW);
  END PutRS;

  PROCEDURE PutRSI(op: ARRAY OF CHAR; r1, f2, i: INTEGER);
  BEGIN
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " a");
    Texts.WriteInt(   CodeW, r1, 0);
    Texts.WriteString(CodeW, ", f");
    Texts.WriteInt(   CodeW, f2, 0);
    Texts.WriteString(CodeW, ", ");
    Texts.WriteInt(   CodeW, i, 0);
    Texts.WriteLn(    CodeW);
  END PutRSI;

  PROCEDURE PutRI(op: ARRAY OF CHAR; r, v: INTEGER);
  BEGIN
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " a");
    Texts.WriteInt(   CodeW, r, 0);
    Texts.WriteString(CodeW, ", ");
    Texts.WriteInt(   CodeW, v, 0);
    Texts.WriteLn(    CodeW);
  END PutRI;

  PROCEDURE PutRRI(op: ARRAY OF CHAR; r1, r2, v: INTEGER);
  BEGIN
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " a");
    Texts.WriteInt(   CodeW, r1, 0);
    Texts.WriteString(CodeW, ", a");
    Texts.WriteInt(   CodeW, r2, 0);
    Texts.WriteString(CodeW, ", ");
    Texts.WriteInt(   CodeW, v, 0);
    Texts.WriteLn(    CodeW);
  END PutRRI;

  PROCEDURE PutRRII(op: ARRAY OF CHAR; r1, r2, v1, v2: INTEGER);
  BEGIN
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " a");
    Texts.WriteInt(   CodeW, r1, 0);
    Texts.WriteString(CodeW, ", a");
    Texts.WriteInt(   CodeW, r2, 0);
    Texts.WriteString(CodeW, ", ");
    Texts.WriteInt(   CodeW, v1, 0);
    Texts.WriteString(CodeW, ", ");
    Texts.WriteInt(   CodeW, v2, 0);
    Texts.WriteLn(    CodeW);
  END PutRRII;

  PROCEDURE PutI(op: ARRAY OF CHAR; v: INTEGER);
  BEGIN 
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.Write(      CodeW, " ");
    Texts.WriteInt(   CodeW, v, 0);
    Texts.WriteLn(    CodeW);
  END PutI;

  PROCEDURE PutSingle(op: ARRAY OF CHAR);
  BEGIN 
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteLn(CodeW);
  END PutSingle;

  PROCEDURE ImportName(VAR str: ARRAY OF CHAR; name, kind, moduleId: ARRAY OF CHAR;  moduleKey: INTEGER);
  BEGIN
    str := "_";
    AppendStr(str, moduleId);
    AppendStr(str,"_");
    AppendHex(str, moduleKey);
    AppendStr(str,"_");
    AppendStr(str, kind);
    AppendStr(str,"_");
    AppendStr(str, name);
  END ImportName;

  PROCEDURE PutDataExternal(r : INTEGER; name, moduleId: ORS.Ident; moduleKey: INTEGER);
  VAR
    n : ARRAY 256 OF CHAR;
  BEGIN
    ImportName(n, name, "p", moduleId, moduleKey);

    Texts.WriteString(CodeW, "movi a");
    Texts.WriteInt(   CodeW, r, 0);
    Texts.WriteString(CodeW, ", ");
    Texts.WriteString(CodeW, n);
    Texts.WriteLn(CodeW);
    SetRcA(r, -1, n, IMM);
  END PutDataExternal;

  PROCEDURE PutCallR(callType: INTEGER; r: INTEGER);
  BEGIN 
    Texts.WriteString(CodeW, "    callx");
    Texts.WriteInt(   CodeW, callType, 0);
    Texts.WriteString(CodeW, " a");
    Texts.WriteInt(   CodeW, r, 0);
    Texts.WriteLn(    CodeW);
  END PutCallR;

  PROCEDURE PutCallLocal(callType: INTEGER; name: ORS.Ident);
  BEGIN 
    Texts.WriteString(CodeW, "    call");
    Texts.WriteInt(   CodeW, callType, 0);
    Texts.WriteString(CodeW, " _");
    Texts.WriteString(CodeW, name);
    Texts.WriteLn(    CodeW);
  END PutCallLocal;

  PROCEDURE PutCALLExternal(callType : INTEGER; name, moduleId: ORS.Ident; moduleKey: INTEGER);
  VAR n: ARRAY 256 OF CHAR;
  BEGIN
    ImportName(n, name, "p", moduleId, moduleKey);
    Texts.WriteString(CodeW, "    call");
    Texts.WriteInt(   CodeW, callType, 0);
    Texts.Write(      CodeW, " ");
    Texts.WriteString(CodeW, n);
    Texts.WriteLn(CodeW)
  END PutCALLExternal;

  PROCEDURE NextLabel*(): INTEGER;
  VAR l: INTEGER;
  BEGIN
    l := theNextLabel;
    INC(theNextLabel);
    IF theNextLabel >= MaxLabel THEN
      ORS.Mark("Max number of labels reached in a procedure.")
    END;
    RETURN l
  END NextLabel;

  PROCEDURE PutLabel*(label: INTEGER);
  VAR l: INTEGER;
  BEGIN
    e("PutLabel");
    WHILE label > 0 DO
      l := label MOD MaxLabel;
      label := label DIV MaxLabel;

      Texts.WriteInt(CodeW, l, 0);
      Texts.Write(   CodeW, "$");
      Texts.Write(   CodeW, ":");
      Texts.WriteLn( CodeW);
    END;
    InitRc;
  END PutLabel;

  PROCEDURE PutBranchRR(op: ARRAY OF CHAR; r1, r2, label: INTEGER);
  BEGIN 
    e("PutBranchRR");
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " a");
    Texts.WriteInt(   CodeW, r1, 0);
    Texts.WriteString(CodeW, ", a");
    Texts.WriteInt(   CodeW, r2, 0);
    Texts.WriteString(CodeW, ", ");
    Texts.WriteInt(   CodeW, label MOD MaxLabel, 0);
    Texts.Write(      CodeW, "$");
    Texts.WriteLn(CodeW);
  END PutBranchRR;

  PROCEDURE PutBranchRI(op: ARRAY OF CHAR; r, imm, label: INTEGER);
  BEGIN 
    e("PutBranchRR");
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " a");
    Texts.WriteInt(   CodeW, r, 0);
    Texts.WriteString(CodeW, ", ");
    Texts.WriteInt(   CodeW, imm, 0);
    Texts.WriteString(CodeW, ", ");
    Texts.WriteInt(   CodeW, label MOD MaxLabel, 0);
    Texts.Write(      CodeW, "$");
    Texts.WriteLn(CodeW);
  END PutBranchRI;

  PROCEDURE PutBranchR(op: ARRAY OF CHAR; r, label: INTEGER);
  BEGIN 
    e("PutBranchR");
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " a");
    Texts.WriteInt(   CodeW, r, 0);
    Texts.WriteString(CodeW, ", ");
    Texts.WriteInt(   CodeW, label MOD MaxLabel, 0);
    Texts.Write    (  CodeW, "$");
    Texts.WriteLn(CodeW);
  END PutBranchR;

  PROCEDURE PutJump(op: ARRAY OF CHAR; label: INTEGER);
  BEGIN 
    e("PutJump");
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.Write(      CodeW, " ");
    Texts.WriteInt(   CodeW, label MOD MaxLabel, 0);
    Texts.Write(      CodeW, "$");
    Texts.WriteLn(CodeW);
  END PutJump;

  PROCEDURE PutCondBranch(cond, label: INTEGER);
  VAR 
    reverseArguments: BOOLEAN;
    thisCond: INTEGER;
  BEGIN 
    e("PutCondBranch RH:"); eInt(RH);
    
    reverseArguments := cond >= 100;
    thisCond := cond;
    IF reverseArguments THEN thisCond := cond - 100 END;
    eStr(" revArgs:"); eInt(ORD(reverseArguments));
    IF (thisCond < 0) OR (thisCond > 15) THEN
      ORS.Mark("Internal Error in PutCondBranch!! (cond off limits)");
      Out.Ln; Out.String("cond:"); Out.Int(thisCond, 0);
    ELSIF ((thisCond IN BrOneParam) & (RH < FirstRH + 1)) OR 
          ((thisCond IN BrTwoParam) & (RH < FirstRH + 2)) THEN
      ORS.Mark("Internal Error in PutCondBranch!! (Wrong registers mgmt)");
      Out.Ln; Out.String("cond:"); Out.Int(thisCond, 0); Out.String(", RH:"); Out.Int(RH, 0); Out.Ln;
    ELSE
      e(BrOp[thisCond]);
      IF thisCond IN BrOneParam THEN
        PutBranchR(BrOp[thisCond], RH-1, label MOD MaxLabel);
        decR
      ELSIF thisCond IN BrNoParam THEN
        PutJump("j", label MOD MaxLabel)
      ELSE
        IF thisCond IN BrReverse THEN
          IF reverseArguments THEN
            PutBranchRR(BrOp[thisCond], RH-2, RH-1, label MOD MaxLabel)
          ELSE
            PutBranchRR(BrOp[thisCond], RH-1, RH-2, label MOD MaxLabel)
          END
        ELSE
          IF reverseArguments THEN
            PutBranchRR(BrOp[thisCond], RH-1, RH-2, label MOD MaxLabel)
          ELSE
            PutBranchRR(BrOp[thisCond], RH-2, RH-1, label MOD MaxLabel)
          END
        END;
        decR; decR
      END
    END;
    e("End of PutCondBranch RH:"); eInt(RH);
  END PutCondBranch;

    (* Produce a unique section name of the following form:
       _<sectionPrefix>_<moduleId>_<kind>_<key>
   *)

  PROCEDURE ExportName(name, kind, moduleId: ARRAY OF CHAR;  moduleKey: INTEGER);
  BEGIN
    e("ExportName");
    Texts.Write(AsW, "_");
    Texts.WriteString(AsW, moduleId);
    Texts.Write(AsW, "_");
    WriteHex(AsW, moduleKey);
    Texts.Write(AsW, "_");
    Texts.WriteString(AsW, kind);
    Texts.Write(AsW, "_");
    Texts.WriteString(AsW, name);
  END ExportName;

  PROCEDURE SectionName(sectionPrefix, moduleId: ARRAY OF CHAR;  moduleKey: INTEGER);
  BEGIN
    e("SectionName");
    Texts.Write(AsW, ".");
    Texts.WriteString(AsW, sectionPrefix);
    Texts.Write(AsW, "_");
    Texts.WriteString(AsW, moduleId);
    Texts.Write(AsW, "_");
    WriteHex(AsW, moduleKey);
  END SectionName;

  PROCEDURE SetCC(VAR x: Item; n: INTEGER);
  BEGIN 
    e("SetCC cond:"); eInt(n); 
    x.mode := Cond; 
    x.a := 0; 
    x.b := 0; 
    x.r := n
  END SetCC;

  PROCEDURE negated(cond: INTEGER): INTEGER;
  VAR
    c: INTEGER;
  BEGIN
    e("negated");
    c := cond;
    IF c >= 100 THEN
      c := cond - 100;
      IF c < 8 THEN c := c+8 ELSE c := c-8 END;
      c := c + 100;
    ELSE
      IF c < 8 THEN c := c+8 ELSE c := c-8 END
    END
    RETURN c
  END negated;

  (* SYSCALL for error messages

     - Register A6 reveives code 2
     - Register A7 receives reason  
     
     RH-1 and possibly RH-2 must contain the values to be compared with the
     branch instruction. RH will become DEC(RH) or DEC(RH,2) accordingly. 
     
     It will never return
    *)

  PROCEDURE Trap(cond, num: INTEGER);
  VAR l: INTEGER;
  BEGIN 
    e("Trap");
    l := NextLabel();
    PutCondBranch(negated(cond), l);
    PutRI("movi", 6, 2);       (* a6 := 2 is TRAP EXCEPTION      *)
    PutRI("movi", 7, num);     (* a7 := num is TRAP Reason       *)
    (* PutA("syscall", "# Trap"); Not supposed to come back here *)
    PutCallLocal(4, "OberonSyscallHandler");
    PutLabel(l); 
  END Trap;

  (* RH-1 must contains the pointer to check for NIL value.
     RH will become DEC(RH) *)
  PROCEDURE NilCheck;
  BEGIN
    IF check THEN 
      Trap(EQ, TrNil);
      incR 
    END
  END NilCheck;

  PROCEDURE CheckFreeRegs(i : INTEGER);
  BEGIN
    IF RH + i - 1 > LastRH THEN
      ORS.Mark("Statement is too complex. Not enough registers.");
    END
  END CheckFreeRegs;

  (* verbatim assembly language input from the source code *)

  PROCEDURE assembler*;
  VAR
    line : ARRAY 256 OF CHAR;
  BEGIN 
    WHILE ORS.GetAssemblerLine(line) DO
      Texts.WriteString(CodeW, line); 
      Texts.WriteLn(CodeW);
    END;
    InitRc;
  END assembler;

  (* loading of operands and addresses into registers *)

  PROCEDURE GetLocalSB;
  VAR
    name: ARRAY 256 OF CHAR;
  BEGIN 
    e("GetLocalSB");
    name := "_"; AppendStr(name, thisModuleId); AppendStr(name, "_s_bss");
    Texts.WriteString(CodeW, "    movi a2, ");
    Texts.WriteString(CodeW, name);
    Texts.WriteLn(CodeW);
    SetRcA(2, 0, name, LOC)
  END GetLocalSB;

  PROCEDURE GetExtSB(base: INTEGER);
  VAR
    moduleId: ORS.Ident;
    moduleKey: INTEGER;
    name: ARRAY 256 OF CHAR;
  BEGIN
    e("GetSB base:"); eInt(base);
    IF base # 0 THEN
      ModuleInfo(base, moduleId, moduleKey);
      name := "_"; AppendStr(name, moduleId); AppendStr(name, "_");
      AppendHex(name, moduleKey);
      AppendStr(name, "_s_bss");

      Texts.WriteString(CodeW, "    movi a");
      Texts.WriteInt(   CodeW, RH, 0);
      Texts.WriteString(CodeW, ", ");
      Texts.WriteString(CodeW, name);
      Texts.WriteLn(CodeW);
      SetRcA(RH, 0, name, LOC)
    END
  END GetExtSB;

  PROCEDURE GetTypesDescrSB(base: INTEGER);
  VAR
    moduleId: ORS.Ident;
    moduleKey: INTEGER;
    name: ARRAY 256 OF CHAR;
  BEGIN
    e("GetTypesDescrSB base:");eInt(base);
    IF base = 0 THEN
      name := "_"; AppendStr(name, thisModuleId); AppendStr(name, "_s_types");
      Texts.WriteString(CodeW, "    movi a");
      Texts.WriteInt(CodeW, RH, 0);
      Texts.WriteString(CodeW, ", ");
      Texts.WriteString(CodeW, name);
      Texts.WriteLn(CodeW);
    ELSE
      ModuleInfo(base, moduleId, moduleKey);
      name := "_"; AppendStr(name, moduleId); AppendStr(name, "_");
      AppendHex(name, moduleKey);
      AppendStr(name, "_s_data_types");
      eStr(" moduleId:"); eStr(moduleId);

      Texts.WriteString(CodeW, "    movi a");
      Texts.WriteInt(CodeW, RH, 0);
      Texts.WriteString(CodeW, ", ");
      Texts.WriteString(CodeW, name);
      Texts.WriteLn(CodeW);
    END;
    SetRcA(RH, 0, name, LOC);
  END GetTypesDescrSB;

  (* 
    Move (load or store) location r2+offset. The ESP32 uses l32i l8ui s32i s8ui
    with an offset that is limited to 255 for 8bits and 1020 for 32 bits moves. 
    If the offset parameter is too large, the address must be computed before 
    moving the data.
   *)
  PROCEDURE PutMoveRRI(op: ARRAY OF CHAR; max, r1, r2, offset: INTEGER);
  VAR
    temp: INTEGER;
  BEGIN 
    e("PutMoveRRI");
    IF (offset > max) OR (offset < 0) THEN
      IF (r1 = RH) OR (r2 = RH) THEN temp := RH+1 ELSE temp := RH END;
      IF (offset < 0) OR (offset > 32512) THEN
        PutRI("movi", temp, offset);
        PutRRR("add", temp, temp, r2);
        PutRRI(op, r1, temp, 0);
      ELSE
        PutRRI("addmi", temp, r2, (offset DIV 256) * 256);
        PutRRI(op, r1, temp, offset MOD 256);
      END;
      ClearRc(temp);
    ELSE
      PutRRI(op, r1, r2, offset)
    END;
    SetRcI(r1, r2, offset, MEM);
  END PutMoveRRI;

  PROCEDURE load(VAR x: Item);
    VAR 
      op: ARRAY 5 OF CHAR;
      max, moduleKey, lbl: INTEGER;
      moduleId: ORS.Ident;
  BEGIN
    e("load "); 
    IF x.type.size = 1 THEN 
      op := "l8ui"; max := 255 
    ELSE 
      op := "l32i"; max := 1020 
    END;
    IF x.mode # Reg THEN (* if not already in a register *)
      IF x.mode = ORB.Const THEN (* Constant *)
        IF x.type.form = ORB.Proc THEN
          eStr(" (proc) ");
          IF x.r > 0 THEN 
            ORS.Mark("not allowed")
          ELSIF x.r = 0 THEN
            (*
            Put3(BL, 7, 0); 
            Put1a(Sub, RH, LNK, pc*4 - x.a)
            *)
            eStr(x.name);
            PutRA("movi", RH, x.name);
            SetRcA(RH, -1, x.name, LOC);
          ELSE 
            (* GetExtSB(x.r); *)
            eStr("(import) name:"); eStr(x.name); eStr(" module:"); eStr(moduleId); eStr(" key:"); eHex(moduleKey); 
            ModuleInfo(x.r, moduleId, moduleKey);
            PutDataExternal(RH, x.name, moduleId, moduleKey); (* Is calling SetRcA *)
          END
        ELSE
          eStr("(const) "); eInt(x.a);
          PutRI("movi", RH, x.a); SetRcI(RH, 0, x.a, IMM);
        END ;
        x.r := RH; incR
      ELSIF x.mode = ORB.Var THEN
        eStr("(var) "); eStr(x.name);
        IF x.r > 0 THEN (* local on the stack *) 
          eStr(" (stack) x.a:"); eInt(x.a); eStr(" frame:"); eInt(frame);
          PutMoveRRI(op, max, RH, SP, x.a + frame);
          SetRcI(RH, SP, x.a + frame, MEM);
        ELSE  (* module globals or imported *)
          IF x.r = 0 THEN
            eStr("(SB) "); eInt(x.a); 
            PutMoveRRI(op, max, RH, SB, x.a);
          ELSE
            GetExtSB(x.r);
            eStr("(imported) "); eInt(x.a); 
            PutMoveRRI(op, max, RH, RH, x.a);
          END
        END;
        x.r := RH; incR
      ELSIF x.mode = ORB.Par THEN
        eStr("(par) x.a:"); eInt(x.a); eStr("frame:"); eInt(frame);
        PutMoveRRI("l32i", 1020, RH, SP, x.a + frame);
        PutMoveRRI(op, max, RH, RH, x.b);
        ClearRc(RH);
        x.r := RH; incR
      ELSIF x.mode = RegI THEN
        eStr("(regi) x.a:"); eInt(x.a);
        PutMoveRRI(op, max, x.r, x.r, x.a);
        ClearRc(x.r);
      ELSIF x.mode = Cond THEN
        eStr("(cond");
        IF x.lf = 0 THEN x.lf := NextLabel(); END;
        PutCondBranch(negated(x.r), x.lf);
        (* IF x.lt # 0 THEN PutLabel(x.lt) END; *)
        PutRI("movi", RH, 1); 
        lbl := NextLabel();
        PutJump("j", lbl);
        PutLabel(x.lf); x.lf := 0;
        PutRI("movi", RH, 0); 
        PutLabel(lbl);
        x.r := RH; incR
      END;
      x.mode := Reg
    ELSE eStr("(reg) no gen")
    END
  END load;

  PROCEDURE loadAdr(VAR x: Item);
  VAR
    offset : INTEGER;
  BEGIN
    e("loadAdr");
    IF x.mode = ORB.Var THEN
      IF x.r > 0 THEN (*local*)
        eStr(" (stack var) name:"); eStr(x.name); eStr(" x.a:"); eInt(x.a); eStr(" frame:"); eInt(frame);
        offset := x.a + frame;
        IF offset > 127 THEN
          PutRI("movi", RH, offset);
          PutRRR("add", RH, RH, SP)
        ELSIF offset # 0 THEN
          PutRRI("addi", RH, SP, offset); 
        ELSE
          PutRR("mov", RH, SP);
        END;
        SetRcI(RH, SP, offset, LOC)
      ELSE 
        eStr(" (local/imported var) name:"); eStr(x.name); eStr(" x.a:"); eInt(x.a);
        IF x.a > 127 THEN
          PutRI("movi", RH+1, x.a);
          IF x.r = 0 THEN
            PutRRR("add", RH, SB, RH+1);
            SetRcI(RH, SB, x.a, LOC);
          ELSE
            GetExtSB(x.r); 
            PutRRR("add", RH, RH, RH+1);
            ClearRc(RH);
          END;
        ELSE (* TBC *)
          IF x.r = 0 THEN
            IF x.a = 0 THEN
              PutRR("mov", RH, SB);
            ELSE
              PutRRI("addi", RH, SB, x.a)
            END
          ELSE
            IF x.a # 0 THEN PutRRI("addi", RH, RH, x.a) END
          END
        END
      END ;
      x.r := RH; incR
    ELSIF x.mode = ORB.Par THEN 
      eStr(" (par)"); eStr(" x.a:"); eInt(x.a); eStr(" frame:"); eInt(frame);
      PutMoveRRI("l32i", 1020, RH, SP, x.a + frame);
      IF x.b # 0 THEN 
        IF x.b > 127 THEN
          PutRI("movi", RH+1, x.b);
          PutRRR("add", RH, RH, RH+1);
        ELSIF x.b # 0 THEN
          PutRRI("addi", RH, RH, x.b);
        END
      END;
      x.r := RH; incR
    ELSIF x.mode = RegI THEN
      eStr(" (regi)");
      IF x.a # 0 THEN
        IF x.a > 127 THEN
          PutRI("movi", RH, x.a);
          PutRRR("add", x.r, x.r, RH);
        ELSIF x.a # 0 THEN
          PutRRI("addi", x.r, x.r, x.a);
        END
      END
    ELSE 
      ORS.Mark("address error")
    END ;
    x.mode := Reg
  END loadAdr;

  PROCEDURE loadCond(VAR x: Item);
  BEGIN
    e("loadCond");
    IF x.type.form = ORB.Bool THEN
      IF x.mode = ORB.Const THEN (* TRUE of FALSE constants *)
        PutRI("movi", RH, x.a);
        x.r := NE;
        incR
      ELSE  
        load(x);
        x.r := NE
      END;
      x.mode := Cond; x.a := 0; x.b := 0
    ELSE 
      ORS.Mark("not Boolean?")
    END
  END loadCond;

  PROCEDURE loadTypTagAdr(T: ORB.Type);
    VAR 
      offset : INTEGER;
  BEGIN 
    e("loadTypTagAdr mno:"); eInt(T.mno); eStr(" offset:"); eInt(T.len);
    offset := T.len;
    CheckFreeRegs(1);
    GetTypesDescrSB(-T.mno);
    IF offset > 127 THEN
      CheckFreeRegs(2);
      PutRI("movi", RH+1, offset);
      PutRRR("add", RH, RH, RH+1)
    ELSIF offset # 0 THEN
      PutRRI("addi", RH, RH, offset)
    END;
    incR
  END loadTypTagAdr;

  PROCEDURE loadStringAdr(VAR x: Item);
  BEGIN 
    e("loadStringAdr");
    CheckFreeRegs(2);
    Texts.WriteString(CodeW, "    movi a");
    Texts.WriteInt(CodeW, RH, 0);
    Texts.WriteString(CodeW, ", _");
    Texts.WriteString(CodeW, thisModuleId);
    Texts.WriteString(CodeW, "_data_strs");
    Texts.WriteLn(CodeW);

    IF x.a <= 127 THEN
      IF x.a # 0 THEN PutRRI("addi", RH, RH, x.a) END
    ELSE
      PutRI("movi", RH+1, x.a);
      PutRRR("add", RH, RH, RH+1);
    END;
    x.mode := Reg; 
    x.r := RH; incR
  END loadStringAdr;

  (* Items: Conversion from constants or from Objects on the Heap to Items on the Stack *)

  PROCEDURE MakeConstItem*(VAR x: Item; typ: ORB.Type; val: INTEGER);
  BEGIN 
    e("MakeConstItem");
    x.mode := ORB.Const; x.type := typ; x.a := val
  END MakeConstItem;

  PROCEDURE MakeRealItem*(VAR x: Item; val: REAL);
  BEGIN 
    e("MakeRealItem");
    x.mode := ORB.Const; 
    x.type := ORB.realType; 
    (* x.a := SYSTEM.VAL(INTEGER, val); *)
    SYS.RealToInt(val, x.a)
  END MakeRealItem;

  PROCEDURE MakeStringItem*(VAR x: Item; len: INTEGER); (*copies string from ORS-buffer to ORG-string array*)
    VAR i: INTEGER;
  BEGIN 
    e("MakeStringItem");
    x.mode := ORB.Const; 
    x.type := ORB.strType; 
    x.a := strx; x.b := len; i := 0;
    IF strx + len + 4 < maxStrx THEN
      WHILE len > 0 DO str[strx] := ORS.str[i]; INC(strx); INC(i); DEC(len) END ;
      WHILE strx MOD 4 # 0 DO str[strx] := 0X; INC(strx) END
    ELSE 
      ORS.Mark("too many strings")
    END
  END MakeStringItem;

  PROCEDURE MakeItem*(VAR x: Item; y: ORB.Object; curlev: INTEGER);
  BEGIN 
    e("MakeItem class:"); eInt(y.class); eStr(" val:"); eInt(y.val);
    x.mode := y.class; 
    x.type := y.type; 
    x.a    := y.val; 
    x.rdo  := y.rdo;
    IF y.class = ORB.Par THEN
      x.b := 0
    ELSIF (y.class = ORB.Const) & (y.type.form = ORB.String) THEN
      eStr(" len:");
      x.b := y.lev  (* length *)
    ELSE
      eStr(" lev:");
      x.r := y.lev    (* level *)
    END ;
    eInt(y.lev);
    IF (y.lev > 0) & (y.lev # curlev) & (y.class # ORB.Const) THEN 
      ORS.Mark("not accessible ")
    END;
    (* x.lf := 0;
    x.lt := 0; *)
    eStr(" name:"); eStr(y.name);
    x.name := y.name
  END MakeItem;

  (* Code generation for Selectors, Variables, Constants *)

  PROCEDURE Field*(VAR x: Item; y: ORB.Object);   (* x := x.y *)
  BEGIN
    e("Field");
    IF x.mode = ORB.Var THEN
      IF x.r >= 0 THEN x.a := x.a + y.val
      ELSE loadAdr(x); x.mode := RegI; x.a := y.val
      END
    ELSIF x.mode = RegI THEN x.a := x.a + y.val
    ELSIF x.mode = ORB.Par THEN x.b := x.b + y.val
    END
  END Field;

  PROCEDURE Index*(VAR x, y: Item);   (* x := x[y] *)
    VAR size, limit: INTEGER;
  BEGIN 
    e("Index");
    size := x.type.base.size; 
    limit := x.type.len;
    IF (y.mode = ORB.Const) & (limit >= 0) THEN
      IF (y.a < 0) OR (y.a >= limit) THEN ORS.Mark("bad index") END ;
      IF x.mode IN {ORB.Var, RegI} THEN x.a := y.a * size + x.a
      ELSIF x.mode = ORB.Par THEN x.b := y.a * size + x.b
      END
    ELSE 
      load(y);
      IF check THEN  (* check array bounds *)
        IF limit >= 0 THEN 
          PutRI("movi", RH, limit)
        ELSE (*open array*)
          IF x.mode IN {ORB.Var, ORB.Par} THEN
            PutMoveRRI("l32i", 1020, RH, SP, x.a + 4 + frame); 
          ELSE 
            ORS.Mark("error in Index")
          END
        END;
        incR;
        Trap(GT, TrIndex); incR
      END;
      IF size = 4 THEN 
        PutRRI("slli", y.r, y.r, 2)
      ELSIF size > 1 THEN 
        CheckFreeRegs(1);
        PutRI("movi", RH, size);
        PutRRR("mull", y.r, y.r, RH) 
      END;
      IF x.mode = ORB.Var THEN
        IF x.r > 0 THEN 
          PutRRR("add", y.r, SP, y.r); 
          INC(x.a, frame)
        ELSE 
          CheckFreeRegs(1);
          IF x.r = 0 THEN 
            PutRRR("add", y.r, SB, y.r)
          ELSE 
            GetExtSB(x.r);
            CheckFreeRegs(2);
            PutRI("movi", RH+1, x.a);
            PutRRR("add", RH, RH, RH+1); 
            PutRRR("add", y.r, RH, y.r); 
            x.a := 0
          END
        END ;
        x.r := y.r; 
        x.mode := RegI
      ELSIF x.mode = ORB.Par THEN
        PutMoveRRI("l32i", 1020, RH, SP, x.a + frame);
        PutRRR("add", y.r, RH, y.r); 
        x.mode := RegI; 
        x.r := y.r; 
        x.a := x.b
      ELSIF x.mode = RegI THEN 
        PutRRR("add", x.r, x.r, y.r); 
        decR
      END
    END
  END Index;

  PROCEDURE DeRef*(VAR x: Item);
  BEGIN
    e("DoRef");
    IF x.mode = ORB.Var THEN
      CheckFreeRegs(1);
      IF x.r > 0 THEN (*local*) 
        PutMoveRRI("l32i", 1020, RH, SP, x.a + frame)
      ELSE 
        IF x.r = 0 THEN
          PutMoveRRI("l32i", 1020, RH, SB, x.a)
        ELSE
          GetExtSB(x.r);
          PutMoveRRI("l32i", 1020, RH, RH, x.a)
        END
      END;
      NilCheck; 
      x.r := RH; incR
    ELSIF x.mode = ORB.Par THEN
      CheckFreeRegs(1);
      PutMoveRRI("l32i", 1020, RH, SP, x.a + frame);
      PutMoveRRI("l32i", 1020, RH, RH, x.b);
      NilCheck; 
      x.r := RH; incR
    ELSIF x.mode = RegI THEN 
      PutMoveRRI("l32i", 1020, x.r, x.r, x.a);
      NilCheck
    ELSIF x.mode # Reg THEN 
      ORS.Mark("bad mode in DeRef")
    END ;
    x.mode := RegI; 
    x.a := 0; 
    x.b := 0
  END DeRef;

  PROCEDURE Q(T: ORB.Type; VAR dcw: INTEGER);
  BEGIN 
    (* one entry of type descriptor extension table *)
    (* T.len is the descriptor address offset *)
    (* T.mno is level (0 is this module, Not 0 is import) *)
    IF T.base # NIL THEN
      Q(T.base, dcw); 
      data[dcw] := (T.mno * 1000H + T.len);
      INC(dcw)
    END
  END Q;

  (* PROCEDURE Q(T: ORB.Type; VAR dcw: INTEGER);
  BEGIN 
    (* one entry of type descriptor extension table *)
    (* T.len is the descriptor address offset *)
    (* T.mno is level (0 is this module, Not 0 is import) *)
    IF T.base # NIL THEN
      Q(T.base, dcw); 
      data[dcw] := (T.mno * 1000H + T.len) * 1000H + dcw - fixorgT;
      fixorgT := dcw; 
      INC(dcw)
    END
  END Q; *)

  PROCEDURE FindPtrFlds(typ: ORB.Type; off: INTEGER; VAR dcw: INTEGER);
    VAR fld: ORB.Object; i, s: INTEGER;
  BEGIN
    e("FindPtrFlds");
    IF (typ.form = ORB.Pointer) OR (typ.form = ORB.NilTyp) THEN 
      data[dcw] := off; 
      INC(dcw)
    ELSIF typ.form = ORB.Record THEN
      fld := typ.dsc;
      WHILE fld # NIL DO 
        FindPtrFlds(fld.type, fld.val + off, dcw); 
        fld := fld.next 
      END
    ELSIF typ.form = ORB.Array THEN
      s := typ.base.size;
      FOR i := 0 TO typ.len-1 DO 
        FindPtrFlds(typ.base, i*s + off, dcw) 
      END
    END
  END FindPtrFlds;

  PROCEDURE BuildTD*(T: ORB.Type; VAR dc: INTEGER);
    VAR dcw, k, s: INTEGER;  (*dcw = word address*)
  BEGIN 
    e("BuildTD");
    dcw := dc DIV 4; 
    s := T.size; (*convert size for heap allocation*)
    IF s <= 24 THEN 
      s := 32 
    ELSIF s <= 56 THEN
      s := 64 
    ELSIF s <= 120 THEN
      s := 128
    ELSE
      s := (s+263) DIV 256 * 256
    END ;
    T.len := dc; (* len used as address offset in types section *)
    data[dcw] := s; 
    INC(dcw);  
    k := T.nofpar;   (* extension level! *)
    IF k > 3 THEN 
      ORS.Mark("record type extention level too large")
    ELSE 
      Q(T, dcw);
      WHILE k < 3 DO 
        data[dcw] := -1; 
        INC(dcw); 
        INC(k) 
      END
    END;
    FindPtrFlds(T, 0, dcw); 
    data[dcw] := -1; 
    INC(dcw); 
    tdx := dcw; 
    dc := dcw * 4;
    IF tdx >= maxTD THEN 
      ORS.Mark("too many record types"); 
      tdx := 0 
    END
  END BuildTD;

  (* PROCEDURE TypeTest*(VAR x: Item; T: ORB.Type; varpar, isguard: BOOLEAN);
    VAR pc0: LONGINT;
  BEGIN
    IF T = NIL THEN
      IF x.mode >= Reg THEN DEC(RH) END ;
      SetCC(x, 7)
    ELSE (*fetch tag into RH*)
      IF varpar THEN Put2(Ldr, RH, SP, x.a+4+frame)
      ELSE load(x);
        pc0 := pc; Put3(BC, EQ, 0);  (*NIL belongs to every pointer type*)
        Put2(Ldr, RH, x.r, -8)
      END ;
      Put2(Ldr, RH, RH, T.nofpar*4); incR;
      loadTypTagAdr(T);  (*tag of T*)
      Put0(Cmp, RH-1, RH-1, RH-2); DEC(RH, 2);
      IF ~varpar THEN fix(pc0, pc - pc0 - 1) END ;
      IF isguard THEN
        IF check THEN Trap(NE, 2) END
      ELSE SetCC(x, EQ);
        IF ~varpar THEN DEC(RH) END
      END
    END
  END TypeTest; *)
  
  PROCEDURE TypeTest*(VAR x: Item; T: ORB.Type; varpar, isguard: BOOLEAN);
  VAR lbl: INTEGER;
  BEGIN
    e("TypeTest RH:"); eInt(RH); eStr(" varpar:"); eInt(ORD(varpar)); eStr(" isguard:"); eInt(ORD(isguard));
    IF T = NIL THEN
      IF x.mode >= Reg THEN DEC(RH) END;
      SetCC(x, BR) (* Unconditional jump, no need to test *)
    ELSE 
      (*fetch tag into RH*)
      IF varpar THEN 
        (* Pointer received as a parameter, get tag from next param *)
        PutMoveRRI("l32i", 1020, RH, SP, x.a + 4 + frame);
        PutMoveRRI("l32i", 1020, RH, RH, T.nofpar * 4); incR;
        (* tag of T *)
        loadTypTagAdr(T);
        IF isguard THEN
          IF check THEN Trap(NEQ, TrGuard);
          ELSE decR; decR END
        ELSE SetCC(x, EQU);
        END
      ELSE
        load(x);                         (* Load pointer content (address)    *)
        PutRI("movi", RH, 0);
        lbl := NextLabel();
        PutBranchR("beqz", x.r, lbl);  (* NIL belongs to every pointer type *)
        PutRRI("addi", x.r, x.r, -8);
        PutRRI("l32i", x.r, x.r,  0);
        PutMoveRRI("l32i", 1020, x.r, x.r, T.nofpar * 4);
        (* tag of T *)
        loadTypTagAdr(T);
        PutLabel(lbl);
        IF isguard THEN
          IF check THEN Trap(NEQ, TrGuard); incR
          ELSE decR END
        ELSE SetCC(x, EQU);
        END
      END
    END;
    e("End of TypeTest RH:"); eInt(RH)
  END TypeTest;

  (* Code generation for Boolean operators *)

  PROCEDURE merged(L0, L1: INTEGER): INTEGER;
    VAR L2: INTEGER;
  BEGIN (* merge labels from operand of x and y *)
    IF L0 = 0 THEN 
      L2 := L1
    ELSIF L1 # 0 THEN
      L2 := L0 * MaxLabel + L1;
    ELSE
      L2 := L0
    END;
    RETURN L2
  END merged;

  PROCEDURE Not*(VAR x: Item);   (* x := ~x *)
    VAR t: INTEGER;
  BEGIN
    e("Not");
    IF x.mode # Cond THEN loadCond(x) END ;
    x.r := negated(x.r); t := x.lt; x.lt := x.lf; x.lf := t
  END Not;

  PROCEDURE And1*(VAR x: Item);   (* x := x & *)
  BEGIN
    e("And1 x.lf:"); eInt(x.lf); eStr(" x.lt:"); eInt(x.lt);

    IF x.mode # Cond THEN loadCond(x) END;
    IF x.lf = 0 THEN 
      x.lf := NextLabel()
    END;
    PutCondBranch(negated(x.r), x.lf);
    IF x.lt # 0 THEN PutLabel(x.lt); x.lt := 0 END;

    e("End of And1 x.lf:"); eInt(x.lf); eStr(" x.lt:"); eInt(x.lt);
  END And1;

  PROCEDURE And2*(VAR x, y: Item);
  BEGIN
    e("And2 x.lf:"); eInt(x.lf); eStr(" x.lt:"); eInt(x.lt);
    eStr(" y.lf:"); eInt(y.lf); eStr(" y.lt:"); eInt(y.lt);

    IF y.mode # Cond THEN loadCond(y) END;
    x.lt := y.lt; x.r := y.r; y.lt := 0;
    x.lf := merged(x.lf, y.lf); y.lf := 0;

    e("End of And2 x.lt:"); eInt(x.lf); eStr(" x.lt:"); eInt(x.lt);
    eStr(" y.lf:"); eInt(y.lf); eStr(" y.lt:"); eInt(y.lt);
  END And2;

  PROCEDURE Or1*(VAR x: Item);   (* x := x OR *)
  BEGIN
    e("Or1 x.lf:"); eInt(x.lf); eStr(" x.lt:"); eInt(x.lt);

    IF x.mode # Cond THEN loadCond(x) END ;
    IF x.lt = 0 THEN x.lt := NextLabel() END;
    PutCondBranch(x.r, x.lt);
    IF (x.lf # 0) THEN PutLabel(x.lf); x.lf := 0 END;

    e("End of Or1 x.lf:"); eInt(x.lf); eStr(" x.lt:"); eInt(x.lt);
  END Or1;

  PROCEDURE Or2*(VAR x, y: Item);
  BEGIN
    e("Or2 x.lf:"); eInt(x.lf); eStr(" x.lt:"); eInt(x.lt);
    eStr(" y.lf:"); eInt(y.lf); eStr(" y.lt:"); eInt(y.lt);

    IF y.mode # Cond THEN loadCond(y) END ;
    x.lf := y.lf; x.r := y.r; y.lf := 0;
    x.lt := merged(x.lt, y.lt); y.lt := 0;

    e("End of Or2 x.lt:"); eInt(x.lf); eStr(" x.lt:"); eInt(x.lt);
    eStr(" y.lf:"); eInt(y.lf); eStr(" y.lt:"); eInt(y.lt);
  END Or2;

  PROCEDURE ClearLabels*(VAR x: Item);
  BEGIN 
    x.lt := 0; x.lf := 0
  END ClearLabels;

  (* Code generation for arithmetic operators *)

  PROCEDURE Neg*(VAR x: Item);   (* x := -x *)
  BEGIN
    e("Neg");
    IF x.type.form = ORB.Int THEN
      IF x.mode = ORB.Const THEN x.a := -x.a
      ELSE 
        load(x); 
        PutRR("neg", x.r, x.r)
      END
    ELSIF x.type.form = ORB.Real THEN
      IF x.mode = ORB.Const THEN x.a := x.a + 7FFFFFFFH + 1
      ELSE 
        load(x); 
        PutSR("wfr",   0,   x.r);
        PutSS("neg.s", 0,   0  );
        PutRS("rfr",   x.r, 0  );
      END
    ELSE (*form = Set*)
      IF x.mode = ORB.Const THEN x.a := -x.a-1 
      ELSE
        load(x); 
        PutRI("mov", RH, -1);
        PutRRR("xor", x.r, x.r, RH)
      END
    END
  END Neg;

  PROCEDURE AddOp*(op: INTEGER; VAR x, y: Item);   (* x := x +- y *)
  BEGIN
    e("AddOp");
    IF op = ORS.plus THEN
      IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN
        x.a := x.a + y.a
      ELSIF y.mode = ORB.Const THEN load(x);
        IF y.a # 0 THEN 
          IF (y.a >= -128) & (y.a < 128) THEN
            IF y.a # 0 THEN PutRRI("addi", x.r, x.r, y.a) END
          ELSE
            PutRI("movi", RH, y.a);
            PutRRR("add", x.r, x.r, RH) 
          END
        END
      ELSE 
        load(x); load(y); 
        PutRRR("add", RH-2, x.r, y.r); 
        decR; 
        x.r := RH-1
      END
    ELSE (*op = ORS.minus*)
      IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN 
        x.a := x.a - y.a
      ELSIF y.mode = ORB.Const THEN 
        load(x);
        IF y.a # 0 THEN 
          IF (y.a > -128) & (y.a <= 128) THEN
            IF y.a # 0 THEN PutRRI("addi", x.r, x.r, -y.a) END
          ELSE
            PutRI("movi", RH, y.a);
            PutRRR("sub", x.r, x.r, RH) 
          END
        END
      ELSE 
        load(x); load(y); 
        PutRRR("sub", RH-2, x.r, y.r); 
        decR; 
        x.r := RH-1
      END
    END
  END AddOp;

  PROCEDURE log2(m: INTEGER; VAR e: INTEGER): INTEGER;
  BEGIN 
    e := 0;
    WHILE ~ODD(m) DO m := m DIV 2; INC(e) END ;
    RETURN m
  END log2;
  
  PROCEDURE MulOp*(VAR x, y: Item);   (* x := x * y *)
    VAR ex: INTEGER;
  BEGIN
    e("MulOp");
    IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN x.a := x.a * y.a
    ELSIF (y.mode = ORB.Const) & (y.a >= 2) & (log2(y.a, ex) = 1) THEN 
      load(x);
      PutRRI("slli", x.r, x.r, ex)
    ELSIF y.mode = ORB.Const THEN 
      load(x); 
      PutRI("movi", RH, y.a);
      PutRRR("mull", x.r, x.r, RH)
    ELSIF (x.mode = ORB.Const) & (x.a >= 2) & (log2(x.a, ex) = 1) THEN 
      load(y); 
      PutRRI("slli", y.r, y.r, ex);
      x.mode := Reg; 
      x.r := y.r
    ELSIF x.mode = ORB.Const THEN 
      load(y); 
      PutRI("movi", RH, x.a);
      PutRRR("mull", y.r, y.r, RH);
      x.mode := Reg; 
      x.r := y.r
    ELSE 
      load(x); load(y); 
      PutRRR("mull", RH-2, x.r, y.r); 
      decR; 
      x.r := RH-1
    END
  END MulOp;

  PROCEDURE DivOp*(op: INTEGER; VAR x, y: Item);   (* x := x op y *)
    VAR ex: INTEGER;
  BEGIN
    e("DivOp");
    IF op = ORS.div THEN
      IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN
        IF y.a > 0 THEN
          x.a := x.a DIV y.a 
        ELSE 
          ORS.Mark("bad divisor") 
        END
      ELSIF (y.mode = ORB.Const) & (y.a >= 2) & (log2(y.a, ex) = 1) THEN 
        load(x); 
        PutRRI("srai", x.r, x.r, ex)
      ELSIF y.mode = ORB.Const THEN
        IF y.a > 0 THEN
          load(x); 
          PutRI("movi", RH, y.a);
          PutRRR("quos", x.r, x.r, RH);
        ELSE
          ORS.Mark("bad divisor") 
        END
      ELSE 
        load(y);
        IF check THEN Trap(EQ, TrZeroDiv); incR END ;
        load(x); 
        PutRRR("quos", RH-2, x.r, y.r); 
        decR; 
        x.r := RH-1
      END
    ELSE (* op = ORS.mod *)
      IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN
        IF y.a > 0 THEN 
          x.a := x.a MOD y.a 
        ELSE
          ORS.Mark("bad modulus")
        END
      ELSIF (y.mode = ORB.Const) & (y.a >= 2) & (log2(y.a, ex) = 1) THEN
        load(x);
        PutRI("movi", RH, y.a-1);
        PutRRR("and", x.r, x.r, RH);
      ELSIF y.mode = ORB.Const THEN
        IF y.a > 0 THEN 
          load(x);
          PutRI("movi", RH, y.a);
          PutRRR("rems", x.r, x.r, RH);
        ELSE
          ORS.Mark("bad modulus")
        END
      ELSE
        load(x);
        IF check THEN Trap(EQ, TrZeroDiv); incR END ;
        load(y); 
        PutRRR("rems", RH-2, x.r, y.r);
        decR
      END
    END
  END DivOp;

  PROCEDURE AdjustVal*(VAR x: Item; targetType: ORB.Type);
  BEGIN
    IF x.type.size > targetType.size THEN
      load(x);
      IF targetType.size = 1 THEN
        PutRI("movi", RH, 255);
        PutRRR("and", x.r, x.r, RH)
      END
    END
  END AdjustVal;

  (* Code generation for REAL operators *)

  PROCEDURE RealOp*(op: INTEGER; VAR x, y: Item);   (* x := x op y *)
  VAR xx, yy : REAL;
  BEGIN 
    e("RealOp");
    IF  y.mode = ORB.Const THEN SYS.IntToReal(y.a, yy) END;
    IF (y.mode = ORB.Const) & (yy = 0.0) THEN 
      SYS.IntToReal(07FFFFFFFH, xx) (* NaN *)
    ELSIF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN
      SYS.IntToReal(x.a, xx);
      IF    op = ORS.plus  THEN xx := xx + yy
      ELSIF op = ORS.minus THEN xx := xx - yy
      ELSIF op = ORS.times THEN xx := xx * yy
      ELSIF op = ORS.rdiv  THEN xx := xx / yy
      END;
      SYS.RealToInt(xx, x.a)
    ELSE
      load(x); load(y);
      PutSR("wfr", 0, x.r);
      PutSR("wfr", 1, y.r);
      IF    op = ORS.plus  THEN PutSSS("add.s", 2, 0, 1)
      ELSIF op = ORS.minus THEN PutSSS("sub.s", 2, 0, 1)
      ELSIF op = ORS.times THEN PutSSS("mul.s", 2, 0, 1)
      ELSIF op = ORS.rdiv  THEN
        (* __fdiv32 is supplied in the startup code and compute f2 := f0 / f1 *) 
        PutRR("mov", RH, 0); (* Save return address *)
        PutA("call0", "__fdiv32");
        PutRR("mov", 0, RH); (* Restore return address *)
      END;
      decR; x.r := RH-1;
      PutRS("rfr", x.r, 2);
    END
  END RealOp;

  (* Code generation for set operators *)

  PROCEDURE Singleton*(VAR x: Item);  (* x := {x} *)
  BEGIN
    e("Singleton");
    IF x.mode = ORB.Const THEN x.a := LSL(1, x.a) 
    ELSE
      load(x);
      PutRI("movi", RH, 1);
      PutR( "ssl",  x.r);
      PutRR("sll",  x.r, RH)
    END
  END Singleton;

  PROCEDURE Set*(VAR x, y: Item);   (* x := {x .. y} *)
  VAR lbl: INTEGER;
  BEGIN
    e("Set");
    IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN
      IF x.a <= y.a THEN 
        x.a := LSL(2, y.a) - LSL(1, x.a) 
      ELSE 
        x.a := 0 
      END
    ELSE
      IF x.mode = ORB.Const THEN
        x.a := LSL(-1, x.a);
        PutRI("movi", RH, x.a);
        x.r := RH; incR;
        x.mode := Reg
      ELSE 
        load(x); 
        PutRI("movi", RH, -1);
        PutR("ssl", x.r);
        PutRR("sll", x.r, RH);
      END ;
      IF (y.mode # ORB.Const) OR (y.a < 31) THEN 
        IF y.mode = ORB.Const THEN 
          y.a := LSL(-1, y.a + 1);
          PutRI("movi", RH, y.a);
          y.r := RH; incR
        ELSE 
          load(y); 
          lbl := NextLabel();
          PutBranchRI("bgei", y.r, 31, lbl);
          PutRI("movi", RH, -1);
          PutRRI("addi", y.r, y.r, 1);
          PutR("ssl", y.r);
          PutRR("sll", y.r, RH);
        END;
        PutRRR("xor", x.r, x.r, y.r);
        IF y.mode # ORB.Const THEN PutLabel(lbl) END;
        decR
      END
    END
  END Set;

  PROCEDURE In*(VAR x, y: Item);  (* x := x IN y *)
  BEGIN 
    e("In");
    load(y);
    IF x.mode = ORB.Const THEN 
      PutRRII("extui", y.r, y.r, x.a, 1);
      SetCC(x, NE)   (* Branch if not equal to zero *)
    ELSE 
      load(x); 
      SetCC(x, BST); (* Branch on Bit Set *)
    END;
  END In;

  PROCEDURE SetOp*(op: INTEGER; VAR x, y: Item);   (* x := x op y *)
    VAR xset, yset: SET; (*x.type.form = Set*)
  BEGIN
    e("SetOp");
    IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN
      xset := SYSTEM.VAL(SET, x.a); 
      yset := SYSTEM.VAL(SET, y.a);
      IF op = ORS.plus THEN xset := xset + yset
      ELSIF op = ORS.minus THEN xset := xset - yset
      ELSIF op = ORS.times THEN xset := xset * yset
      ELSIF op = ORS.rdiv THEN xset := xset / yset
      END;
      x.a := SYSTEM.VAL(INTEGER, xset)
    ELSIF y.mode = ORB.Const THEN
      load(x);
      PutRI("movi", RH, y.a);
      IF op = ORS.plus THEN 
        PutRRR("or", x.r, x.r, RH)
      ELSIF op = ORS.minus THEN 
        PutRI("movi", RH+1, -1); 
        PutRRR("xor", RH, RH, RH+1);
        PutRRR("and", x.r, x.r, RH)
      ELSIF op = ORS.times THEN 
        PutRRR("and", x.r, x.r, RH)
      ELSIF op = ORS.rdiv THEN
        PutRRR("xor", x.r, x.r, RH)
      END;
    ELSE 
      load(x); load(y);
      IF op = ORS.plus THEN PutRRR("or", RH-2, x.r, y.r)
      ELSIF op = ORS.minus THEN 
        PutRI("movi", RH, -1); 
        PutRRR("xor", y.r, y.r, RH);
        PutRRR("and", x.r, x.r, y.r)
      ELSIF op = ORS.times THEN 
        PutRRR("and", RH-2, x.r, y.r)
      ELSIF op = ORS.rdiv THEN 
        PutRRR("xor", RH-2, x.r, y.r)
      END;
      decR; 
      x.r := RH-1
    END 
  END SetOp;

    (* Case Statements *)

  PROCEDURE CaseHead*(VAR x: Item; VAR L0, L1: INTEGER); (* L0 = Jump Table High bound addr, L1 = ELSE clause *)
  VAR lbl: INTEGER;
  BEGIN 
    e("CaseHead");
    CheckFreeRegs(4);
    load(x);                              (* value of case expression *)
    PutRL("movi", RH, L0);                (* Get address of case table *)
    PutRRI("l32i", RH+1, RH, 0);          (* Low bound *)
    PutRR("mov", RH+2, RH+1);             (* Save it for later *)
    lbl := NextLabel();
    PutBranchRR("bge", x.r, RH+1, lbl);
    PutJump("j", L1);                     (* Else clause if lower *)
    PutLabel(lbl);
    PutRRI("l32i", RH+1, RH, 4);
    lbl := NextLabel();
    PutBranchRR("blt", x.r, RH+1, lbl);
    PutJump("j", L1);                     (* Else clause if higher *)
    PutLabel(lbl);
    PutRRI("addi", RH, RH, 8);            (* Compute index in table *)
    PutRRR("sub", x.r, x.r, RH+2);
    PutRRI("slli", x.r, x.r, 2);
    PutRRR("add", RH, RH, x.r);
    PutRRI("l32i", RH, RH, 0);            (* Get address *)
    PutR("jx", RH);
    decR;
  END CaseHead;

  PROCEDURE CaseTail*(L0, L1, n: INTEGER; VAR tab: ARRAY OF LabelRange);  (* L0: Jump Table label, L1 = label for else *)
    VAR i, j, l1: INTEGER;

    PROCEDURE PutEntry(lbl: INTEGER);
    BEGIN 
      Texts.WriteString(CodeW, "    .int ");
      Texts.WriteInt(CodeW, lbl, 0);
      Texts.WriteString(CodeW, "$");
      Texts.WriteLn(CodeW);
    END PutEntry;

  BEGIN
    e("CaseTail");
    Texts.WriteString(CodeW, ".align 4"); Texts.WriteLn(CodeW);
    PutLabel(L0);
    IF n > 0 THEN 
      Texts.WriteString(CodeW, "    .int "); Texts.WriteInt(CodeW, tab[0].low, 0);        Texts.WriteLn(CodeW);  (* Low Bound *)
      Texts.WriteString(CodeW, "    .int "); Texts.WriteInt(CodeW, tab[n-1].high + 1, 0); Texts.WriteLn(CodeW); (* High Bound *)
    ELSIF L1 > 0 THEN  (* L1 will be negative if no ELSE case present *)
      Texts.WriteString(CodeW, "    .int  0"); Texts.WriteLn(CodeW);  (* Low Bound *)
      Texts.WriteString(CodeW, "    .int -1"); Texts.WriteLn(CodeW); (* High Bound *)
    ELSE ORS.Mark("empty case") END;

    (* IF L1 = 0 THEN L1 := pc; Trap(7, 1) END ;  create else ???? *)
    
    IF L1 < 0 THEN l1 := -L1 ELSE l1 := L1 END;
    IF n > 0 THEN
      j := tab[0].low;
      FOR i := 0 TO n-1 DO  (* construct jump table *)
        WHILE j < tab[i].low DO PutEntry(l1); INC(j) END;  (* else *)
        WHILE j <= tab[i].high DO PutEntry(tab[i].label); INC(j) END
      END
    END
  END CaseTail;

  (* Code generation for relations *)

  (* The relations are the following:
       eql = 9; neq = 10; lss = 11; leq = 12; gtr = 13; geq = 14;
     the Condition codes to use are:
        EQU      NEQ        LT        LE        GT        GE         
   *)
  PROCEDURE IntRelation*(op: INTEGER; VAR x, y: Item);   (* x := x < y *)
  VAR cond: INTEGER;
  BEGIN
    e("int relation");
    CheckFreeRegs(2);
    cond := relmap[op - ORS.eql];
    load(x); 
    IF y.mode = ORB.Const THEN
      PutRI("movi", RH, y.a);
      incR
    ELSE
      IF (x.mode = Cond) OR (y.mode = Cond) THEN ORS.Mark("not implemented") END;
      load(y);
      IF y.r = (RH-2) THEN
        cond := cond + 100; (* arguments must be reversed *)
      ELSIF y.r # (RH-1) THEN
        ORS.Mark("Internal error: IntRelation");
      END
    END;
    SetCC(x, cond);
  END IntRelation;

  (* Reals are treated as integers for comparaison. Equality won't work if
     both positive and negative zeroes are compared. *)
  PROCEDURE RealRelation*(op: INTEGER; VAR x, y: Item);   (* x := x < y *)
  VAR cond: INTEGER;
  BEGIN
    e("real relation");
    CheckFreeRegs(2);
    cond := relmap[op - ORS.eql];
    load(x); 
    IF y.mode = ORB.Const THEN
      PutRI("movi", RH, y.a);
      incR
    ELSE
      load(y);
      IF y.r = (RH-2) THEN
        cond := cond + 100; (* arguments must be reversed *)
      ELSIF y.r # (RH-1) THEN
        ORS.Mark("Internal error: RealRelation");
      END
    END;
    SetCC(x, cond);
  END RealRelation;

  PROCEDURE StringRelation*(op: INTEGER; VAR x, y: Item);   (* x := x < y *)
    (* x, y are char arrays or strings *)
  VAR lbl1, lbl2: INTEGER;
  BEGIN
    e("string relation");
    CheckFreeRegs(4);
    incR; incR;
    IF x.type.form = ORB.String THEN loadStringAdr(x) ELSE loadAdr(x) END ;
    IF y.type.form = ORB.String THEN loadStringAdr(y) ELSE loadAdr(y) END ;
    decR; decR; decR; decR;
    lbl1 := NextLabel();
    PutLabel(lbl1);
    PutRRI("l8ui", RH, x.r, 0);
    PutRRI("addi", x.r, x.r, 1);
    PutRRI("l8ui", RH+1, y.r, 0);
    PutRRI("addi", y.r, y.r, 1);
    lbl2 := NextLabel();
    PutBranchRR("bne", RH, RH+1, lbl2);
    PutBranchR("bnez", RH, lbl1);
    PutLabel(lbl2);
    incR; incR;
    SetCC(x, relmap[op - ORS.eql])
  END StringRelation;

  (* Code generation of Assignments *)

  PROCEDURE StrToChar*(VAR x: Item);
  BEGIN 
    e("StrToChar");
    x.type := ORB.charType; DEC(strx, 4); x.a := ORD(str[x.a])
  END StrToChar;

  PROCEDURE CharToStr*(VAR x: Item);
  BEGIN 
    e("CharToStr");
    x.type := ORB.strType; str[strx] := CHR(x.a); x.a := strx; x.b := 1; INC(strx);
    WHILE strx MOD 4 # 0 DO str[strx] := 0X; INC(strx) END
  END CharToStr;

  PROCEDURE Store*(VAR x, y: Item); (* x := y *)
    VAR 
      op: ARRAY 5 OF CHAR;
      max: INTEGER;
  BEGIN
    load(y);
    e("Store ");
    IF x.type.size = 1 THEN op := "s8i"; max := 255 ELSE op := "s32i"; max := 1020 END ;
    IF x.mode = ORB.Var THEN
      eStr("(var) "); eStr(x.name);
      IF x.r > 0 THEN (* local *)
        eStr(" (stack) x.a:"); eInt(x.a); eStr(" frame:"); eInt(frame);
        PutMoveRRI(op, max, y.r, SP, x.a + frame);
      ELSE (* imported or module *)
        IF x.r = 0 THEN
          eStr(" (SB) x.a:"); eInt(x.a);
          PutMoveRRI(op, max, y.r, SB, x.a);
        ELSE
          eStr(" (import) x.a:"); eInt(x.a);
          GetExtSB(x.r);
          PutMoveRRI(op, max, y.r, RH, x.a);
        END
      END
    ELSIF x.mode = ORB.Par THEN
      eStr("(par) "); eStr(x.name); eStr(" x.a:"); eInt(x.a); eStr(" frame:"); eInt(frame);
      PutMoveRRI("l32i", 1020, RH, SP, x.a + frame);
      PutMoveRRI(op, max, y.r, RH, x.b);
    ELSIF x.mode = RegI THEN 
      eStr("(regi) x.a:"); eInt(x.a);
      PutMoveRRI(op, max, y.r, x.r, x.a); 
      decR;
    ELSE 
      ORS.Mark("bad mode in Store")
    END ;
    decR
  END Store;

  PROCEDURE StoreStruct*(VAR x, y: Item); (* x := y, frame = 0 *)
  VAR size, lbl: INTEGER;
  BEGIN
    e("StoreStruct");
    IF y.type.size # 0 THEN
      loadAdr(x); loadAdr(y);
      IF (x.type.form = ORB.Array) &  (x.type.len > 0) THEN
        IF y.type.len >= 0 THEN 
          IF x.type.size = y.type.size THEN 
            PutRI("movi", RH, (y.type.size+3) DIV 4)
          ELSE 
            ORS.Mark("different length/size, not implemented")
          END
        ELSE (*y  open array*) 
          PutMoveRRI("l32i", 1020, RH, SP, x.a + 4);
          size := y.type.base.size;  (* element size *)
          lbl := NextLabel();
          PutBranchR("beqz", RH, lbl);
          IF size = 1 THEN 
            PutRRI("addi", RH, RH, 3); 
            PutRRI("srai", RH, RH, 2)
          ELSIF size # 4 THEN
            PutRI("movi", RH+1, size DIV 4);
            PutRRR("mull", RH, RH, RH+1)
          END;
          IF check THEN
            PutRI("movi", RH+1, (x.type.size + 3) DIV 4); 
            incR; incR; 
            Trap(GT, TrCopy)
          END;
          PutLabel(lbl)
        END
      ELSIF x.type.form = ORB.Record THEN 
        PutRI("movi", RH, x.type.size DIV 4)
      ELSE 
        ORS.Mark("inadmissible assignment")
      END;
      lbl := NextLabel();
      PutBranchR("loop", RH, lbl);
        PutRRI("l32i", RH+1, y.r, 0); 
        PutRRI("addi", y.r, y.r, 4);
        PutRRI("s32i", RH+1, x.r, 0); 
        PutRRI("addi", x.r, x.r, 4);
      PutLabel(lbl)
    END ;
    RH := FirstRH; UsedRegs := {}
  END StoreStruct;

  PROCEDURE CopyString*(VAR x, y: Item);  (* x := y *) 
  VAR len, lbl: INTEGER;
  BEGIN 
    e("CopyString");
    CheckFreeRegs(4);
    loadAdr(x); 
    len := x.type.len;
    IF len >= 0 THEN
      IF len <  y.b THEN ORS.Mark("string too long") END
    ELSIF check THEN 
      PutMoveRRI("l32i", 1020, RH, SP, x.a + 4); (* open array len, frame = 0 *)
      PutRI("movi", RH+1, y.b);
      incR; incR;
      Trap(LT, TrCopy)
    END ;
    loadStringAdr(y);
    PutRI("movi", RH, (y.b + 3) DIV 4);
    lbl := NextLabel();
    PutBranchR("loop", RH, lbl);
      PutRRI("l32i", RH+1,  y.r, 0); 
      PutRRI("addi", y.r, y.r, 4);
      PutRRI("s32i", RH+1,  x.r, 0); 
      PutRRI("addi", x.r, x.r, 4);
    PutLabel(lbl);
    RH := FirstRH; UsedRegs := {}
   END CopyString;
  
  (* Code generation for parameters *)
  
  PROCEDURE OpenArrayParam*(VAR x: Item);
  BEGIN loadAdr(x);
    e("OpenArrayParam");
    IF x.type.len >= 0 THEN 
      PutRI("movi", RH, x.type.len) 
    ELSE
      PutMoveRRI("l32i", 1020, RH, SP, x.a + 4 + frame); 
    END;
    incR
  END OpenArrayParam;

  PROCEDURE VarParam*(VAR x: Item; ftype: ORB.Type);
  VAR xmd: INTEGER;
  BEGIN 
    e("VarParam");
    xmd := x.mode; loadAdr(x);
    IF (ftype.form = ORB.Array) & (ftype.len < 0) THEN (*open array*)
      IF x.type.len >= 0 THEN 
        PutRI("movi", RH, x.type.len) 
      ELSE  
        PutMoveRRI("l32i", 1020, RH, SP, x.a + 4 + frame);
      END;
      incR
    ELSIF ftype.form = ORB.Record THEN
      IF xmd = ORB.Par THEN
        PutMoveRRI("l32i", 1020, RH, SP, x.a + 4 + frame); 
        incR 
      ELSE 
        loadTypTagAdr(x.type) 
      END
    END
  END VarParam;

  PROCEDURE ValueParam*(VAR x: Item);
  BEGIN 
    e("ValueParam");
    load(x)
  END ValueParam;

  PROCEDURE StringParam*(VAR x: Item);
  BEGIN 
    e("StringParam");
    loadStringAdr(x); 
    PutRI("movi", RH, x.b);
    incR  (*len*)
  END StringParam;

  (* For Statements *)

  PROCEDURE For0*(VAR x, y: Item);
  BEGIN 
    e("For0");
    load(y)
  END For0;

  PROCEDURE For1*(VAR x, y, z, w: Item; VAR L: INTEGER); (* for x := y to z by w *)
  BEGIN 
    e("For1");
    IF z.mode = ORB.Const THEN 
      PutRI("movi", RH, z.a);
      incR
    ELSE
      load(z); 
    END ;
    
    L := NextLabel();

    IF w.a > 0 THEN PutCondBranch(GT, L)
    ELSIF w.a < 0 THEN PutCondBranch(LT, L)
    ELSE 
      ORS.Mark("zero increment");
      PutCondBranch(GT, L) (* Just to keep Reg mgt happy *)
    END;
    incR;
    Store(x, y)
  END For1;

  PROCEDURE For2*(VAR x, y, w: Item);
  BEGIN 
    e("For2");
    load(x); 
    IF (w.a >= -128) & (w.a <= 127) THEN
      IF w.a # 0 THEN PutRRI("addi", x.r, x.r, w.a) END
    ELSE
      PutRI("movi", RH, w.a);
      PutRRI("add",  x.r, x.r, RH)
    END;
    decR
  END For2;

  (* Branches, procedure calls, procedure prolog and epilog *)

  PROCEDURE Here*(): INTEGER;
  VAR lbl: INTEGER;
  BEGIN
    e("Here");
    lbl := NextLabel();
    PutLabel(lbl);
    RETURN lbl
  END Here;

  PROCEDURE GetLabelTF*(VAR x: Item);
  BEGIN 
    IF x.lt = 0 THEN x.lt := NextLabel() END;
    IF x.lf = 0 THEN x.lf := NextLabel() END
  END GetLabelTF;

  PROCEDURE GetSetLabelTF*(VAR x: Item; VAR L: INTEGER);
  BEGIN 
    IF x.lt = 0 THEN x.lt := NextLabel() END;
    IF x.lf = 0 THEN x.lf := NextLabel() END;
    L := x.lf;
  END GetSetLabelTF;

  PROCEDURE GetLabelT*(VAR x: Item);
  BEGIN 
    IF x.lt = 0 THEN x.lt := NextLabel() END
  END GetLabelT;

  PROCEDURE GetLabelF*(VAR x: Item);
  BEGIN 
    IF x.lf = 0 THEN x.lf := NextLabel() END
  END GetLabelF;

  PROCEDURE GetLabel*(VAR L: INTEGER);
  BEGIN
    L := NextLabel()
  END GetLabel;

  PROCEDURE FJump*(L: INTEGER);
  BEGIN 
    e("FJump");
    PutJump("j", L);
  END FJump;

  PROCEDURE CFJump*(VAR x: Item);
  BEGIN
    e("CFJump");
    IF x.mode # Cond THEN loadCond(x) END;
    IF x.lf = 0 THEN x.lf := NextLabel() END;
    PutCondBranch(negated(x.r), x.lf); 
    IF x.lt # 0 THEN PutLabel(x.lt); x.lt := 0 END
  END CFJump;

  PROCEDURE BJump*(L: INTEGER);
  BEGIN 
    e("BJump");
    PutJump("j", L)
  END BJump;

  PROCEDURE CBJump*(VAR x: Item; L: INTEGER);
  BEGIN
    e("CBJump");
    IF x.mode # Cond THEN loadCond(x) END ;
    PutCondBranch(negated(x.r), L); 
  END CBJump;

  PROCEDURE SaveRegs(low, high: INTEGER);  (* R[low .. high]*)
    VAR 
      cnt, i: INTEGER;
  BEGIN 
    eStr(" SaveRegs {"); eInt(low); eStr(".."); eInt(high); eStr("}");
    IF high = 15 THEN
      ORS.Mark("Call too complex. Reduce number of parameters.")
    ELSE
      cnt := (high - low + 1) * 4;
      cnt := ((cnt + 15) DIV 16) * 16; (* Must be a multiple of 16 *)
      PutRI("movi", high+1, cnt);
      PutRRR("add", high+1, high+1, SP);
      PutRR("movsp", SP, high+1); 
      INC(frame, cnt);
      i := 0;
      REPEAT
        PutRRI("s32i", low, SP, i*4);
        INC(i); INC(low);
      UNTIL low > high
    END
  END SaveRegs;

  PROCEDURE RestoreRegs(low, high: INTEGER); (* R[low .. high] *)
    VAR 
      cnt, i: INTEGER;
  BEGIN
    eStr(" RestoreRegs {"); eInt(low); eStr(".."); eInt(high); eStr("}");
    cnt := high - low + 1;
    IF cnt > 0 THEN
      i := 0;
      REPEAT
        PutRRI("l32i", low, SP, i*4);
        INC(i); INC(low);
      UNTIL low > high;
      cnt := cnt * 4;
      cnt := ((cnt + 15) DIV 16) * 16; (* Must be a multiple of 16 *)
      PutRI("movi", high+1, cnt);
      PutRRR("sub", high+1, SP, high+1);
      PutRR("movsp", SP, high+1); 
      DEC(frame, cnt)
    END
  END RestoreRegs;

  (* The Esp32 architecture is using a windowing facility that shift
     registers on calls to minimize the need to push registers on the stack.

     The compiler uses 4, 8 or 12 registers shifts to free registers
     for the next call, depending on the number of registers required to
     make de call (parameters) and the registers in use by the caller.

      Kind of   A0 for   First Reg    Max params
      Call      Callee   for params   cnt
      ------    ------   ----------   ----------
      call4       a4         a6           9
      call8       a8        a10           5
      call12     a12        a14           1

    The following algorithm try to optimize the number of registers to save
    on stack if not enough free registers available, combined with the 
    windowing supplied by the architecture.
   *)

  PROCEDURE PrepCall*(VAR x: Item; VAR r: INTEGER): INTEGER;
  VAR
    free : INTEGER;
    callType : INTEGER; (* 4, 8 or 12 *)
  BEGIN (*x.type.form = ORB.Proc*)
    e("PrepCall");
    IF x.mode > ORB.Par THEN load(x) END;
    (* RH := FirstFreeReg();  Not working... for now *)
    r := RH;
    (* Which registers need to be saved *)
    IF RH <= 4 THEN
      callType :=  4;
      free     := 10;
    ELSE
      callType := 8;
      free     := 6;
    END;
    IF (x.type.nofpar > free) & (callType > 4) THEN 
      free     := free + 4; 
      callType := callType - 4 
    END;
    IF x.type.nofpar > free THEN
      ORS.Mark("too many parameters");
    ELSIF RH > callType THEN
      SaveRegs(callType, RH - 1);
    END;
    RH := callType + 2; (* First register to place params *)
    eStr(" calltype:"); eInt(callType); eStr(" RH:"); eInt(RH);
    RETURN callType
  END PrepCall;

  PROCEDURE Call*(VAR x: Item; r, callType: INTEGER);
  VAR
    moduleId: ORS.Ident;
    moduleKey: INTEGER;
  BEGIN (*x.type.form = ORB.Proc*)
    (* ShowItem(x); *)
    e("Call");
    IF x.mode = ORB.Const THEN
      eStr(" (const)");
      IF x.r >= 0 THEN (* local proc *)
        eStr(" local:"); eStr(x.name);
        PutCallLocal(callType, x.name)
      ELSE (* imported *)
        eStr(" imported: "); eStr(x.name); 
        ModuleInfo(x.r, moduleId, moduleKey);  
        eStr(" from:"); eStr(moduleId); eStr(" Key:"); eHex(moduleKey);
        PutCALLExternal(callType, x.name, moduleId, moduleKey)
      END
    ELSE
      IF x.mode <= ORB.Par THEN (* Variable or Parameter *)
        eStr(" (var or par) "); eStr(x.name);
        load(x); decR
      ELSIF x.mode = Reg THEN
        eStr(" (reg) "); eInt(x.r);
      ELSE (* Top of stack *)
        eStr(" (tos)");
        PutRRI("l32i", RH, SP, 0);
        PutRRI("addi", SP, SP, 4);
        x.r := RH;
        DEC(r); 
        (* DEC(frame, 4) *)
      END ;
      IF check THEN 
        Trap(EQ, TrCall); (* Trap if zero *)
        incR 
      END;
      PutCallR(callType, x.r);
    END ;
    IF x.type.base.form = ORB.NoTyp THEN (*procedure*) 
      RH := FirstRH; UsedRegs := {}
    ELSE (*function*)
      (* callType + 3 is the register containing the function result *)
      IF (callType + 3) > r THEN
        PutRR("mov", r, callType + 3);
      END;
      RestoreRegs(callType, r - 1);
      x.mode := Reg; 
      x.r := r; 
      RH  := r + 1
    END
  END Call;

  PROCEDURE Enter*(procid: ORS.Ident; exported: BOOLEAN; parblksize, locblksize: INTEGER; int: BOOLEAN);
    VAR a, r, l: INTEGER;
  BEGIN
    (* interrupt procedures requires to be put in iram to be fast.  To be implemented *)
    e("Enter");
    frame := 0;
    theNextLabel := 1;
    IF ~ProcPresent THEN
      ProcPresent := TRUE;
      (* Put a .text... section head *)
      Texts.WriteString(CodeW, "%T"); Texts.WriteLn(CodeW);
    ELSE
      Texts.WriteLn(CodeW);
      Texts.WriteString(CodeW, "    .align 4"); Texts.WriteLn(CodeW);
    END;
    IF exported THEN
      Texts.Write(      CodeW, CHR(Marker2));
      Texts.WriteString(CodeW, procid);
      Texts.WriteLn(    CodeW);
    END;
    IF int THEN
      Texts.WriteString(CodeW, "    .global ");
      Texts.WriteString(CodeW, "_");
      Texts.WriteString(CodeW, procid);
      Texts.WriteLn(    CodeW);
    END;
    Texts.WriteString(CodeW, "    .type _");
    Texts.WriteString(CodeW, procid);
    Texts.WriteString(CodeW, ", @function");
    Texts.WriteLn(    CodeW);

    Texts.WriteString(CodeW, "_");
    Texts.WriteString(CodeW, procid);
    Texts.WriteString(CodeW, ":");
    Texts.WriteLn(    CodeW);

    (* IF ~int THEN  procedure prolog *)
      IF locblksize >= 10000H THEN ORS.Mark("too many locals") END ;
      IF locblksize = 0 THEN l := 16 ELSE l := (((locblksize + 15) DIV 16) * 16) + 16 END;
      PutRI("entry", SP, l);
      a := 0;
      r := 2;
      WHILE a < parblksize DO
        PutRRI("s32i", r, 1, a); 
        INC(r); 
        INC(a, 4)
      END;
    (* ELSE (* interrupt procedure prolog *)
      (* To be defined *)
    END; *)
    GetLocalSB
  END Enter;

  PROCEDURE Return*(procid: ORS.Ident; type: ORB.Type; VAR x: Item; size: INTEGER; int: BOOLEAN; intLevel: INTEGER);
  BEGIN
    e("Return");
    IF type.base.form # ORB.NoTyp THEN 
      load(x);
      IF type.size = 1 THEN
        PutRI("movi", RH, 255);
        PutRRR("and", x.r, x.r, RH)
      END
    END;
    PutSingle("retw");
    (*
    IF ~int THEN (*procedure epilog*)
      PutSingle("retw");
    ELSE (*interrupt return, restore R2, R1, R0*)
      (*Put2(Ldr, 2, SP, 8); Put2(Ldr, 1, SP, 4); Put2(Ldr, 0, SP, 0); Put1(Add, SP, SP, size);
      Put3(BR, 7, 10H); *)(*RTI*)

      PutRI("rsr", 0, 208 + intLevel);
      PutI("rfi", intLevel);
    END; *)
    Texts.WriteString(CodeW, "    .size _");
    Texts.WriteString(CodeW, procid);
    Texts.WriteString(CodeW, ", .-_");
    Texts.WriteString(CodeW, procid);
    Texts.WriteLn(CodeW);
    RH := FirstRH; UsedRegs := {}
  END Return;

  (* In-line code procedures*)

  PROCEDURE Increment*(upordown: INTEGER; VAR x, y: Item);
    VAR
      loadOp, storeOp: ARRAY 5 OF CHAR; 
      max, zr: INTEGER;
  BEGIN (*frame = 0*)
    e("Increment" );
    IF x.type = ORB.byteType THEN
      eStr(" (byte)"); 
      loadOp := "l8ui"; storeOp := "s8i"; max :=  255
    ELSE
      eStr(" (int)");
      loadOp := "l32i"; storeOp := "s32i"; max := 1020
    END;
    IF y.type.form = ORB.NoTyp THEN y.mode := ORB.Const; y.a := 1 END;

    IF (x.mode = ORB.Var) & (x.r > 0) THEN
      eStr(" (stack var)");
      zr := RH; 
      PutMoveRRI(loadOp, max, zr, SP, x.a);
      incR;
      IF y.mode = ORB.Const THEN 
        eStr(" (const incr) ");
        IF upordown # 0 THEN y.a := - y.a END;
        eInt(y.a);
        IF (y.a >= -128) & (y.a <= 127) THEN
          IF y.a # 0 THEN PutRRI("addi", zr, zr, y.a) END
        ELSE
          PutRI("movi", RH, y.a);
          PutRRR("add", zr, zr, RH)
        END
      ELSE 
        load(y); 
        IF upordown # 0 THEN PutRR("neg", y.r, y.r) END;
        PutRRR("add", zr, zr, y.r); 
        decR 
      END;
      PutMoveRRI(storeOp, max, zr, SP, x.a);
      decR
    ELSE
      eStr(" (var) name:"); eStr(x.name);
      loadAdr(x); 
      zr := RH; 
      PutRRI(loadOp, RH, x.r, 0); 
      incR;
      IF y.mode = ORB.Const THEN 
        IF upordown # 0 THEN y.a := - y.a END;
        IF (y.a >= -128) & (y.a <= 127) THEN
          IF y.a # 0 THEN PutRRI("addi", zr, zr, y.a) END
        ELSE
          PutRI("movi", RH, y.a);
          PutRRR("add", zr, zr, RH)
        END
      ELSE 
        load(y); 
        IF upordown # 0 THEN PutRR("neg", y.r, y.r) END;
        PutRRR("add", zr, zr, y.r); 
        decR 
      END;
      PutRRI(storeOp, zr, x.r, 0); 
      decR; decR
    END
  END Increment;

  PROCEDURE Include*(inorex: INTEGER; VAR x, y: Item);
    VAR zr: INTEGER;
  BEGIN 
    e("Include");
    loadAdr(x); 
    zr := RH; 
    PutRRI("l32i", RH, x.r, 0); incR;
    PutRI("movi", RH, 1);
    IF y.mode = ORB.Const THEN 
      IF y.a # 0 THEN
        PutRRI("slli", RH, RH, y.a)
      END
    ELSE
      incR; 
      load(y); 
      PutR("ssl", y.r); 
      decR; decR;
      PutRR("sll", RH, RH);
    END;
    IF inorex = 0 THEN
      PutRRR("or", zr, zr, RH);
    ELSE
      PutRI("movi", RH+1, -1);
      PutRRR("xor", RH, RH, RH+1);
      PutRRR("and", zr, zr, RH);
    END;
    PutRRI("s32i", zr, x.r, 0); 
    decR; decR
  END Include;

  PROCEDURE Assert*(VAR x: Item);
    VAR cond: INTEGER;
  BEGIN
    e("Assert");
    IF x.mode # Cond THEN loadCond(x) END;
    cond := negated(x.r);
    (* ??
    IF x.a = 0 THEN 
      cond := negated(x.r)
    ELSE
      Put3(BC, x.r, x.b); 
      FixLink(x.a); 
      x.b := pc-1; 
      cond := 7 
    END; *)
    Trap(cond, TrAssert);
  END Assert; 

  PROCEDURE New*(VAR x: Item);
  BEGIN 
    e("New");
    RH := 7;
    loadAdr(x);                 (* a7, a8 := pointer address *)
    loadTypTagAdr(x.type.base); 
    PutRI("movi", 6, 1);        (* a6 := 1 for NEW *)
    
    (* PutA("syscall", "# New");  <-- Not used. Interrupts is a pain *)
    
    PutCallLocal(4, "OberonSyscallHandler");

    (* GetLocalSB; Not needed with call4 *)
    RH := FirstRH; UsedRegs := {}
  END New;

  PROCEDURE Pack*(VAR x, y: Item);
    VAR z: Item;
  BEGIN 
    e("Pack");
    z := x; 
    load(x); 
    load(y);
    PutRRI("slli", y.r, y.r, 23); 
    PutRRR("add", x.r, x.r, y.r); 
    decR; 
    Store(z, x)
  END Pack;

  PROCEDURE Unpk*(VAR x, y: Item);
    VAR z, e0: Item;
  BEGIN  
    e("Unpk");
    z := x; load(x); e0.mode := Reg; e0.r := RH; e0.type := ORB.intType;
    PutRRI("srai", RH, x.r, 23); 
    PutRRI("addi", RH, RH, -127); 
    Store(y, e0); incR;
    PutRRI("slli", RH, RH, 23); 
    PutRRR("sub", x.r, x.r, RH); 
    Store(z, x)
  END Unpk;

  PROCEDURE Led*(VAR x: Item);
  BEGIN (*load(x); Put1(Mov, RH, 0, -60); Put2(Str, x.r, RH, 0); decR*)
    e("Led");
    ORS.Mark("Not implemented")
  END Led;

  PROCEDURE Get*(VAR x, y: Item);
  BEGIN 
    e("Get");
    load(x); x.type := y.type; x.mode := RegI; x.a := 0; Store(y, x)
  END Get;

  PROCEDURE Put*(VAR x, y: Item);
  BEGIN 
    e("Put");
    load(x); x.type := y.type; x.mode := RegI; x.a := 0; Store(x, y)
  END Put;

  PROCEDURE Copy*(VAR x, y, z: Item);
  VAR lbl1, lbl2: INTEGER;
  BEGIN 
    e("Copy");
    load(x); load(y);
    IF z.mode = ORB.Const THEN
      IF z.a > 0 THEN
        load(z) 
      ELSE ORS.Mark("bad count") END
    ELSE 
      load(z);
      IF check THEN 
        Trap(MI, TrCopy); (* array or string copy overflow *)
        incR
      END; 
      lbl1 := NextLabel();
      PutBranchR("beqz", z.r, lbl1);
    END ;
    lbl2 := NextLabel();
    PutBranchR("loop", z.r, lbl2);
      PutRRI("l32i", RH, x.r, 0); 
      PutRRI("addi", x.r, x.r, 4);
      PutRRI("s32i", RH, y.r, 0); 
      PutRRI("addi", y.r, y.r, 4);
    PutLabel(lbl2);
    decR; decR; decR;
    PutLabel(lbl1);
  END Copy;

  PROCEDURE LDPSR*(VAR x: Item);
  BEGIN 
    e("LDPSR");
    (*x.mode = Const*)  
    (* Put3(0, 15, x.a + 20H) *)
    ORS.Mark("LDPSR not implemented")
  END LDPSR;

  PROCEDURE LDREG*(VAR x, y: Item);
  BEGIN
    e("LDREG");
    IF y.mode = ORB.Const THEN 
      PutRI("movi", x.a, y.a);
    ELSE 
      load(y); 
      PutRR("mov", x.a, y.r); 
      decR
    END
  END LDREG;

  PROCEDURE WSR*(VAR x, y: Item);
  BEGIN 
    IF x.mode # ORB.Const THEN ORS.Mark("first parameter must be a constant") END;
    IF (x.a < 0) OR (x.a > 255) THEN ORS.Mark("first parameter must be between 0 and 255") END;
    load(y);
    PutRI("wsr", y.r, x.a);
    decR
  END WSR;

  (*In-line code functions*)

  PROCEDURE RSR*(VAR x: Item);
  BEGIN
    IF x.mode # ORB.Const THEN ORS.Mark("must be a constant") END;
    IF (x.a < 0) OR (x.a > 255) THEN ORS.Mark("param must be between 0 and 255") END;
    PutRI("rsr", RH, x.a);
    x.r := RH;
    x.mode := Reg;
    incR
  END RSR;

PROCEDURE Abs*(VAR x: Item);
  BEGIN
    e("ABS");
    IF x.mode = ORB.Const THEN 
      x.a := ABS(x.a)
    ELSE 
      load(x);
      IF x.type.form = ORB.Real THEN 
        PutRRI("slli", x.r, x.r, 1);
        PutRRI("srli", x.r, x.r, 1);
      ELSE 
        PutRR("abs", x.r, x.r);
      END
    END
  END Abs;

  PROCEDURE Odd*(VAR x: Item);
  BEGIN 
    e("Odd");
    IF x.mode = ORB.Const THEN
      x.a := ORD(ODD(x.a));
      x.type := ORB.boolType;
    ELSE
      load(x);
      PutRI("movi", RH, 1);
      PutRRR("and", x.r, x.r, RH); 
    END
  END Odd;

  PROCEDURE Floor*(VAR x: Item);
  VAR
    xx: REAL;
  BEGIN 
    e("Floor");
    IF x.mode = ORB.Const THEN
      SYS.IntToReal(x.a, xx);
      x.a := FLOOR(xx);
      x.type := ORB.intType
    ELSE
      load(x); 
      PutSR("wfr", 0, x.r);
      PutRSI("floor.s", x.r, 0, 0);
    END
  END Floor;

  PROCEDURE Float*(VAR x: Item);
  BEGIN 
    e("Float");
    IF x.mode = ORB.Const THEN
      SYS.RealToInt(FLT(x.a), x.a);
    ELSE
      load(x); 
      PutSRI("float.s", 0, x.r, 0);
      PutRS("rfr", x.r, 0);
    END
  END Float;

  PROCEDURE Ord*(VAR x: Item);
  BEGIN
    e("Ord");
    IF x.mode IN {ORB.Var, ORB.Par, RegI, Cond} THEN load(x) END
  END Ord;

  PROCEDURE Len*(VAR x: Item);
  BEGIN
    e("Len ");
    IF x.type.len >= 0 THEN
      eStr("regi");
      IF x.mode = RegI THEN decR END ;
      x.mode := ORB.Const; 
      x.a := x.type.len
    ELSE (*open array*) 
      eStr(" (open array) "); eStr("x.a+4:"); eInt(x.a); eStr(" frame:"); eInt(frame);
      PutMoveRRI("l32i", 1020, RH, SP, x.a + 4 + frame); 
      x.mode := Reg; 
      x.r := RH; incR
    END 
  END Len;

  PROCEDURE BitOp*(fct: INTEGER; VAR x, y: Item);
  VAR 
    op: ARRAY 5 OF CHAR;
    xx, yy: SET;
  BEGIN
    e("BitOp");
    IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN
      xx := SYSTEM.VAL(SET, x.a);
      yy := SYSTEM.VAL(SET, y.a);
      IF    fct = 0 THEN xx := xx * yy; (* AND *)
      ELSIF fct = 1 THEN xx := xx + yy; (* BOR *)
      ELSIF fct = 2 THEN xx := xx / yy; (* XOR *)
      END;
      x.a := ORD(xx)
    ELSE
      IF    fct = 0 THEN op := "and" 
      ELSIF fct = 1 THEN op := "or" 
      ELSIF fct = 2 THEN op := "xor"
      END;
      load(x); load(y);
      PutRRR(op, x.r, x.r, y.r);
      decR
    END
  END BitOp;

  PROCEDURE BitNot*(VAR x: Item);
  BEGIN
    IF x.mode = ORB.Const THEN
      x.a := ORD(SYSTEM.VAL(SET, x.a) / {0..31});
    ELSE
      load(x);
      PutRI("movi", RH, -1);
      PutRRR("xor", x.r, x.r, RH);
    END
  END BitNot;

  PROCEDURE MinMax*(fct: INTEGER; VAR x, y: Item);
  VAR op: ARRAY 5 OF CHAR;
  BEGIN 
    IF fct = 0 THEN op := "min" 
    ELSIF fct = 1 THEN op := "max" 
    END;
    load(x); load(y);
    PutRRR(op, x.r, x.r, y.r);
    decR
  END MinMax;

  PROCEDURE Sqrt*(VAR x: Item);
  BEGIN 
    load(x);
    PutSR("wfr", 0, x.r);
    PutRR("mov", RH, 0);
    PutA("call0", "__fsqrt32");
    PutRR("mov", 0, RH);
    PutRS("rfr", x.r, 1);
  END Sqrt;

  PROCEDURE Shift*(fct: INTEGER; VAR x, y: Item);
  BEGIN 
    e("Shift");
    IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN
      IF      fct = 0 THEN x.a := LSL(x.a, y.a)
      ELSIF   fct = 1 THEN x.a := ASR(x.a, y.a)
      ELSE (* fct = 2 *)   x.a := ROR(x.a, y.a) END
    ELSE
      load(x);
      IF fct = 0 THEN  (* LSL *)
        IF y.mode = ORB.Const THEN
          PutRRI("slli", x.r, x.r, y.a MOD 20H)
        ELSE
          load(y);
          PutR("ssl", y.r);
          PutRR("sll", x.r, x.r);
          decR
        END
      ELSIF fct = 1 THEN (* ASR *)
        IF y.mode = ORB.Const THEN
          PutRRI("srai", x.r, x.r, y.a MOD 20H)
        ELSE
          load(y);
          PutR("ssr", y.r);
          PutRR("sra", x.r, x.r);
          decR
        END
      ELSE (* ROR *)
        IF y.mode = ORB.Const THEN
          PutI("ssai", y.a MOD 20H)
        ELSE
          load(y);
          PutR("ssr", y.r);
          decR
        END;
        PutRR("mov", RH, x.r);
        PutRRR("src", x.r, x.r, RH)
      END
    END
  END Shift;

  PROCEDURE ADC*(VAR x, y: Item);
  BEGIN 
    e("ADC");
    (* load(x); load(y); Put0(Add+2000H, x.r, x.r, y.r); decR *)
    ORS.Mark("ADC not implemented")
  END ADC;

  PROCEDURE SBC*(VAR x, y: Item);
  BEGIN 
    e("SBC");
    (* load(x); load(y); Put0(Sub+2000H, x.r, x.r, y.r); decR *)
    ORS.Mark("SBC not implemented")
  END SBC;

  PROCEDURE UML*(VAR x, y: Item);
  BEGIN 
    e("UML");
    (* load(x); load(y); Put0(Mul+2000H, x.r, x.r, y.r); decR *)
    ORS.Mark("UML not implemented")
  END UML;

  PROCEDURE Bit*(VAR x, y: Item);
  BEGIN 
    e("Bit");
    load(x); 
    PutRRI("l32i", x.r, x.r, 0);
    load(y);
    SetCC(x, BST)
  END Bit;

  PROCEDURE Register*(VAR x: Item);
  BEGIN 
    e("Register");
    (*x.mode = Const*)
    (* Put0(Mov, RH, 0, x.a MOD 10H); x.mode := Reg; x.r := RH; incR *)
    ORS.Mark("REG not implemented")
  END Register;

  PROCEDURE H*(VAR x: Item);
  BEGIN 
    e("H");
    (*x.mode = Const*)
    (* Put0(Mov + U + x.a MOD 2 * V, RH, 0, 0); x.mode := Reg; x.r := RH; incR *)
    ORS.Mark("H not implemented")
  END H;

  PROCEDURE Adr*(VAR x: Item);
  BEGIN 
    e("Adr");
    IF x.mode IN {ORB.Var, ORB.Par, RegI} THEN loadAdr(x)
    ELSIF (x.mode = ORB.Const) & (x.type.form = ORB.Proc) THEN load(x)
    ELSIF (x.mode = ORB.Const) & (x.type.form = ORB.String) THEN loadStringAdr(x)
    ELSE ORS.Mark("not addressable")
    END
  END Adr;

  PROCEDURE Condition*(VAR x: Item);
  BEGIN 
    e("Condition");
    (*x.mode = Const*) (* SetCC(x, x.a) *)
    ORS.Mark("COND not implemented")
  END Condition;

  PROCEDURE Header*;
  BEGIN 
    Texts.WriteLn(    CodeW);
    Texts.WriteString(CodeW, "%I");
    Texts.WriteLn(    CodeW);
    Texts.WriteString(CodeW, "_");
    Texts.WriteString(CodeW, thisModuleId);
    Texts.WriteString(CodeW, "_init:");
    Texts.WriteLn(    CodeW);
    PutRI("entry", SP, 16);
    GetLocalSB
  END Header;

  PROCEDURE NofPtrs(typ: ORB.Type): INTEGER;
    VAR fld: ORB.Object; n: INTEGER;
  BEGIN
    IF (typ.form = ORB.Pointer) OR (typ.form = ORB.NilTyp) THEN n := 1
    ELSIF typ.form = ORB.Record THEN
      fld := typ.dsc; n := 0;
      WHILE fld # NIL DO n := NofPtrs(fld.type) + n; fld := fld.next END
    ELSIF typ.form = ORB.Array THEN n := NofPtrs(typ.base) * typ.len
    ELSE n := 0
    END ;
    RETURN n
  END NofPtrs;

  PROCEDURE FindPtrs(typ: ORB.Type; adr: INTEGER);
    VAR fld: ORB.Object; i, s: INTEGER;
  BEGIN
    IF (typ.form = ORB.Pointer) OR (typ.form = ORB.NilTyp) THEN 
      Texts.WriteString(AsW, "    .int _");
      Texts.WriteString(AsW, thisModuleId);
      Texts.WriteString(AsW, "_s_bss + ");
      Texts.WriteInt(   AsW, adr, 0);
      Texts.WriteLn(    AsW);
    ELSIF typ.form = ORB.Record THEN
      fld := typ.dsc;
      WHILE fld # NIL DO FindPtrs(fld.type, fld.val + adr); fld := fld.next END
    ELSIF typ.form = ORB.Array THEN
      s := typ.base.size;
      FOR i := 0 TO typ.len - 1 DO FindPtrs(typ.base, (i * s) + adr) END
    END
  END FindPtrs;

  (* Produce a section header of the following form: 
          .section .<sectionPrefix>_<moduleId>_<key>
          .global _<sectionPrefix>_<moduleId>_s_<key>
      _<sectionPrefix>_<moduleId>_s_<key>:
   *)
  PROCEDURE SectionHeader(sectionPrefix, moduleId: ARRAY OF CHAR;  moduleKey: INTEGER; global: BOOLEAN);
  BEGIN
    Texts.WriteLn(AsW);
    Texts.WriteString(AsW, "    .align 4");
    Texts.WriteLn(AsW);
    Texts.WriteString(AsW, "    .section ");
    SectionName(sectionPrefix, moduleId, moduleKey);
    Texts.WriteLn(AsW);
    IF global THEN
      Texts.WriteString(AsW, "    .global ");
      ExportName(sectionPrefix, "s", moduleId, moduleKey);
      Texts.WriteLn(AsW);
      ExportName(sectionPrefix, "s", moduleId, moduleKey);
      Texts.WriteString(AsW, ":");
      Texts.WriteLn(AsW)
    END
  END SectionHeader;

  PROCEDURE WriteCode(moduleId: ARRAY OF CHAR;  moduleKey: INTEGER) : BOOLEAN;
  VAR
    F:    Files.Rider;
    len:  INTEGER;
    i:    INTEGER;
    name: ARRAY ORS.IdLen OF CHAR;
    b:    BYTE;
    initPresent: BOOLEAN;
  BEGIN
    initPresent := FALSE;
    Files.Set(F, CodeF, 0);
    len := Files.Length(CodeF);
    WHILE len > 0 DO
      Files.Read(F, b); DEC(len);
      IF b = NewLine THEN
        WHILE (b = NewLine) & (len > 0) DO
          Texts.Write(AsW, CHR(NewLine));
          Files.Read(F, b); DEC(len);
        END;
        IF len > 0 THEN
          IF b = Marker1 THEN (* section marker *)
            Files.Read(F, b); DEC(len);
            IF CHR(b) = "I" THEN
              SectionHeader("init", moduleId, moduleKey, FALSE);
              initPresent := TRUE;
            ELSIF CHR(b) = "T" THEN
              SectionHeader("text", moduleId, moduleKey, TRUE);
            END
          ELSIF b = Marker2 THEN (* exported procedure marker *)
            Files.Read(F, b); DEC(len);
            i := 0;
            WHILE (len > 0) & (i < ORS.IdLen) & (b # NewLine) DO
              name[i] := CHR(b);
              Files.Read(F, b); 
              DEC(len);
              INC(i)
            END;
            name[i] := CHR(0);
            Texts.WriteString(AsW, "    .global ");
            ExportName(name, "p", moduleId, moduleKey);
            Texts.WriteLn(AsW);
            Texts.WriteString(AsW, "    .type ");
            ExportName(name, "p", moduleId, moduleKey);
            Texts.WriteString(AsW, ", @function");
            Texts.WriteLn(AsW);
            ExportName(name, "p", moduleId, moduleKey);
            Texts.Write(AsW, ":");
            Texts.WriteLn(AsW);
          ELSE
            Texts.Write(AsW, CHR(b));
          END
        ELSE
          Texts.WriteLn(AsW);
        END;
      ELSE
        Texts.Write(AsW, CHR(b));
      END
    END;
    RETURN initPresent
  END WriteCode;

  PROCEDURE TypePointer(a: INTEGER);
  VAR 
    base: INTEGER;
    offset: INTEGER;
    moduleId: ORS.Ident;
    moduleKey: INTEGER;
    name: ARRAY 256 OF CHAR;
  BEGIN
    base := a DIV 1000H;
    offset := a MOD 1000H;
    IF base = 0 THEN
      name := "_"; AppendStr(name, thisModuleId); AppendStr(name, "_s_types");
    ELSE
      ModuleInfo(base, moduleId, moduleKey);
      name := "_"; AppendStr(name, moduleId); AppendStr(name, "_");
      AppendHex(name, moduleKey);
      AppendStr(name, "_s_data_types");
    END;
    Texts.WriteString(AsW, name);
    Texts.WriteString(AsW, "+");
    Texts.WriteInt(AsW, offset, 0)
  END TypePointer;

  PROCEDURE Close*(VAR moduleId: ORS.Ident; moduleKey, nofent: INTEGER; outputFolder: ARRAY OF CHAR);
    VAR 
      obj: ORB.Object;
      i, nofptrs: INTEGER;
      name: ORS.Ident;
      initPresent: BOOLEAN;
  BEGIN  (* exit code *)

    ORB.MakeFileName(name, outputFolder, moduleId, ".S"); (* write code file *)
    AsF := Files.New(name);
    
    Texts.OpenWriterToFile(AsW, AsF);

    Texts.WriteString(AsW, "    .title ");
    Texts.Write(      AsW, 22X);
    Texts.WriteString(AsW, "Module ");
    Texts.WriteString(AsW, moduleId); 
    Texts.WriteString(AsW, ", Key");
    Texts.WriteHex(   AsW, moduleKey); 
    Texts.Write(      AsW, 22X);
    Texts.WriteLn(    AsW);

    Texts.WriteString(AsW, "    .sbttl ");
    Texts.Write(      AsW, 22X);
    Texts.WriteString(AsW, "Oberon ESP32 Compiler Version ");
    Texts.WriteString(AsW, ORB.CompilerVersion);
    Texts.Write(      AsW, 22X);
    Texts.WriteLn(    AsW);
    
    initPresent := FALSE;

    (* types description section *)
    IF tdx > 0 THEN
      SectionHeader("data_types", moduleId, moduleKey, TRUE);
      Texts.WriteString(AsW, "_");
      Texts.WriteString(AsW, moduleId);
      Texts.WriteString(AsW, "_s_types:");
      Texts.WriteLn(AsW);
      FOR i := 0 TO tdx-1 DO 
        Texts.WriteString(AsW, "    .int ");
        (* Type size for allocation *)
        IF (i MOD 5) = 0 THEN
          Texts.WriteInt(AsW, data[i], 0);
        ELSIF data[i] = -1 THEN
          Texts.WriteString(AsW, "-1");
        ELSE
          TypePointer(data[i])
        END;
        Texts.WriteLn(AsW);
      END;    
    END;

    (* Strings section *)
    IF strx > 0 THEN
      SectionHeader("data_strs", moduleId, moduleKey, FALSE);
      Texts.WriteString(AsW, "_");
      Texts.WriteString(AsW, moduleId);
      Texts.WriteString(AsW, "_data_strs:");
      FOR i := 0 TO strx-1 DO 
        IF (i MOD 16) = 0 THEN
          Texts.WriteLn(AsW);
          Texts.WriteString(AsW, "    .byte ");
        END;
        Texts.WriteInt(AsW, ORD(str[i]), 0);
        IF (i < strx-1) & (((i+1) MOD 16) # 0) THEN Texts.Write(AsW, ",") END
      END;    
      Texts.WriteLn(AsW);
    END;

    (* variables section *)
    SectionHeader("bss", moduleId, moduleKey, TRUE);
    Texts.WriteString(AsW, "_");
    Texts.WriteString(AsW, moduleId);
    Texts.WriteString(AsW, "_s_bss:");
    Texts.WriteLn(    AsW);
    Texts.WriteString(AsW, "    .space ");
    IF varsize > 0 THEN
      Texts.WriteInt(   AsW, varsize, 0);
    ELSE
      Texts.WriteInt(   AsW, 4, 0);
    END;
    Texts.WriteLn(    AsW);

    (* pointers section *)
    obj := ORB.topScope.next; nofptrs := 0;
    WHILE obj # NIL DO
      IF obj.class = ORB.Var THEN INC(nofptrs, NofPtrs(obj.type)) END ;
      obj := obj.next
    END ;

    IF nofptrs > 0 THEN
      SectionHeader("pointers_table", moduleId, moduleKey, FALSE);
      obj := ORB.topScope.next;
      WHILE obj # NIL DO
        IF obj.class = ORB.Var THEN FindPtrs(obj.type, obj.val) END ;
        obj := obj.next
      END;
    END;

    (* Procedures Code section *)
    IF CodeW.buf.len > 0 THEN
      initPresent := WriteCode(moduleId, moduleKey);
      IF initPresent THEN
        Texts.WriteString(AsW, "    retw");
        Texts.WriteLn(AsW);
        Texts.WriteString(AsW, "    .size _");
        Texts.WriteString(AsW, moduleId);
        Texts.WriteString(AsW, "_init, .-_");
        Texts.WriteString(AsW, moduleId);
        Texts.WriteString(AsW, "_init");
        Texts.WriteLn(AsW);
      END
    END;

    (* Initialization Code Table *)
    IF initPresent THEN
      Texts.WriteLn(AsW);
      SectionHeader("init_table", moduleId, moduleKey, FALSE);
      Texts.WriteString(AsW, "    .int ");
      Texts.WriteString(AsW, "_");
      Texts.WriteString(AsW, moduleId);
      Texts.WriteString(AsW, "_init");
      Texts.WriteLn(AsW);
    END;

    Texts.WriteLn(AsW);
    Files.Register(AsF) 
  END Close;

  PROCEDURE Open*(modid: ORS.Ident; generateCheckCode: BOOLEAN);
  BEGIN 
    thisModuleId := modid;

    check   := generateCheckCode;

    tdx     := 0; 
    strx    := 0;
    varsize := 0; 
    RH      := FirstRH; 
    theNextLabel := 1;

    CodeF := Files.New("");
    Texts.OpenWriterToFile(CodeW, CodeF);
    Texts.WriteLn(CodeW);

    ProcPresent := FALSE;

  END Open;

  PROCEDURE SetDataSize*(dc: INTEGER);
  BEGIN varsize := dc
  END SetDataSize;

BEGIN 
  relmap[0] := EQU; (* = *)
  relmap[1] := NEQ; (* # *)
  relmap[2] := LT;  (* < *)
  relmap[3] := LE;  (* <= *)
  relmap[4] := GT;  (* > *)
  relmap[5] := GE;  (* >= *)

(*  Constants declared at the beginning of the module:

    MI  = 0; PL  =  8;  (* Minus / Plus                        2 args *)
    EQ  = 1; NE  =  9;  (* Zero / Not zero                     1 arg  *)
    BST = 2; BCL = 10;  (* Bit Set / Bit CLear                 2 args *)
    EQU = 3; NEQ = 11;  (* Equal  / Not equal                  2 args *)
    LT  = 5; GE  = 13;  (* Lower than / Greater or equal       2 args *)
    LE  = 6; GT  = 14;  (* Lower or equal / Greater than       2 args *)
    TR  = 7; FL  = 15;  (* TRUE / FALSE  constant              1 args *)
*)

  BrOp[ 0] := "bltz";  BrOp[ 8] := "bgez";  
  BrOp[ 1] := "beqz";  BrOp[ 9] := "bnez";  
  BrOp[ 2] := "bbs";   BrOp[10] := "bbc";   
  BrOp[ 3] := "beq";   BrOp[11] := "bne";   
  BrOp[ 4] := "j";     BrOp[12] := "j";      
  BrOp[ 5] := "blt";   BrOp[13] := "bge";   
  BrOp[ 6] := "bge";   BrOp[14] := "blt";   
  BrOp[ 7] := "bnez";  BrOp[15] := "beqz";  

  BrReverse  := {6, 14};
  BrOneParam := {0, 1, 7, 8, 9, 15};
  BrTwoParam := {2, 3, 5, 6, 10, 11, 13, 14};
  BrNoParam  := {4, 12};

  UsedRegs := {}
END ORG.
