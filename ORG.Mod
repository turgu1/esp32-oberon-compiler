MODULE ORG; (* N.Wirth, 16.4.2016 / 4.4.2017 / 31.5.2019  Oberon compiler; code generator for RISC*)
  IMPORT SYSTEM, Files, Texts, ORS, ORB, Out;
  (*Code generator for Oberon compiler for RISC processor.
     Procedural interface to Parser OSAP; result in array "code".
     Procedure Close writes code-files*)

  CONST 
    WordSize* = 4;
    StkOrg0 = -64; VarOrg0 = 0;  (*for RISC-0 only*)
    MT = 12; SP = 1; LNK = 0;   (*dedicated registers*)
    maxCode = 8000; maxStrx = 2400; maxTD = 160; C24 = 1000000H;
    Reg = 10; RegI = 11; Cond = 12;  (*internal item modes*)

    FirstRH = 2;   (* First available register for arguments *)
    LastRH  = 15;  (* Last availeble register *)

  (*frequently used opcodes*)  U = 2000H; V = 1000H;
    Mov = 0; Lsl = 1; Asr = 2; Ror= 3; And = 4; Ann = 5; Ior = 6; Xor = 7;
    Add = 8; Sub = 9; Cmp = 9; Mul = 10; Div = 11;
    Fad = 12; Fsb = 13; Fml = 14; Fdv = 15;
    Ldr = 8; Str = 10;
    BR = 0; BLR = 1; BC = 2; BL = 3;
    MI = 0; PL = 8; EQ = 1; NE = 9; LT = 5; GE = 13; LE = 6; GT = 14;

    Marker1 = 025H; (* % *)
    Marker2 = 024H; (* $ *)
    NewLine = 0AH;

  TYPE 
    (* 
    Item forms and meaning of fields:
      mode     r      a       b
      --------------------------------
      Const   -     value (proc adr)    (immediate value)
      Var     base   off     -               (direct adr)
      Par      -     off0   off1           (indirect adr)
      Reg    regno
      RegI   regno   off     -
      Cond   cond   Fchain Tchain

      Fchain: False Chain
      Tchain: True Chain  
    *)

    Item* = RECORD
      mode*: INTEGER;
      type*: ORB.Type;
      a*, 
      b*, 
      r:     INTEGER;
      name: ORS.Ident;
      rdo*:  BOOLEAN  (*read only*)
    END ;

  VAR 
    pc*, varsize,            (*program counter, data index*)
    tdx, strx,
    entry,                   (*main entry point*)
    RH,                      (*available registers R[FirstRH] ... R[LastRH]*)
    frame,                   (*frame offset changed in SaveRegs and RestoreRegs*)
    fixorgP, 
    fixorgD, 
    version,                 (* 0 = RISC-0, 1 = RISC-5 *)
    fixorgT: INTEGER;        (*origins of lists of locations to be fixed up by loader*)
    check:   BOOLEAN;        (*emit run-time checks*)
    
    relmap: ARRAY 6       OF INTEGER;  (*condition codes for relations*)
    code:   ARRAY maxCode OF INTEGER;
    data:   ARRAY maxTD   OF INTEGER;  (*type descriptors*)
    str:    ARRAY maxStrx OF CHAR;

    (* The end result of the compiler is an assembler file ready to be digested by the GNU Assembler *)
    AsF: Files.File;     (* Output file for the Assembly Language *)
    AsW: Texts.Writer;   (* Writer for the Assembly Language File *)

    (* The Code File is receiving the ESP32 instructions in assembler language. It will be
       merged with the rest of the required information ino the AsF file at the end of the
       compilation process *)
    CodeF: Files.File;   (* Code file *)
    CodeW: Texts.Writer; (* Machine code output for Procedures *)

    ProcPresent: BOOLEAN; (* There is at least one Procedure present *)

    thisModuleId: ORS.Ident;

  (*instruction assemblers according to formats*)

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

  PROCEDURE Put0(op, a, b, c: INTEGER);
  BEGIN (*emit format-0 instruction*)
    code[pc] := ((a*10H + b) * 10H + op) * 10000H + c; INC(pc)
  END Put0;

  PROCEDURE Put1(op, a, b, im: INTEGER);
  BEGIN (*emit format-1 instruction,  -10000H <= im < 10000H*)
    IF im < 0 THEN INC(op, V) END ;
    code[pc] := (((a+40H) * 10H + b) * 10H + op) * 10000H + (im MOD 10000H); INC(pc)
  END Put1;

  PROCEDURE Put1a(op, a, b, im: INTEGER);
  BEGIN (*same as Put1, but with range test  -10000H <= im < 10000H*)
    IF (im >= -10000H) & (im <= 0FFFFH) THEN Put1(op, a, b, im)
    ELSE Put1(Mov+U, RH, 0, im DIV 10000H);
      IF im MOD 10000H # 0 THEN Put1(Ior, RH, RH, im MOD 10000H) END ;
      Put0(op, a, b, RH)
    END
  END Put1a;

  PROCEDURE Put2(op, a, b, off: INTEGER);
  BEGIN (*emit load/store instruction*)
    code[pc] := ((op * 10H + a) * 10H + b) * 100000H + (off MOD 100000H); INC(pc)
  END Put2;

  PROCEDURE Put3(op, cond, off: INTEGER);
  BEGIN (*emit branch instruction*)
    code[pc] := ((op+12) * 10H + cond) * 1000000H + (off MOD 1000000H); INC(pc)
  END Put3;

  PROCEDURE ModuleInfo(idx: INTEGER; VAR moduleId: ORS.Ident; VAR moduleKey: INTEGER);
  VAR
    obj: ORB.Object;
  BEGIN
    moduleId := "Unknown";
    moduleKey := 0;
    obj := ORB.topScope.next;
    WHILE (idx # 0) & (obj # NIL) & (obj.class = ORB.Mod) DO  (*imports*)
      IF obj.dsc # ORB.system THEN
        INC(idx);
        IF idx = 0 THEN 
          moduleId := obj(ORB.Module).orgname;
          moduleKey  := obj.val;
        END
      END;
      obj := obj.next
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
  
  PROCEDURE PutA(op, a: ARRAY OF CHAR);
  BEGIN 
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " ");
    Texts.WriteString(CodeW, a);
    Texts.WriteLn(    CodeW);
  END PutA;

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
    Texts.WriteString(CodeW, " ");
    Texts.WriteInt(   CodeW, v, 0);
    Texts.WriteLn(    CodeW);
  END PutI;

  PROCEDURE PutSingle(op: ARRAY OF CHAR);
  BEGIN 
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteLn(CodeW);
  END PutSingle;

  PROCEDURE ImportName(name, kind, moduleId: ARRAY OF CHAR;  moduleKey: INTEGER);
  BEGIN
    Texts.WriteString(CodeW, "_");
    Texts.WriteString(CodeW, moduleId);
    Texts.WriteString(CodeW, "_");
    WriteHex(CodeW, moduleKey);
    Texts.WriteString(CodeW, "_");
    Texts.WriteString(CodeW, kind);
    Texts.WriteString(CodeW, "_");
    Texts.WriteString(CodeW, name);
  END ImportName;

  PROCEDURE PutDataExternal(op: ARRAY OF CHAR; r : INTEGER; name, moduleId: ORS.Ident; moduleKey: INTEGER);
  BEGIN
    Texts.WriteString(CodeW, "    ");
    Texts.WriteString(CodeW, op);
    Texts.WriteString(CodeW, " a");
    Texts.WriteInt(   CodeW, r, 0);
    Texts.WriteString(CodeW, ", ");
    ImportName(name, "p", moduleId, moduleKey);
    Texts.WriteLn(CodeW)
  END PutDataExternal;

  PROCEDURE PutCallR(callType: INTEGER; r: INTEGER);
  BEGIN 
    Texts.WriteString(CodeW, "    call");
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
  BEGIN
    Texts.WriteString(CodeW, "    call");
    Texts.WriteInt(CodeW, callType, 0);
    Texts.WriteString(CodeW, " ");
    ImportName(name, "p", moduleId, moduleKey);
    Texts.WriteLn(CodeW)
  END PutCALLExternal;

  PROCEDURE incR;
  BEGIN
    IF RH < LastRH-1 THEN INC(RH) ELSE ORS.Mark("register stack overflow") END
  END incR;

  PROCEDURE CheckRegs*;
  BEGIN
    IF RH # FirstRH THEN 
      Out.String("RH = ");
      Out.Int(RH, 0);
      Out.Ln();
      ORS.Mark("Reg Stack"); 
      RH := FirstRH 
    END ;
    (* IF pc >= maxCode - 40 THEN ORS.Mark("program too long") END ; *)
    IF frame # 0 THEN 
      Out.String("Frame = ");
      Out.Int(frame, 0);
      Out.Ln();
      ORS.Mark("frame error"); 
      frame := 0
    END
  END CheckRegs;

    (* Produce a unique sectin name of the following form:
       <sectionPrefix>_<moduleId>_<key>
   *)

  PROCEDURE ExportName(name, kind, moduleId: ARRAY OF CHAR;  moduleKey: INTEGER);
  BEGIN
    Texts.WriteString(AsW, "_");
    Texts.WriteString(AsW, moduleId);
    Texts.WriteString(AsW, "_");
    WriteHex(AsW, moduleKey);
    Texts.WriteString(AsW, "_");
    Texts.WriteString(AsW, kind);
    Texts.WriteString(AsW, "_");
    Texts.WriteString(AsW, name);
  END ExportName;

  PROCEDURE SectionName(sectionPrefix, moduleId: ARRAY OF CHAR;  moduleKey: INTEGER);
  BEGIN
    Texts.WriteString(AsW, ".");
    Texts.WriteString(AsW, sectionPrefix);
    Texts.WriteString(AsW, "_");
    Texts.WriteString(AsW, moduleId);
    Texts.WriteString(AsW, "_");
    WriteHex(AsW, moduleKey);
  END SectionName;

  PROCEDURE SetCC(VAR x: Item; n: INTEGER);
  BEGIN x.mode := Cond; x.a := 0; x.b := 0; x.r := n
  END SetCC;

  PROCEDURE Trap(cond, num: INTEGER);
  BEGIN Put3(BLR, cond, ORS.Pos()*100H + num*10H + MT)
  END Trap;

  (*handling of forward reference, fixups of branch addresses and constant tables*)

  PROCEDURE negated(cond: INTEGER): INTEGER;
  BEGIN
    IF cond < 8 THEN cond := cond+8 ELSE cond := cond-8 END ;
    RETURN cond
  END negated;

  PROCEDURE fix(at, with: INTEGER);
  BEGIN code[at] := code[at] DIV C24 * C24 + (with MOD C24)
  END fix;

  PROCEDURE FixOne*(at: INTEGER);
  BEGIN fix(at, pc-at-1)
  END FixOne;

  PROCEDURE FixLink*(L: INTEGER);
    VAR L1: INTEGER;
  BEGIN
    WHILE L # 0 DO L1 := code[L] MOD 40000H; fix(L, pc-L-1); L := L1 END
  END FixLink;

  PROCEDURE FixLinkWith(L0, dst: INTEGER);
    VAR L1: INTEGER;
  BEGIN
    WHILE L0 # 0 DO
      L1 := code[L0] MOD C24;
      code[L0] := code[L0] DIV C24 * C24 + ((dst - L0 - 1) MOD C24); L0 := L1
    END
  END FixLinkWith;

  PROCEDURE merged(L0, L1: INTEGER): INTEGER;
    VAR L2, L3: INTEGER;
  BEGIN 
    IF L0 # 0 THEN L3 := L0;
      REPEAT L2 := L3; L3 := code[L2] MOD 40000H UNTIL L3 = 0;
      code[L2] := code[L2] + L1; L1 := L0
    END ;
    RETURN L1
  END merged;

  (* loading of operands and addresses into registers *)

  PROCEDURE GetSB(base: INTEGER);
  VAR
    moduleId: ORS.Ident;
    moduleKey: INTEGER;
  BEGIN
    Texts.WriteString(CodeW, "    movi a");
    Texts.WriteInt(CodeW, RH, 0);
    IF base = 0 THEN
      Texts.WriteString(CodeW, ", _");
      Texts.WriteString(CodeW, thisModuleId);
    ELSE
      ModuleInfo(base, moduleId, moduleKey);
      Texts.WriteString(CodeW, ", _");
      Texts.WriteString(CodeW, moduleId);
      Texts.WriteString(CodeW, "_");
      WriteHex(CodeW, moduleKey);
    END;
    Texts.WriteString(CodeW, "_s_bss");
    Texts.WriteLn(CodeW);
  END GetSB;

  PROCEDURE NilCheck;
  BEGIN IF check THEN Trap(EQ, 4) END
  END NilCheck;

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
    IF (offset > max) OR (offset < 0) THEN
      IF (r1 = RH) OR (r2 = RH) THEN temp := RH+1 ELSE temp := RH END;
      IF (offset < 0) OR (offset > 32767) THEN
        PutRI("movi", temp, offset);
        PutRRR("add", temp, temp, r2);
        PutRRI(op, r1, temp, 0)
      ELSE
        PutRRI("addmi", temp, r2, offset);
        PutRRI(op, r1, temp, offset MOD 256);
      END
    ELSE
      PutRRI(op, r1, r2, offset)
    END
  END PutMoveRRI;

  PROCEDURE load(VAR x: Item);
    VAR 
      op: ARRAY 5 OF CHAR;
      max, moduleKey: INTEGER;
      moduleId: ORS.Ident;
  BEGIN
    IF x.type.size = 1 THEN 
      op := "l8i"; max := 255 
    ELSE 
      op := "l32i"; max := 1020 
    END;
    IF x.mode # Reg THEN (* if not already in a register *)
      IF x.mode = ORB.Const THEN (* Constant *)
        IF x.type.form = ORB.Proc THEN
          IF x.r > 0 THEN 
            ORS.Mark("not allowed")
          ELSIF x.r = 0 THEN (* to be done *)
            Put3(BL, 7, 0); 
            Put1a(Sub, RH, LNK, pc*4 - x.a)
          ELSE 
            (* GetSB(x.r); *) 
            ModuleInfo(x.r, moduleId, moduleKey);
            PutDataExternal("movi", RH, x.name, moduleId, moduleKey);
          END
        ELSE
          PutRI("movi", RH, x.a);
        END ;
        x.r := RH; incR
      ELSIF x.mode = ORB.Var THEN
        IF x.r > 0 THEN (* local on the stack *) 
          PutMoveRRI(op, max, RH, SP, x.a + frame);
        ELSE  (* module globals or imported *)
          GetSB(x.r); 
          PutMoveRRI(op, max, RH, RH, x.a);
        END;
        x.r := RH; incR
      ELSIF x.mode = ORB.Par THEN 
        PutMoveRRI("l32i", 1020, RH, SP, x.a + frame);
        PutMoveRRI(op, max, RH, RH, x.b);
        x.r := RH; incR
      ELSIF x.mode = RegI THEN
        PutMoveRRI(op, max, x.r, x.r, x.a);
      ELSIF x.mode = Cond THEN
        Put3(BC, negated(x.r), 2);
        FixLink(x.b); Put1(Mov, RH, 0, 1); Put3(BC, 7, 1);
        FixLink(x.a); Put1(Mov, RH, 0, 0); x.r := RH; incR
      END;
      x.mode := Reg
    END
  END load;

  PROCEDURE loadAdr(VAR x: Item);
  VAR
    offset : INTEGER;
  BEGIN
    IF x.mode = ORB.Var THEN
      IF x.r > 0 THEN (*local*)
        offset := x.a + frame;
        IF offset > 127 THEN
          PutRI("movi", RH, offset);
          PutRRR("add", RH, RH, SP);
        ELSE
          PutRRI("addi", RH, SP, offset);
        END
      ELSE 
        GetSB(x.r); 
        IF x.a > 127 THEN
          PutRI("movi", RH+1, x.a);
          PutRRR("add", RH, RH, RH+1);
        ELSE
          PutRRI("addi", RH, RH, x.a);
        END
      END ;
      x.r := RH; incR
    ELSIF x.mode = ORB.Par THEN 
      PutMoveRRI("l32i", 1020, RH, SP, x.a + frame);
      IF x.b # 0 THEN 
        IF x.b > 127 THEN
          PutRI("movi", RH+1, x.b);
          PutRRR("add", RH, RH, RH+1);
        ELSE
          PutRRI("addi", RH, RH, x.b);
        END
      END;
      x.r := RH; incR
    ELSIF x.mode = RegI THEN
      IF x.a # 0 THEN
        IF x.a > 127 THEN
          PutRI("movi", RH, x.a);
          PutRRR("add", x.r, x.r, RH);
        ELSE
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
    IF x.type.form = ORB.Bool THEN
      IF x.mode = ORB.Const THEN x.r := 15 - x.a*8
      ELSE load(x);
        IF code[pc-1] DIV 40000000H # -2 THEN Put1(Cmp, x.r, x.r, 0) END ;
        x.r := NE; DEC(RH)
      END ;
      x.mode := Cond; x.a := 0; x.b := 0
    ELSE ORS.Mark("not Boolean?")
    END
  END loadCond;

  PROCEDURE loadTypTagAdr(T: ORB.Type);
    VAR x: Item;
  BEGIN x.mode := ORB.Var; x.a := T.len; x.r := -T.mno; loadAdr(x)
  END loadTypTagAdr;

  PROCEDURE loadStringAdr(VAR x: Item);
  BEGIN GetSB(0); Put1a(Add, RH, RH, varsize+x.a); x.mode := Reg; x.r := RH; incR
  END loadStringAdr;

  (* Items: Conversion from constants or from Objects on the Heap to Items on the Stack*)

  PROCEDURE MakeConstItem*(VAR x: Item; typ: ORB.Type; val: INTEGER);
  BEGIN x.mode := ORB.Const; x.type := typ; x.a := val
  END MakeConstItem;

  PROCEDURE MakeRealItem*(VAR x: Item; val: REAL);
  BEGIN x.mode := ORB.Const; x.type := ORB.realType; x.a := SYSTEM.VAL(INTEGER, val)
  END MakeRealItem;

  PROCEDURE MakeStringItem*(VAR x: Item; len: INTEGER); (*copies string from ORS-buffer to ORG-string array*)
    VAR i: INTEGER;
  BEGIN x.mode := ORB.Const; x.type := ORB.strType; x.a := strx; x.b := len; i := 0;
    IF strx + len + 4 < maxStrx THEN
      WHILE len > 0 DO str[strx] := ORS.str[i]; INC(strx); INC(i); DEC(len) END ;
      WHILE strx MOD 4 # 0 DO str[strx] := 0X; INC(strx) END
    ELSE ORS.Mark("too many strings")
    END
  END MakeStringItem;

  PROCEDURE MakeItem*(VAR x: Item; y: ORB.Object; curlev: INTEGER);
  BEGIN 
    (*
    Out.String("MakeItem, Object:"); Out.Ln;
    ShowObject(y, 4);
    *)
    x.mode := y.class; 
    x.type := y.type; 
    x.a    := y.val; 
    x.rdo  := y.rdo;
    IF y.class = ORB.Par THEN
      x.b := 0
    ELSIF (y.class = ORB.Const) & (y.type.form = ORB.String) THEN
      x.b := y.lev  (*len*) ;
    ELSE
      x.r := y.lev
    END ;
    IF (y.lev > 0) & (y.lev # curlev) & (y.class # ORB.Const) THEN 
      ORS.Mark("not accessible ")
    END;
    x.name := y.name
  END MakeItem;

  (* Code generation for Selectors, Variables, Constants *)

  PROCEDURE Field*(VAR x: Item; y: ORB.Object);   (* x := x.y *)
  BEGIN;
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
          Put1a(Cmp, RH, y.r, limit)
        ELSE (*open array*)
          IF x.mode IN {ORB.Var, ORB.Par} THEN
            Put2(Ldr, RH, SP, x.a + 4 + frame); 
            Put0(Cmp, RH, y.r, RH)
          ELSE 
            ORS.Mark("error in Index")
          END
        END;
        Trap(10, 1)  (*BCC*)
      END;
      IF size = 4 THEN 
        PutRRI("slli", y.r, y.r, 2)
      ELSIF size > 1 THEN 
        PutRI("movi", RH, size);
        PutRRR("mull", y.r, y.r, RH) 
      END;
      IF x.mode = ORB.Var THEN
        IF x.r > 0 THEN 
          PutRRR("add", y.r, SP, y.r); 
          INC(x.a, frame)
        ELSE 
          GetSB(x.r);
          IF x.r = 0 THEN 
            PutRRR("add", y.r, RH, y.r)
          ELSE 
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
        DEC(RH)
      END
    END
  END Index;

  PROCEDURE DeRef*(VAR x: Item);
  BEGIN
    IF x.mode = ORB.Var THEN
      IF x.r > 0 THEN (*local*) Put2(Ldr, RH, SP, x.a + frame) ELSE GetSB(x.r); Put2(Ldr, RH, RH, x.a) END ;
      NilCheck; x.r := RH; incR
    ELSIF x.mode = ORB.Par THEN
      Put2(Ldr, RH, SP, x.a + frame); Put2(Ldr, RH, RH, x.b); NilCheck; x.r := RH; incR
    ELSIF x.mode = RegI THEN Put2(Ldr, x.r, x.r, x.a); NilCheck
    ELSIF x.mode # Reg THEN ORS.Mark("bad mode in DeRef")
    END ;
    x.mode := RegI; x.a := 0; x.b := 0
  END DeRef;

  PROCEDURE Q(T: ORB.Type; VAR dcw: INTEGER);
  BEGIN (*one entry of type descriptor extension table*)
    IF T.base # NIL THEN
      Q(T.base, dcw); data[dcw] := (T.mno*1000H + T.len) * 1000H + dcw - fixorgT;
      fixorgT := dcw; INC(dcw)
    END
  END Q;

  PROCEDURE FindPtrFlds(typ: ORB.Type; off: INTEGER; VAR dcw: INTEGER);
    VAR fld: ORB.Object; i, s: INTEGER;
  BEGIN
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
    T.len := dc; (*len used as address*)
    data[dcw] := s; 
    INC(dcw);  
    k := T.nofpar;   (*extension level!*)
    IF k > 3 THEN 
      ORS.Mark("ext level too large")
    ELSE 
      Q(T, dcw);
      WHILE k < 3 DO 
        data[dcw] := -1; 
        INC(dcw); 
        INC(k) 
      END
    END ;
    FindPtrFlds(T, 0, dcw); 
    data[dcw] := -1; 
    INC(dcw); 
    tdx := dcw; 
    dc := dcw*4;
    IF tdx >= maxTD THEN 
      ORS.Mark("too many record types"); 
      tdx := 0 
    END
  END BuildTD;

  PROCEDURE TypeTest*(VAR x: Item; T: ORB.Type; varpar, isguard: BOOLEAN);
    VAR pc0: INTEGER;
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
  END TypeTest;

  (* Code generation for Boolean operators *)

  PROCEDURE Not*(VAR x: Item);   (* x := ~x *)
    VAR t: INTEGER;
  BEGIN
    IF x.mode # Cond THEN loadCond(x) END ;
    x.r := negated(x.r); t := x.a; x.a := x.b; x.b := t
  END Not;

  PROCEDURE And1*(VAR x: Item);   (* x := x & *)
  BEGIN
    IF x.mode # Cond THEN loadCond(x) END ;
    Put3(BC, negated(x.r), x.a); x.a := pc-1; FixLink(x.b); x.b := 0
  END And1;

  PROCEDURE And2*(VAR x, y: Item);
  BEGIN
    IF y.mode # Cond THEN loadCond(y) END ;
    x.a := merged(y.a, x.a); x.b := y.b; x.r := y.r
  END And2;

  PROCEDURE Or1*(VAR x: Item);   (* x := x OR *)
  BEGIN
    IF x.mode # Cond THEN loadCond(x) END ;
    Put3(BC, x.r, x.b);  x.b := pc-1; FixLink(x.a); x.a := 0
  END Or1;

  PROCEDURE Or2*(VAR x, y: Item);
  BEGIN
    IF y.mode # Cond THEN loadCond(y) END ;
    x.a := y.a; x.b := merged(y.b, x.b); x.r := y.r
  END Or2;

  (* Code generation for arithmetic operators *)

  PROCEDURE Neg*(VAR x: Item);   (* x := -x *)
  BEGIN
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
        PutSR("wfr", 0, x.r);
        PutSS("neg.s", 0, 0);
        PutRS("rfr", x.r, 0);
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
    IF op = ORS.plus THEN
      IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN
        x.a := x.a + y.a
      ELSIF y.mode = ORB.Const THEN load(x);
        IF y.a # 0 THEN 
          PutRI("movi", RH, y.a);
          PutRRR("add", x.r, x.r, RH) 
        END
      ELSE 
        load(x); load(y); 
        PutRRR("add", RH-2, x.r, y.r); 
        DEC(RH); 
        x.r := RH-1
      END
    ELSE (*op = ORS.minus*)
      IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN 
        x.a := x.a - y.a
      ELSIF y.mode = ORB.Const THEN 
        load(x);
        IF y.a # 0 THEN 
          PutRI("movi", RH, y.a);
          PutRRR("sub", x.r, x.r, RH) 
        END
      ELSE 
        load(x); load(y); 
        PutRRR("sub", RH-2, x.r, y.r); 
        DEC(RH); 
        x.r := RH-1
      END
    END
  END AddOp;

  PROCEDURE log2(m: INTEGER; VAR e: INTEGER): INTEGER;
  BEGIN e := 0;
    WHILE ~ODD(m) DO m := m DIV 2; INC(e) END ;
    RETURN m
  END log2;
  
  PROCEDURE MulOp*(VAR x, y: Item);   (* x := x * y *)
    VAR e: INTEGER;
  BEGIN
    IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN x.a := x.a * y.a
    ELSIF (y.mode = ORB.Const) & (y.a >= 2) & (log2(y.a, e) = 1) THEN 
      load(x);
      PutRRI("slli", x.r, x.r, e)
    ELSIF y.mode = ORB.Const THEN 
      load(x); 
      PutRI("movi", RH, y.a);
      PutRRR("mull", x.r, x.r, RH)
    ELSIF (x.mode = ORB.Const) & (x.a >= 2) & (log2(x.a, e) = 1) THEN 
      load(y); 
      PutRRI("slli", y.r, y.r, e);
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
      DEC(RH); 
      x.r := RH-1
    END
  END MulOp;

  PROCEDURE DivOp*(op: INTEGER; VAR x, y: Item);   (* x := x op y *)
    VAR e: INTEGER;
  BEGIN
    IF op = ORS.div THEN
      IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN
        IF y.a > 0 THEN
          x.a := x.a DIV y.a 
        ELSE 
          ORS.Mark("bad divisor") 
        END
      ELSIF (y.mode = ORB.Const) & (y.a >= 2) & (log2(y.a, e) = 1) THEN 
        load(x); 
        PutRRI("srai", x.r, x.r, e)
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
        IF check THEN Trap(LE, 6) END ;
        load(x); 
        PutRRR("quos", RH-2, x.r, y.r); 
        DEC(RH); 
        x.r := RH-1
      END
    ELSE (* op = ORS.mod *)
      IF (x.mode = ORB.Const) & (y.mode = ORB.Const) THEN
        IF y.a > 0 THEN 
          x.a := x.a MOD y.a 
        ELSE
          ORS.Mark("bad modulus")
        END
      ELSIF (y.mode = ORB.Const) & (y.a >= 2) & (log2(y.a, e) = 1) THEN
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
        IF check THEN Trap(LE, 6) END ;
        load(y); 
        PutRRR("rems", RH-2, x.r, y.r);
        DEC(RH)
      END
    END
  END DivOp;

  (* Code generation for REAL operators *)

  PROCEDURE RealOp*(op: INTEGER; VAR x, y: Item);   (* x := x op y *)
  BEGIN 
    load(x); load(y);
    PutSR("wfr", 0, x.r);
    PutSR("wfr", 1, y.r);
    IF    op = ORS.plus  THEN PutSSS("add.s", 0, 0, 1)
    ELSIF op = ORS.minus THEN PutSSS("sub.s", 0, 0, 1)
    ELSIF op = ORS.times THEN PutSSS("mul.s", 0, 0, 1)
    ELSIF op = ORS.rdiv  THEN
      (* __fdiv32 is supplied in the startup code and compute f2 := f0 / f1 *) 
      PutA("call", "__fdiv32");
    END;
    PutRS("rfr", RH-2, 2);
    DEC(RH); x.r := RH-1
  END RealOp;

  (* Code generation for set operators *)

  PROCEDURE Singleton*(VAR x: Item);  (* x := {x} *)
  BEGIN
    IF x.mode = ORB.Const THEN x.a := LSL(1, x.a) 
    ELSE
      load(x);
      PutRI("movi", RH, 1);
      PutR( "ssl",  x.r);
      PutRR("sll",  x.r, RH)
    END
  END Singleton;

  PROCEDURE Set*(VAR x, y: Item);   (* x := {x .. y} *)
  BEGIN
    IF (x.mode = ORB.Const) & ( y.mode = ORB.Const) THEN
      IF x.a <= y.a THEN 
        x.a := LSL(2, y.a) - LSL(1, x.a) 
      ELSE 
        x.a := 0 
      END
    ELSE
      IF (x.mode = ORB.Const) & (x.a <= 16) THEN
        x.a := LSL(-1, x.a)
      ELSE 
        load(x); 
        Put1(Mov, RH, 0, -1); 
        Put0(Lsl, x.r, RH, x.r)
      END ;
      IF (y.mode = ORB.Const) & (y.a < 16) THEN 
        Put1(Mov, RH, 0, LSL(-2, y.a)); 
        y.mode := Reg; 
        y.r := RH; incR
      ELSE 
        load(y); Put1(Mov, RH, 0, -2); Put0(Lsl, y.r, RH, y.r)
      END ;
      IF x.mode = ORB.Const THEN
        IF x.a # 0 THEN 
          Put1(Xor, y.r, y.r, -1); 
          Put1a(And, RH-1, y.r, x.a) 
        END ;
        x.mode := Reg; x.r := RH-1
      ELSE 
        DEC(RH); 
        Put0(Ann, RH-1, x.r, y.r)
      END
    END
  END Set;

  PROCEDURE In*(VAR x, y: Item);  (* x := x IN y *)
  BEGIN 
    load(y);
    IF x.mode = ORB.Const THEN 
      PutRRII("extui", y.r, y.r, (x.a + 1) MOD 20H, 1);
    ELSE 
      load(x); 
      PutRRI("addi", x.r, x.r, 1);
      PutR(  "ssr",  x.r);
      PutRR( "srl",  y.r, y.r);
      PutRI( "movi", x.r, 1);
      PutRRR("and",  y.r, y.r, x.r);
      DEC(RH)
    END ;
  END In;

  PROCEDURE SetOp*(op: INTEGER; VAR x, y: Item);   (* x := x op y *)
    VAR xset, yset: SET; (*x.type.form = Set*)
  BEGIN
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
      DEC(RH); 
      x.r := RH-1
    END 
  END SetOp;

  (* Code generation for relations *)

  PROCEDURE IntRelation*(op: INTEGER; VAR x, y: Item);   (* x := x < y *)
  BEGIN
    IF (y.mode = ORB.Const) & (y.type.form # ORB.Proc) THEN
      load(x);
      IF (y.a # 0) OR 
        ~(op IN {ORS.eql, ORS.neq}) OR 
        (code[pc-1] DIV 40000000H # -2) THEN 
        Put1a(Cmp, x.r, x.r, y.a) 
      END;
      DEC(RH)
    ELSE
      IF (x.mode = Cond) OR (y.mode = Cond) THEN ORS.Mark("not implemented") END ;
      load(x); load(y); 
      Put0(Cmp, x.r, x.r, y.r); 
      DEC(RH, 2)
    END ;
    SetCC(x, relmap[op - ORS.eql])
  END IntRelation;

  PROCEDURE RealRelation*(op: INTEGER; VAR x, y: Item);   (* x := x < y *)
  BEGIN load(x);
    IF (y.mode = ORB.Const) & (y.a = 0) THEN DEC(RH)
    ELSE load(y); Put0(Fsb, x.r, x.r, y.r); DEC(RH, 2)
    END ;
    SetCC(x, relmap[op - ORS.eql])
  END RealRelation;

  PROCEDURE StringRelation*(op: INTEGER; VAR x, y: Item);   (* x := x < y *)
    (* x, y are char arrays or strings *)
  BEGIN
    IF x.type.form = ORB.String THEN loadStringAdr(x) ELSE loadAdr(x) END ;
    IF y.type.form = ORB.String THEN loadStringAdr(y) ELSE loadAdr(y) END ;
    Put2(Ldr+1, RH, x.r, 0); Put1(Add, x.r, x.r, 1);
    Put2(Ldr+1, RH+1, y.r, 0); Put1(Add, y.r, y.r, 1);
    Put0(Cmp, RH+2, RH, RH+1); Put3(BC, NE, 2);
    Put1(Cmp, RH+2, RH, 0); Put3(BC, NE, -8);
    DEC(RH, 2); SetCC(x, relmap[op - ORS.eql])
  END StringRelation;

  (* Code generation of Assignments *)

  PROCEDURE StrToChar*(VAR x: Item);
  BEGIN x.type := ORB.charType; DEC(strx, 4); x.a := ORD(str[x.a])
  END StrToChar;

  PROCEDURE Store*(VAR x, y: Item); (* x := y *)
    VAR 
      op: ARRAY 5 OF CHAR;
      max: INTEGER;
  BEGIN  
    load(y);

    IF x.type.size = 1 THEN op := "s8i"; max := 255 ELSE op := "s32i"; max := 1020 END ;
    IF x.mode = ORB.Var THEN
      IF x.r > 0 THEN (* local *)
        PutMoveRRI(op, max, y.r, SP, x.a + frame);
      ELSE (* imported *)
        GetSB(x.r);
        PutMoveRRI(op, max, y.r, RH, x.a);
      END
    ELSIF x.mode = ORB.Par THEN
      PutMoveRRI("l32i", 1020, RH, SP, x.a + frame);
      PutMoveRRI(op, max, y.r, RH, x.b);
    ELSIF x.mode = RegI THEN 
      PutMoveRRI(op, max, y.r, x.r, x.a); 
      DEC(RH);
    ELSE 
      ORS.Mark("bad mode in Store")
    END ;
    DEC(RH)

    (*
    IF x.type.size = 1 THEN op := Str+1 ELSE op := Str END ;
    IF x.mode = ORB.Var THEN
      IF x.r > 0 THEN (*local*) Put2(op, y.r, SP, x.a + frame)
      ELSE GetSB(x.r); Put2(op, y.r, RH, x.a)
      END
    ELSIF x.mode = ORB.Par THEN Put2(Ldr, RH, SP, x.a + frame); Put2(op, y.r, RH, x.b);
    ELSIF x.mode = RegI THEN Put2(op, y.r, x.r, x.a); DEC(RH);
    ELSE ORS.Mark("bad mode in Store")
    END ;
    DEC(RH)
    *)
  END Store;

  PROCEDURE StoreStruct*(VAR x, y: Item); (* x := y, frame = 0 *)
    VAR s, pc0: INTEGER;
  BEGIN
    IF y.type.size # 0 THEN
      loadAdr(x); loadAdr(y);
      IF (x.type.form = ORB.Array) &  (x.type.len > 0) THEN
        IF y.type.len >= 0 THEN 
          IF x.type.size = y.type.size THEN Put1a(Mov, RH, 0, (y.type.size+3) DIV 4)
          ELSE ORS.Mark("different length/size, not implemented")
          END
        ELSE (*y  open array*) Put2(Ldr, RH, SP, y.a+4); s := y.type.base.size;  (*element size*)
          pc0 := pc; Put3(BC, EQ, 0);
          IF s = 1 THEN Put1(Add, RH, RH, 3); Put1(Asr, RH, RH, 2)
          ELSIF s # 4 THEN Put1a(Mul, RH, RH, s DIV 4)
          END ;
          IF check THEN
            Put1a(Mov, RH+1, 0, (x.type.size+3) DIV 4); Put0(Cmp, RH+1, RH, RH+1); Trap(GT, 3)
          END ;
          fix(pc0, pc + 5 - pc0)
        END
      ELSIF x.type.form = ORB.Record THEN Put1a(Mov, RH, 0, x.type.size DIV 4)
      ELSE ORS.Mark("inadmissible assignment")
      END ;
      Put2(Ldr, RH+1, y.r, 0); Put1(Add, y.r, y.r, 4);
      Put2(Str, RH+1, x.r, 0); Put1(Add, x.r, x.r, 4);
      Put1(Sub, RH, RH, 1); Put3(BC, NE, -6)
    END ;
    RH := FirstRH
  END StoreStruct;

  PROCEDURE CopyString*(VAR x, y: Item);  (* x := y *) 
     VAR len: INTEGER;
   BEGIN loadAdr(x); len := x.type.len;
    IF len >= 0 THEN
      IF len <  y.b THEN ORS.Mark("string too long") END
    ELSIF check THEN Put2(Ldr, RH, SP, x.a+4);  (*open array len, frame = 0*)
      Put1(Cmp,RH, RH, y.b); Trap(LT, 3)
    END ;
    loadStringAdr(y);
    Put2(Ldr, RH, y.r, 0); Put1(Add, y.r, y.r, 4);
    Put2(Str, RH, x.r, 0); Put1(Add, x.r, x.r, 4);
    Put1(Asr, RH, RH, 24); Put3(BC, NE,  -6);  RH := FirstRH
   END CopyString;
  
  (* Code generation for parameters *)
  
  PROCEDURE OpenArrayParam*(VAR x: Item);
  BEGIN loadAdr(x);
    IF x.type.len >= 0 THEN Put1a(Mov, RH, 0, x.type.len) ELSE Put2(Ldr, RH, SP, x.a+4+frame) END ;
    incR
  END OpenArrayParam;

  PROCEDURE VarParam*(VAR x: Item; ftype: ORB.Type);
    VAR xmd: INTEGER;
  BEGIN xmd := x.mode; loadAdr(x);
    IF (ftype.form = ORB.Array) & (ftype.len < 0) THEN (*open array*)
      IF x.type.len >= 0 THEN Put1a(Mov, RH, 0, x.type.len) ELSE  Put2(Ldr, RH, SP, x.a+4+frame) END ;
      incR
    ELSIF ftype.form = ORB.Record THEN
      IF xmd = ORB.Par THEN Put2(Ldr, RH, SP, x.a+4+frame); incR ELSE loadTypTagAdr(x.type) END
    END
  END VarParam;

  PROCEDURE ValueParam*(VAR x: Item);
  BEGIN load(x)
  END ValueParam;

  PROCEDURE StringParam*(VAR x: Item);
  BEGIN loadStringAdr(x); Put1(Mov, RH, 0, x.b); incR  (*len*)
  END StringParam;

  (*For Statements*)

  PROCEDURE For0*(VAR x, y: Item);
  BEGIN load(y)
  END For0;

  PROCEDURE For1*(VAR x, y, z, w: Item; VAR L: INTEGER);
  BEGIN 
    IF z.mode = ORB.Const THEN Put1a(Cmp, RH, y.r, z.a)
    ELSE load(z); Put0(Cmp, RH-1, y.r, z.r); DEC(RH)
    END ;
    L := pc;
    IF w.a > 0 THEN Put3(BC, GT, 0)
    ELSIF w.a < 0 THEN Put3(BC, LT, 0)
    ELSE ORS.Mark("zero increment"); Put3(BC, MI, 0)
    END ;
    Store(x, y)
  END For1;

  PROCEDURE For2*(VAR x, y, w: Item);
  BEGIN load(x); DEC(RH); Put1a(Add, x.r, x.r, w.a)
  END For2;

  (* Branches, procedure calls, procedure prolog and epilog *)

  PROCEDURE Here*(): INTEGER;
  BEGIN RETURN pc
  END Here;

  PROCEDURE FJump*(VAR L: INTEGER);
  BEGIN Put3(BC, 7, L); L := pc-1
  END FJump;

  PROCEDURE CFJump*(VAR x: Item);
  BEGIN
    IF x.mode # Cond THEN loadCond(x) END ;
    Put3(BC, negated(x.r), x.a); FixLink(x.b); x.a := pc-1
  END CFJump;

  PROCEDURE BJump*(L: INTEGER);
  BEGIN Put3(BC, 7, L-pc-1)
  END BJump;

  PROCEDURE CBJump*(VAR x: Item; L: INTEGER);
  BEGIN
    IF x.mode # Cond THEN loadCond(x) END ;
    Put3(BC, negated(x.r), L-pc-1); FixLink(x.b); FixLinkWith(x.a, L)
  END CBJump;

  PROCEDURE Fixup*(VAR x: Item);
  BEGIN FixLink(x.a)
  END Fixup;

  PROCEDURE SaveRegs(low, high: INTEGER);  (* R[low .. high]*)
    VAR 
      cnt, i: INTEGER;
  BEGIN 
    cnt := high - low + 1;
    PutRRI("subi", SP, SP, cnt*4); 
    INC(frame, cnt*4);
    i := 0;
    REPEAT
      PutRRI("s32i", low, SP, i*4);
      INC(i); INC(low);
    UNTIL low > high
  END SaveRegs;

  PROCEDURE RestoreRegs(low, high: INTEGER); (*R[low .. high]*)
    VAR 
      cnt, i: INTEGER;
  BEGIN
    cnt := high - low + 1;
    IF cnt > 0 THEN
      i := 0;
      REPEAT
        PutRRI("l32i", low, SP, i*4);
        INC(i); INC(low);
      UNTIL low > high;
      PutRRI("addi", SP, SP, cnt*4); 
      DEC(frame, 4*cnt)
    END
  END RestoreRegs;

  (* The Esp32 architecture is using a windowing facility that shift
     registers on calls to minimize the need to push registers on the stack.

     The compiler uses 4, 8 or 12 registers shifts to free registers
     for the next call, depending on the number of registers required to
     make de call (parameters) and the registers in use by the caller.

      Kind of  A0 for  First Reg   Max params
      Call     Callee  for params  cnt
      ------   ------  ----------  ----------
      call4      a4        a6         10
      call8      a8       a10          6
      call12    a12       a14          2

    The following algorithm try to optimize the number of registers to save
    on stack if not enough free registers available, combined with the 
    windowing supplied by the architecture.
   *)

  PROCEDURE PrepCall*(VAR x: Item; VAR r: INTEGER): INTEGER;
  VAR
    free : INTEGER;
    callType : INTEGER; (* 4, 8 or 12 *)
  BEGIN (*x.type.form = ORB.Proc*)
    IF x.mode > ORB.Par THEN load(x) END;
    r := RH;
    (* Which registers need to be saved *)
    IF RH <= 4 THEN
      callType := 4;
      free := 10;
    ELSIF RH <= 8 THEN
      callType := 8;
      free := 6;
    ELSE
      callType := 12;
      free := 2;
    END;
    IF (x.type.nofpar > free) & (callType > 4) THEN free := free + 4; callType := callType - 4 END;
    IF (x.type.nofpar > free) & (callType > 4) THEN free := free + 4; callType := callType - 4 END;
    IF x.type.nofpar > free THEN
      ORS.Mark("too many parameters");
    ELSIF RH > callType THEN
      SaveRegs(callType, RH - 1);
    END;
    RH := callType + 2; (* First register to place params *)
    RETURN callType
  END PrepCall;

  PROCEDURE Call*(VAR x: Item; r, callType: INTEGER);
  VAR
    moduleId: ORS.Ident;
    moduleKey: INTEGER;
  BEGIN (*x.type.form = ORB.Proc*)
    (* ShowItem(x); *)
    IF x.mode = ORB.Const THEN
      IF x.r >= 0 THEN (* local proc *)
        PutCallLocal(callType, x.name); 
      ELSE (* imported *)
        ModuleInfo(x.r, moduleId, moduleKey);  
        PutCALLExternal(callType, x.name, moduleId, moduleKey);
      END
    ELSE
      IF (x.mode = ORB.Par) OR (x.mode = ORB.Var) THEN (* Variable or Parameter *)
        load(x); DEC(RH)
      ELSE (* Top of stack *)
        PutRRI("l32i", RH, SP, 0);
        PutRRI("addi", SP, SP, 4);
        DEC(r); 
        DEC(frame, 4)
      END ;
      IF check THEN Trap(EQ, 5) END;
      PutCallR(callType, RH);
    END ;
    IF x.type.base.form = ORB.NoTyp THEN (*procedure*) 
      RH := FirstRH
    ELSE (*function*)
      (* callType + 2 is the register containing the function result *)
      IF (callType + 2) > r THEN
        PutRR("mov", r, callType + 2);
      END;
      RestoreRegs(callType, r - 1);
      x.mode := Reg; 
      x.r := r; 
      RH  := r + 1
    END
  END Call;

  PROCEDURE Enter*(procid: ORS.Ident; exported: BOOLEAN; parblksize, locblksize: INTEGER; int: BOOLEAN);
    VAR a, r: INTEGER;
  BEGIN
    (* interrupt procedures requires to be put in iram to be fast.  To be implemented *)
    frame := 0;
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
    Texts.WriteString(CodeW, "_");
    Texts.WriteString(CodeW, procid);
    Texts.WriteString(CodeW, ":");
    Texts.WriteLn(    CodeW);

    IF ~int THEN (* procedure prolog *)
      IF locblksize >= 10000H THEN ORS.Mark("too many locals") END ;
      PutRI("entry", SP, locblksize);
      a := 0;
      r := 2;
      WHILE a < parblksize DO
        PutRRI("s32i", r, 1, a); 
        INC(r); 
        INC(a, 4)
      END
    ELSE (* interrupt procedure prolog *)
      (* To be defined *)
    END
  END Enter;

  PROCEDURE Return*(form: INTEGER; VAR x: Item; size: INTEGER; int: BOOLEAN; intLevel: INTEGER);
  BEGIN
    IF form # ORB.NoTyp THEN load(x) END;
    IF ~int THEN (*procedure epilog*)
      PutSingle("retw");
    ELSE (*interrupt return, restore R2, R1, R0*)
      (*Put2(Ldr, 2, SP, 8); Put2(Ldr, 1, SP, 4); Put2(Ldr, 0, SP, 0); Put1(Add, SP, SP, size);
      Put3(BR, 7, 10H); *)(*RTI*)

      PutRI("rsr", 0, 208 + intLevel);
      PutI("rfi", intLevel);
    END;
    RH := FirstRH
  END Return;

  (* In-line code procedures*)

  PROCEDURE Increment*(upordown: INTEGER; VAR x, y: Item);
    VAR op, zr, v: INTEGER;
  BEGIN (*frame = 0*)
    IF upordown = 0 THEN op := Add ELSE op := Sub END;
    IF x.type = ORB.byteType THEN v := 1 ELSE v := 0 END;
    IF y.type.form = ORB.NoTyp THEN y.mode := ORB.Const; y.a := 1 END;
    IF (x.mode = ORB.Var) & (x.r > 0) THEN
      zr := RH; Put2(Ldr+v, zr, SP, x.a); incR;
      IF y.mode = ORB.Const THEN Put1a(op, zr, zr, y.a) ELSE load(y); Put0(op, zr, zr, y.r); DEC(RH) END;
      Put2(Str+v, zr, SP, x.a); DEC(RH)
    ELSE loadAdr(x); zr := RH; Put2(Ldr+v, RH, x.r, 0); incR;
      IF y.mode = ORB.Const THEN Put1a(op, zr, zr, y.a) ELSE load(y); Put0(op, zr, zr, y.r); DEC(RH) END;
      Put2(Str+v, zr, x.r, 0); DEC(RH, 2)
    END
  END Increment;

  PROCEDURE Include*(inorex: INTEGER; VAR x, y: Item);
    VAR op, zr: INTEGER;
  BEGIN loadAdr(x); zr := RH; Put2(Ldr, RH, x.r, 0); incR;
    IF inorex = 0 THEN op := Ior ELSE op := Ann END ;
    IF y.mode = ORB.Const THEN Put1a(op, zr, zr, LSL(1, y.a))
    ELSE load(y); Put1(Mov, RH, 0, 1); Put0(Lsl, y.r, RH, y.r); Put0(op, zr, zr, y.r); DEC(RH)
    END ;
    Put2(Str, zr, x.r, 0); DEC(RH, 2)
  END Include;

  PROCEDURE Assert*(VAR x: Item);
    VAR cond: INTEGER;
  BEGIN
    IF x.mode # Cond THEN loadCond(x) END ;
    IF x.a = 0 THEN cond := negated(x.r)
    ELSE Put3(BC, x.r, x.b); FixLink(x.a); x.b := pc-1; cond := 7
    END ;
    Trap(cond, 7); FixLink(x.b)
  END Assert; 

  PROCEDURE New*(VAR x: Item);
  BEGIN loadAdr(x); loadTypTagAdr(x.type.base); Trap(7, 0); RH := FirstRH
  END New;

  PROCEDURE Pack*(VAR x, y: Item);
    VAR z: Item;
  BEGIN z := x; load(x); load(y);
    Put1(Lsl, y.r, y.r, 23); Put0(Add, x.r, x.r, y.r); DEC(RH); Store(z, x)
  END Pack;

  PROCEDURE Unpk*(VAR x, y: Item);
    VAR z, e0: Item;
  BEGIN  z := x; load(x); e0.mode := Reg; e0.r := RH; e0.type := ORB.intType;
    Put1(Asr, RH, x.r, 23); Put1(Sub, RH, RH, 127); Store(y, e0); incR;
    Put1(Lsl, RH, RH, 23); Put0(Sub, x.r, x.r, RH); Store(z, x)
  END Unpk;

  PROCEDURE Led*(VAR x: Item);
  BEGIN load(x); Put1(Mov, RH, 0, -60); Put2(Str, x.r, RH, 0); DEC(RH)
  END Led;

  PROCEDURE Get*(VAR x, y: Item);
  BEGIN load(x); x.type := y.type; x.mode := RegI; x.a := 0; Store(y, x)
  END Get;

  PROCEDURE Put*(VAR x, y: Item);
  BEGIN load(x); x.type := y.type; x.mode := RegI; x.a := 0; Store(x, y)
  END Put;

  PROCEDURE Copy*(VAR x, y, z: Item);
  BEGIN load(x); load(y);
    IF z.mode = ORB.Const THEN
      IF z.a > 0 THEN load(z) ELSE ORS.Mark("bad count") END
    ELSE 
      load(z);
      IF check THEN Trap(LT, 3) END; (* array or string copy overflow *)
      Put3(BC, EQ, 6)
    END ;
    Put2(Ldr, RH, x.r, 0); Put1(Add, x.r, x.r, 4);
    Put2(Str, RH, y.r, 0); Put1(Add, y.r, y.r, 4);
    Put1(Sub, z.r, z.r, 1); Put3(BC, NE, -6); DEC(RH, 3)
  END Copy;

  PROCEDURE LDPSR*(VAR x: Item);
  BEGIN (*x.mode = Const*)  Put3(0, 15, x.a + 20H)
  END LDPSR;

  PROCEDURE LDREG*(VAR x, y: Item);
  BEGIN
    IF y.mode = ORB.Const THEN Put1a(Mov, x.a, 0, y.a)
    ELSE load(y); Put0(Mov, x.a, 0, y.r); DEC(RH)
    END
  END LDREG;

  (*In-line code functions*)

  PROCEDURE Abs*(VAR x: Item);
  BEGIN
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
    load(x);
    PutRI("movi", RH, 1);
    PutRRR("and", x.r, x.r, RH); 
  END Odd;

  PROCEDURE Floor*(VAR x: Item);
  BEGIN 
    load(x); 
    PutSR("wfr", 0, x.r);
    PutRSI("floor.s", x.r, 0, 0);
  END Floor;

  PROCEDURE Float*(VAR x: Item);
  BEGIN 
    load(x); 
    PutSRI("float.s", 0, x.r, 0);
    PutRS("rfr", x.r, 0);
  END Float;

  PROCEDURE Ord*(VAR x: Item);
  BEGIN
    IF x.mode IN {ORB.Var, ORB.Par, RegI, Cond} THEN load(x) END
  END Ord;

  PROCEDURE Len*(VAR x: Item);
  BEGIN
    IF x.type.len >= 0 THEN
      IF x.mode = RegI THEN DEC(RH) END ;
      x.mode := ORB.Const; 
      x.a := x.type.len
    ELSE (*open array*) 
      Put2(Ldr, RH, SP, x.a + 4 + frame); 
      x.mode := Reg; 
      x.r := RH; incR
    END 
  END Len;

  PROCEDURE Shift*(fct: INTEGER; VAR x, y: Item);
    VAR op: INTEGER;
  BEGIN load(x);
    IF fct = 0 THEN op := Lsl ELSIF fct = 1 THEN op := Asr ELSE op := Ror END ;
    IF y.mode = ORB.Const THEN Put1(op, x.r, x.r, y.a MOD 20H)
    ELSE load(y); Put0(op, RH-2, x.r, y.r); DEC(RH); x.r := RH-1
    END
  END Shift;

  PROCEDURE ADC*(VAR x, y: Item);
  BEGIN load(x); load(y); Put0(Add+2000H, x.r, x.r, y.r); DEC(RH)
  END ADC;

  PROCEDURE SBC*(VAR x, y: Item);
  BEGIN load(x); load(y); Put0(Sub+2000H, x.r, x.r, y.r); DEC(RH)
  END SBC;

  PROCEDURE UML*(VAR x, y: Item);
  BEGIN load(x); load(y); Put0(Mul+2000H, x.r, x.r, y.r); DEC(RH)
  END UML;

  PROCEDURE Bit*(VAR x, y: Item);
  BEGIN load(x); Put2(Ldr, x.r, x.r, 0);
    IF y.mode = ORB.Const THEN Put1(Ror, x.r, x.r, y.a+1); DEC(RH)
    ELSE load(y); Put1(Add, y.r, y.r, 1); Put0(Ror, x.r, x.r, y.r); DEC(RH, 2)
    END ;
    SetCC(x, MI)
  END Bit;

  PROCEDURE Register*(VAR x: Item);
  BEGIN (*x.mode = Const*)
    Put0(Mov, RH, 0, x.a MOD 10H); x.mode := Reg; x.r := RH; incR
  END Register;

  PROCEDURE H*(VAR x: Item);
  BEGIN (*x.mode = Const*)
    Put0(Mov + U + x.a MOD 2 * V, RH, 0, 0); x.mode := Reg; x.r := RH; incR
  END H;

  PROCEDURE Adr*(VAR x: Item);
  BEGIN 
    IF x.mode IN {ORB.Var, ORB.Par, RegI} THEN loadAdr(x)
    ELSIF (x.mode = ORB.Const) & (x.type.form = ORB.Proc) THEN load(x)
    ELSIF (x.mode = ORB.Const) & (x.type.form = ORB.String) THEN loadStringAdr(x)
    ELSE ORS.Mark("not addressable")
    END
  END Adr;

  PROCEDURE Condition*(VAR x: Item);
  BEGIN (*x.mode = Const*) SetCC(x, x.a)
  END Condition;

  PROCEDURE SetDataSize*(dc: INTEGER);
  BEGIN varsize := dc
  END SetDataSize;

  PROCEDURE Header*;
  BEGIN 
    entry := pc*4;
    IF version = 0 THEN code[0] := 0E7000000H-1 + pc;  Put1a(Mov, SP, 0, StkOrg0)  (*RISC-0*)
    ELSE Put1(Sub, SP, SP, 4); Put2(Str, LNK, SP, 0)
    END;

    Texts.WriteLn(    CodeW);
    Texts.WriteString(CodeW, "%I");
    Texts.WriteLn(    CodeW);
    Texts.WriteString(CodeW, "_");
    Texts.WriteString(CodeW, thisModuleId);
    Texts.WriteString(CodeW, "_init:");
    Texts.WriteLn(    CodeW);
    PutRI("entry", SP, 0);
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

  PROCEDURE FindPtrs(VAR R: Files.Rider; typ: ORB.Type; adr: INTEGER);
    VAR fld: ORB.Object; i, s: INTEGER;
  BEGIN
    IF (typ.form = ORB.Pointer) OR (typ.form = ORB.NilTyp) THEN Files.WriteInt(R, adr)
    ELSIF typ.form = ORB.Record THEN
      fld := typ.dsc;
      WHILE fld # NIL DO FindPtrs(R, fld.type, fld.val + adr); fld := fld.next END
    ELSIF typ.form = ORB.Array THEN
      s := typ.base.size;
      FOR i := 0 TO typ.len-1 DO FindPtrs(R, typ.base, i*s + adr) END
    END
  END FindPtrs;

  (* Produce a section header of the following form: 
        .section <sectionPrefix>_<moduleId>_<key>
        <blank line>
   *)
  PROCEDURE SectionHeader(sectionPrefix, moduleId: ARRAY OF CHAR;  moduleKey: INTEGER);
  BEGIN
    Texts.WriteString(AsW, "    .section ");
    SectionName(sectionPrefix, moduleId, moduleKey);
    Texts.WriteLn(AsW);
    Texts.WriteString(AsW, "    .global ");
    ExportName(sectionPrefix, "s", moduleId, moduleKey);
    Texts.WriteLn(AsW);
    ExportName(sectionPrefix, "s", moduleId, moduleKey);
    Texts.WriteString(AsW, ":");
    Texts.WriteLn(AsW);

  END SectionHeader;

  PROCEDURE WriteCode(moduleId: ARRAY OF CHAR;  moduleKey: INTEGER) : BOOLEAN;
  VAR
    F:    Files.Rider;
    len:  INTEGER;
    i:    INTEGER;
    name: ARRAY ORS.IdLen OF CHAR;
    initPresent: BOOLEAN;
    b:    BYTE;
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
              SectionHeader("init", moduleId, moduleKey);
              initPresent := TRUE;
            ELSIF CHR(b) = "T" THEN
              SectionHeader("text", moduleId, moduleKey);
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

  PROCEDURE Close*(VAR moduleId: ORS.Ident; moduleKey, nofent: INTEGER);
    VAR obj: ORB.Object;
      i, comsize, nofimps, nofptrs, size: INTEGER;
      name: ORS.Ident;
      initPresent: BOOLEAN;
  BEGIN  (* exit code *)

    ORB.MakeFileName(name, moduleId, ".S"); (* write code file *)
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
    Texts.WriteString(AsW, "Oberon ESP32 Compiler Version 0.1.0");
    Texts.Write(      AsW, 22X);
    Texts.WriteLn(    AsW);
    Texts.WriteLn(    AsW);

    initPresent := FALSE;

    SectionHeader("bss", moduleId, moduleKey);
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

    (* Procedures Code *)
    IF CodeW.buf.len > 0 THEN
      initPresent := WriteCode(moduleId, moduleKey);
      IF initPresent THEN
        Texts.WriteString(AsW, "    retw");
        Texts.WriteLn(AsW)
      END
    END;

    (* Initialization Code Table *)
    IF initPresent THEN
      Texts.WriteLn(AsW);
      SectionHeader("init_table", moduleId, moduleKey);
      Texts.WriteString(AsW, "    .int ");
      SectionName("init", moduleId, moduleKey);
      Texts.WriteLn(AsW);
    END;

    Texts.WriteLn(AsW);
(*
    Texts.WriteString(AsW, "    .end"); Texts.WriteLn(AsW);
*)

    Files.Register(AsF);
 
    (*
    IF version = 0 THEN Put1(Mov, 0, 0, 0); Put3(BR, 7, 0)  (*RISC-0*)
    ELSE Put2(Ldr, LNK, SP, 0); Put1(Add, SP, SP, 4); Put3(BR, 7, LNK)
    END ;
    obj := ORB.topScope.next; nofimps := 0; comsize := 4; nofptrs := 0;
    WHILE obj # NIL DO
      IF (obj.class = ORB.Mod) & (obj.dsc # ORB.system) THEN INC(nofimps) (*count imports*)
      ELSIF (obj.exno # 0) & (obj.class = ORB.Const) & (obj.type.form = ORB.Proc)
          & (obj.type.nofpar = 0) & (obj.type.base = ORB.noType) THEN i := 0; (*count commands*)
        WHILE obj.name[i] # 0X DO INC(i) END ;
        i := (i+4) DIV 4 * 4; INC(comsize, i+4)
      ELSIF obj.class = ORB.Var THEN INC(nofptrs, NofPtrs(obj.type))  (*count pointers*)
      END ;
      obj := obj.next
    END ;
    size := varsize + strx + comsize + (pc + nofimps + nofent + nofptrs + 1)*4;  (*varsize includes type descriptors*)
    
    ORB.MakeFileName(name, modid, ".rsc"); (*write code file*)
    F := Files.New(name);
    Files.Set(R, F, 0); 
    Files.WriteString(R, modid); 
    Files.WriteInt(R, key); 
    Files.Write(R, version);
    Files.WriteInt(R, size);

    obj := ORB.topScope.next;
    WHILE (obj # NIL) & (obj.class = ORB.Mod) DO  (*imports*)
      IF obj.dsc # ORB.system THEN 
        Files.WriteString(R, obj(ORB.Module).orgname); 
        Files.WriteInt(R, obj.val); (* ? Module Checksum *)
      END ;
      obj := obj.next
    END ;
    Files.Write(R, 0); (* end of list *)
    Files.WriteInt(R, tdx*4);
    i := 0;
    WHILE i < tdx DO Files.WriteInt(R, data[i]); INC(i) END ; (*type descriptors*)
    Files.WriteInt(R, varsize - tdx*4);  (*data*)
    Files.WriteInt(R, strx);
    FOR i := 0 TO strx-1 DO Files.Write(R, ORD(str[i])) END ;  (*strings*)
    Files.WriteInt(R, pc);  (*code len*)
    FOR i := 0 TO pc-1 DO Files.WriteInt(R, code[i]) END ;  (*program*)
    obj := ORB.topScope.next;
    WHILE obj # NIL DO  (*commands*)
      IF (obj.exno # 0) & (obj.class = ORB.Const) & (obj.type.form = ORB.Proc) &
          (obj.type.nofpar = 0) & (obj.type.base = ORB.noType) THEN
        Files.WriteString(R, obj.name); Files.WriteInt(R, obj.val)
      END ;
      obj := obj.next
    END ;
    Files.Write(R, 0);
    Files.WriteInt(R, nofent); Files.WriteInt(R, entry);
    obj := ORB.topScope.next;
    WHILE obj # NIL DO  (*entries*)
      IF obj.exno # 0 THEN
        IF (obj.class = ORB.Const) & (obj.type.form = ORB.Proc) OR (obj.class = ORB.Var) THEN
          Files.WriteInt(R, obj.val);
        ELSIF obj.class = ORB.Typ THEN
          IF obj.type.form = ORB.Record THEN Files.WriteInt(R,  obj.type.len MOD 10000H)
          ELSIF (obj.type.form = ORB.Pointer) & ((obj.type.base.typobj = NIL) OR (obj.type.base.typobj.exno = 0)) THEN
            Files.WriteInt(R,  obj.type.base.len MOD 10000H)
          END
        END
      END ;
      obj := obj.next
    END ;
    obj := ORB.topScope.next;
    WHILE obj # NIL DO  (*pointer variables*)
      IF obj.class = ORB.Var THEN FindPtrs(R, obj.type, obj.val) END ;
      obj := obj.next
    END ;
    Files.WriteInt(R, -1);
    Files.WriteInt(R, fixorgP); 
    Files.WriteInt(R, fixorgD); 
    Files.WriteInt(R, fixorgT); 
    Files.WriteInt(R, entry);
    Files.Write(R, ORD("O")); 
    Files.Register(F)
    *)
  END Close;

  PROCEDURE Open*(modid: ORS.Ident; v: INTEGER);
  BEGIN 
    thisModuleId := modid;

    pc      := 0; 
    tdx     := 0; 
    strx    := 0; 
    RH      := FirstRH; 
    fixorgP := 0; 
    fixorgD := 0; 
    fixorgT := 0; 
    check   := v # 0; 
    version := v;

    IF v = 0 THEN 
      pc := 1;
      REPEAT code[pc] := 0; INC(pc) UNTIL pc = 8
    END;

    CodeF := Files.New("");
    Texts.OpenWriterToFile(CodeW, CodeF);
    Texts.WriteLn(CodeW);

    ProcPresent := FALSE;
  END Open;

BEGIN 
  relmap[0] := 1; 
  relmap[1] := 9; 
  relmap[2] := 5; 
  relmap[3] := 6;
  relmap[4] := 14; 
  relmap[5] := 13;
END ORG.
