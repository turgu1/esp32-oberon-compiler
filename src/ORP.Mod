MODULE ORP; (*N. Wirth 1.7.97 / 8.2.2020  Oberon compiler for ESP32 in Oberon-07*)
  IMPORT Texts, Out, ORS, ORB, ORG, SYS, Config;
  (*Author: Niklaus Wirth, 2014. Modification from Guy Turcotte and Andreas Pirklbauer.
    Parser of Oberon-RISC compiler modified for the ESP32. 
    Uses Scanner ORS to obtain symbols (tokens),
    ORB for definition of data structures and for handling import and export, and
    ORG to produce binary code. ORP performs type checking and data allocation.
    Parser is target-independent, except for part of the handling of allocations.*)
  
  CONST 
    NofCases = 256; (* Max number of case labels in a CASE statement *)
    DEBUG = FALSE;
  TYPE 
    PtrBase = POINTER TO PtrBaseDesc;
    PtrBaseDesc = RECORD  (*list of names of pointer base types*)
      name: ORS.Ident; type: ORB.Type; next: PtrBase
    END ;
  
  VAR 
    sym: INTEGER;   (* last symbol read *)
    tdc: INTEGER;   (* types descriptors size counter *)
    dc : INTEGER;   (* data counter *) 
    level, exno: INTEGER;
    newSF: BOOLEAN;  (*option flag*)
    expression: PROCEDURE (VAR x:    ORG.Item);  (*to avoid forward reference*)
    Type:       PROCEDURE (VAR type: ORB.Type; cdecl: BOOLEAN);
    FormalType: PROCEDURE (VAR typ:  ORB.Type; dim: INTEGER; cdecl: BOOLEAN);
    modid: ORS.Ident;
    pbsList: PtrBase;   (*list of names of pointer base types*)
    dummy: ORB.Object;

    sourceFolder, outputFolder, objectFileName: ARRAY 256 OF CHAR;
    fileExtension: ARRAY 10 OF CHAR;
    importPath: ARRAY 1024 OF CHAR;

  PROCEDURE Check(s: INTEGER; msg: ARRAY OF CHAR);
  BEGIN
    IF sym = s THEN ORS.Get(sym) ELSE ORS.Mark(msg) END
  END Check;

  PROCEDURE qualident(VAR obj: ORB.Object);
  BEGIN 
    obj := ORB.thisObj(); 
    ORS.Get(sym);
    IF obj = NIL THEN 
      ORS.Mark("undef"); 
      obj := dummy
    END ;
    IF (sym = ORS.period) & (obj.class = ORB.Mod) THEN
      ORS.Get(sym);
      IF sym = ORS.ident THEN 
        obj := ORB.thisimport(obj); 
        ORS.Get(sym);
        IF obj = NIL THEN 
          ORS.Mark("undef"); 
          obj := dummy
        END
      ELSE 
        ORS.Mark("identifier expected"); 
        obj := dummy
      END
    (* Was added, but removed. 
       Report interpretation remains to be validated.
    ELSIF (obj.lev > 0) & (obj.lev # level) &
          ((obj.class # ORB.Const) OR (obj.type.form # ORB.Proc)) THEN 
      ORS.Mark2("not accessible: ", obj.name);
      Out.Ln; Out.Int(obj.lev, 0); *)
    END
  END qualident;

  PROCEDURE CheckBool(VAR x: ORG.Item);
  BEGIN
    IF x.type.form # ORB.Bool THEN ORS.Mark("Boolean expected"); x.type := ORB.boolType END
  END CheckBool;

  PROCEDURE CheckInt(VAR x: ORG.Item);
  BEGIN
    IF x.type.form # ORB.Int THEN ORS.Mark("Integer expected"); x.type := ORB.intType END
  END CheckInt;

  PROCEDURE CheckReal(VAR x: ORG.Item);
  BEGIN
    IF x.type.form # ORB.Real THEN ORS.Mark("Real expected"); x.type := ORB.realType END
  END CheckReal;

  PROCEDURE CheckSet(VAR x: ORG.Item);
  BEGIN
    IF x.type.form # ORB.Set THEN ORS.Mark("Set expected"); x.type := ORB.setType END 
  END CheckSet;

  PROCEDURE CheckSetVal(VAR x: ORG.Item);
  BEGIN
    IF x.type.form # ORB.Int THEN ORS.Mark("Int expected"); x.type := ORB.setType
    ELSIF x.mode = ORB.Const THEN
      IF (x.a < 0) OR (x.a >= 32) THEN ORS.Mark("invalid set") END
    END 
  END CheckSetVal;

  PROCEDURE CheckConst(VAR x: ORG.Item);
  BEGIN
    IF x.mode # ORB.Const THEN ORS.Mark("not a constant"); x.mode := ORB.Const END
  END CheckConst;

  PROCEDURE CheckReadOnly(VAR x: ORG.Item);
  BEGIN
    IF x.rdo THEN ORS.Mark("read-only") END
  END CheckReadOnly;

  PROCEDURE CheckExport(VAR expo: BOOLEAN);
  BEGIN
    IF sym = ORS.times THEN
      expo := TRUE; ORS.Get(sym);
      IF level # 0 THEN ORS.Mark("remove asterisk") END
    ELSE expo := FALSE
    END
  END CheckExport;

  PROCEDURE IsExtension(t0, t1: ORB.Type): BOOLEAN;
  BEGIN (*t1 is an extension of t0*)
    RETURN (t0 = t1) OR (t1 # NIL) & IsExtension(t0, t1.base)
  END IsExtension;

 PROCEDURE CheckCaseExpr(VAR x: ORG.Item);
  BEGIN
    IF ~(x.type.form IN {ORB.Int, ORB.ShortInt, ORB.Byte, ORB.Char}) THEN ORS.Mark("invalid type"); x.type := ORB.intType END
  END CheckCaseExpr;
(*
  PROCEDURE CheckReceiver(proc: ORB.Object; deref: BOOLEAN);
  BEGIN
    IF ~deref & (proc.type.dsc.class # ORB.Par) THEN ORS.Mark("incompatible receiver") END
  END CheckReceiver;
 
  PROCEDURE DisallowMethods(rec: ORB.Type);  (*disallow binding methods to rec and its base types*)
  BEGIN
    WHILE rec # NIL DO rec.typobj.val := 1; rec := rec.base END
  END DisallowMethods;
 *)
  (* expressions *)

  PROCEDURE TypeTest(VAR x: ORG.Item; T: ORB.Type; guard: BOOLEAN);
    VAR xt: ORB.Type;
  BEGIN 
    xt := x.type;
    IF (T.form = xt.form ) & 
       ((T.form = ORB.Pointer) OR 
        (T.form = ORB.Record) & 
        (x.mode = ORB.Par)) THEN
      WHILE (xt # T) & (xt # NIL) DO xt := xt.base END ;
      IF xt # T THEN xt := x.type;
        IF xt.form = ORB.Pointer THEN
          IF IsExtension(xt.base, T.base) THEN ORG.TypeTest(x, T.base, FALSE, guard); x.type := T
          ELSE ORS.Mark("not an extension")
          END
        ELSIF (xt.form = ORB.Record) & (x.mode = ORB.Par) THEN
          IF IsExtension(xt, T) THEN  ORG.TypeTest(x, T, TRUE, guard); x.type := T
          ELSE ORS.Mark("not an extension")
          END
        ELSE ORS.Mark("incompatible types")
        END
      ELSIF ~guard THEN ORG.TypeTest(x, NIL, FALSE, FALSE)
      END
    ELSE ORS.Mark("type mismatch")
    END ;
    IF ~guard THEN x.type := ORB.boolType END
  END TypeTest;

  PROCEDURE selector(VAR x: ORG.Item);
    VAR y: ORG.Item; obj: ORB.Object;
  BEGIN
    WHILE (sym = ORS.lbrak) OR (sym = ORS.period) OR (sym = ORS.arrow)
        OR (sym = ORS.lparen) & (x.type.form IN {ORB.Record, ORB.Pointer}) DO
      IF sym = ORS.lbrak THEN
        REPEAT ORS.Get(sym); expression(y);
          IF (x.type.form = ORB.Array) OR (x.type.form = ORB.CArray) THEN
            CheckInt(y); ORG.Index(x, y); x.type := x.type.base
          ELSE ORS.Mark("not an array")
          END
        UNTIL sym # ORS.comma;
        Check(ORS.rbrak, "] expected")
      ELSIF sym = ORS.period THEN ORS.Get(sym);
        IF sym = ORS.ident THEN
          IF (x.type.form = ORB.Pointer) OR (x.type.form = ORB.CPointer) THEN ORG.DeRef(x); x.type := x.type.base END ;
          IF (x.type.form = ORB.Record) OR (x.type.form = ORB.CRecord) THEN
            obj := ORB.thisfield(x.type); ORS.Get(sym);
            IF obj # NIL THEN ORG.Field(x, obj); x.type := obj.type
            ELSE ORS.Mark("undef")
            END
          ELSE ORS.Mark("not a record")
          END
        ELSE ORS.Mark("ident expected")
        END
      ELSIF sym = ORS.arrow THEN
        ORS.Get(sym);
        IF (x.type.form = ORB.Pointer) OR (x.type.form = ORB.CPointer) THEN ORG.DeRef(x); x.type := x.type.base
        ELSE ORS.Mark("not a pointer")
        END
      ELSIF (sym = ORS.lparen) & (x.type.form IN {ORB.Record, ORB.Pointer}) THEN (*type guard*)
        ORS.Get(sym);
        IF sym = ORS.ident THEN
          qualident(obj);
          IF obj.class = ORB.Typ THEN TypeTest(x, obj.type, TRUE)
          ELSE ORS.Mark("guard type expected")
          END
        ELSE ORS.Mark("not an identifier")
        END ;
        Check(ORS.rparen, ") expected")
      END
    END
  END selector;

  PROCEDURE EqualSignatures(t0, t1: ORB.Type): BOOLEAN;
    VAR p0, p1: ORB.Object; com: BOOLEAN;
  BEGIN com := TRUE;
    IF (t0.base = t1.base) & (t0.nofpar = t1.nofpar) THEN
      p0 := t0.dsc; p1 := t1.dsc;
      WHILE p0 # NIL DO
        IF (p0.class = p1.class) &  (p0.rdo = p1.rdo) &
          ((p0.type = p1.type) OR
          (p0.type.form = ORB.Array) & (p1.type.form = ORB.Array) & (p0.type.len = p1.type.len) & (p0.type.base = p1.type.base) OR
          (p0.type.form = ORB.Proc) & (p1.type.form = ORB.Proc) & EqualSignatures(p0.type, p1.type) OR
          (p0.type.form = ORB.CProc) & (p1.type.form = ORB.CProc) & EqualSignatures(p0.type, p1.type))
        THEN p0 := p0.next; p1 := p1.next
        ELSE p0 := NIL; com := FALSE
        END
      END
    ELSE com := FALSE
    END ;
    RETURN com
  END EqualSignatures;

  PROCEDURE CompTypes(t0, t1: ORB.Type; varpar: BOOLEAN): BOOLEAN;
  BEGIN (* check for assignment compatibility *)
    RETURN 
      (t0 = t1)  (* openarray assignment disallowed in ORG *)
      OR ((t0.form = ORB.Array) & (t1.form = ORB.Array) & (t0.base = t1.base) & (t0.len = t1.len))
      OR ((t0.form = ORB.CArray) & (t1.form = ORB.CArray) & (t0.base = t1.base) & (t0.len = t1.len))
      OR ((t0.form IN {ORB.Array, ORB.CArray}) & (t1.form IN {ORB.Array, ORB.CArray}) & (t0.base.base = t1.base.base) & (t0.len = t1.len))
      OR ((t0.form = ORB.Record) & (t1.form = ORB.Record)  & IsExtension(t0, t1))
      OR (~varpar &
        ((t0.form = ORB.Pointer) & (t1.form = ORB.Pointer)  & IsExtension(t0.base, t1.base)
        OR (t0.form = ORB.Proc) & (t1.form = ORB.Proc) & EqualSignatures(t0, t1)
        OR (t0.form = ORB.CProc) & (t1.form = ORB.CProc) & EqualSignatures(t0, t1)
        OR (t0.form IN {ORB.Pointer, ORB.CPointer, ORB.Proc}) & (t1.form = ORB.NilTyp)))
      OR (t0.form = ORB.CPointer) & (t1.form IN {
          ORB.Byte, ORB.Bool, ORB.Char, ORB.ShortInt, ORB.Int, ORB.Real, ORB.Set, ORB.String, 
          ORB.CProc, ORB.CPointer, ORB.CArray, ORB.CRecord})
  END CompTypes;

  PROCEDURE Parameter(par: ORB.Object; cdecl: BOOLEAN);
    VAR x: ORG.Item; varpar: BOOLEAN;
  BEGIN 
    expression(x);
    IF par # NIL THEN
      varpar := par.class = ORB.Par;
      IF CompTypes(par.type, x.type, varpar) THEN
        IF ~varpar THEN ORG.ValueParam(x)
        ELSE (*par.class = Par*)
          IF ~par.rdo THEN CheckReadOnly(x) END ;
          ORG.VarParam(x, par.type, cdecl)
        END
      ELSIF (x.type.form = ORB.Array) & 
            (par.type.form = ORB.Array) &
            (x.type.base = par.type.base) & 
            (par.type.len < 0) THEN
        IF ~par.rdo THEN CheckReadOnly(x) END ;
        ORG.OpenArrayParam(x, cdecl)
      ELSIF (x.type.form = ORB.String) & 
            varpar & par.rdo & 
            (par.type.form = ORB.Array) & 
            (par.type.base.form = ORB.Char) & 
            (par.type.len < 0) THEN ORG.StringParam(x, cdecl)
      ELSIF ~varpar & 
            (par.type.form = ORB.Int) & 
            (x.type.form = ORB.Int) THEN ORG.ValueParam(x)  (* BYTE *)
      ELSIF (x.type.form = ORB.String) & 
            (x.b = 2) & 
            (par.class = ORB.Var) & 
            (par.type.form = ORB.Char) THEN
        ORG.StrToChar(x); ORG.ValueParam(x)
      ELSIF (x.type.form = ORB.Char) & (x.mode = ORB.Const) &
            (par.type.form = ORB.Array) & par.rdo &
            (par.type.base.form = ORB.Char) &
            ((par.type.len < 0) OR (par.type.len > 2)) THEN
        ORG.CharToStr(x);  ORG.StringParam(x, cdecl)
      ELSIF (par.type.form = ORB.Array) & 
            (par.type.base = ORB.byteType) & 
            (par.type.len >= 0) & 
            (par.type.size = x.type.size) THEN
        ORG.VarParam(x, par.type, cdecl)
      ELSIF (par.type.form = ORB.Array) & 
            (par.type.base = ORB.shortType) & 
            (par.type.len >= 0) & 
            (par.type.size = x.type.size) THEN
        ORG.VarParam(x, par.type, cdecl)
      ELSE ORS.Mark("incompatible parameters");
        Out.Ln; Out.String("  x.type.form: "); Out.Int(x.type.form, 0);       
        Out.Ln; Out.String("  par.type.form: ");      Out.Int(par.type.form, 0);     
        Out.Ln; Out.String("  par.type.base.form: "); Out.Int(par.type.base.form, 0);
        Out.Ln; Out.String("  par.type.len: ");       Out.Int(par.type.len, 0);      
      END
    END
  END Parameter;

  PROCEDURE ParamList(VAR x: ORG.Item; cdecl: BOOLEAN);
    VAR n: INTEGER; par: ORB.Object;
  BEGIN par := x.type.dsc; n := 0;
    IF sym # ORS.rparen THEN
      Parameter(par, cdecl); n := 1;
      WHILE sym <= ORS.comma DO
        Check(sym, "comma expected");
        IF par # NIL THEN par := par.next END ;
        INC(n); Parameter(par, cdecl)
      END ;
      Check(ORS.rparen, ") expected")
    ELSE ORS.Get(sym);
    END ;
    IF n < x.type.nofpar THEN ORS.Mark("too few params")
    ELSIF n > x.type.nofpar THEN ORS.Mark("too many params")
    END
  END ParamList;

  PROCEDURE StandFunc(VAR x: ORG.Item; fct: INTEGER; restyp: ORB.Type);
    VAR y: ORG.Item; n, npar: INTEGER;
  BEGIN Check(ORS.lparen, "( expected");
    npar := fct MOD 10; fct := fct DIV 10; expression(x); n := 1;
    WHILE sym = ORS.comma DO ORS.Get(sym); expression(y); INC(n) END ;
    Check(ORS.rparen, ") expected");
    IF n = npar THEN
      IF fct = 0 THEN (*ABS*)
        IF x.type.form IN {ORB.Int, ORB.Real} THEN
          ORG.Abs(x); restyp := x.type 
        ELSE ORS.Mark("bad type") END
      ELSIF fct = 1 THEN (* ODD *)   CheckInt(x);  ORG.Odd(x)
      ELSIF fct = 2 THEN (* FLOOR *) CheckReal(x); ORG.Floor(x)
      ELSIF fct = 3 THEN (* FLT *)   CheckInt(x);  ORG.Float(x)
      ELSIF fct = 4 THEN (* ORD *)
        IF (x.type.form <= ORB.Proc) OR (x.type.form = ORB.CProc) THEN ORG.Ord(x)
        ELSIF (x.type.form = ORB.String) & (x.b = 2) THEN ORG.StrToChar(x)
        ELSE ORS.Mark("bad type")
        END
      ELSIF fct = 5 THEN (* CHR *) CheckInt(x); ORG.Ord(x)
      ELSIF fct = 6 THEN (* LEN *)
          IF x.type.form = ORB.Array THEN ORG.Len(x) ELSE 
            ORS.Mark("not an array") 
          END
      ELSIF fct IN {7, 8, 9} THEN (* LSL, ASR, ROR *) CheckInt(y);
        IF x.type.form IN {ORB.Int, ORB.Set} THEN 
          ORG.Shift(fct-7, x, y); restyp := x.type 
        ELSE ORS.Mark("bad type") END
      ELSIF fct = 11 THEN (* ADC *) ORG.ADC(x, y)
      ELSIF fct = 12 THEN (* SBC *) ORG.SBC(x, y)
      ELSIF fct = 13 THEN (* UML *) ORG.UML(x, y)
      ELSIF fct = 14 THEN (* BIT *) CheckInt(x);   CheckInt(y); ORG.Bit(x, y)
      ELSIF fct = 15 THEN (* REG *) CheckConst(x); CheckInt(x); ORG.Register(x)
      ELSIF fct = 16 THEN (* VAL *)
        IF (x.mode= ORB.Typ) & (x.type.size <= y.type.size) THEN 
          restyp := x.type; x := y; ORG.AdjustVal(x, restyp);
        ELSE ORS.Mark("casting not allowed")
        END
      ELSIF fct = 17 THEN (* ADR *) ORG.Adr(x)
      ELSIF fct = 18 THEN (* SIZE *)
        IF x.mode = ORB.Typ THEN ORG.MakeConstItem(x, ORB.intType, x.type.size, 0)
        ELSE ORS.Mark("must be a type")
        END
      ELSIF fct = 19 THEN (* COND *) CheckConst(x); CheckInt(x); ORG.Condition(x)
      ELSIF fct = 20 THEN (* H *) CheckConst(x); CheckInt(x); ORG.H(x)
      ELSIF fct = 21 THEN (* NOT *) CheckInt(x); ORG.BitNot(x)
      ELSIF fct IN {22, 23, 24} THEN (* AND, BOR, XOR *) 
        CheckInt(x); CheckInt(y);
        ORG.BitOp(fct - 22, x, y);
      ELSIF fct IN {25, 26} THEN (* MIN, MAX *) 
        IF ((x.type.form = ORB.Real) & (y.type.form = ORB.Real)) OR
           ((x.type.form IN {ORB.Int, ORB.ShortInt, ORB.Byte}) & (y.type.form IN {ORB.Int, ORB.ShortInt, ORB.Byte})) THEN
          ORG.MinMax(fct - 25, x, y);
          restyp := x.type 
        ELSE ORS.Mark("bad type") END
      ELSIF fct = 27 THEN (* SQRT *) CheckReal(x); ORG.Sqrt(x)
      ELSIF fct = 28 THEN (* RSR *) CheckInt(x); CheckConst(x); ORG.RSR(x)
      ELSE ORS.Mark("bad type")
      END ;
      x.type := restyp
    ELSE ORS.Mark("wrong nbr of params")
    END
  END StandFunc;

  PROCEDURE element(VAR x: ORG.Item);
    VAR y: ORG.Item;
  BEGIN expression(x); CheckSetVal(x);
    IF sym = ORS.upto THEN ORS.Get(sym); expression(y); CheckSetVal(y); ORG.Set(x, y)
    ELSE ORG.Singleton(x)
    END ;
    x.type := ORB.setType
  END element;
  
  PROCEDURE set(VAR x: ORG.Item);
    VAR y: ORG.Item;
  BEGIN
    IF sym >= ORS.if THEN
      IF sym # ORS.rbrace THEN ORS.Mark("} expected") END ;
      ORG.MakeConstItem(x, ORB.setType, 0, 0) (* empty set *)
    ELSE element(x);
      WHILE (sym < ORS.rparen) OR (sym > ORS.rbrace) DO
        IF sym = ORS.comma THEN ORS.Get(sym)
        ELSIF sym # ORS.rbrace THEN ORS.Mark("comma expected")
        END ;
        element(y); ORG.SetOp(ORS.plus, x, y)
      END
    END
  END set; 

  PROCEDURE factor(VAR x: ORG.Item);
    VAR obj: ORB.Object; rx, callType: INTEGER;
  BEGIN (* sync *)
    IF (sym < ORS.char) OR (sym > ORS.ident) THEN ORS.Mark("expression expected");
      REPEAT 
        ORS.Get(sym)
      UNTIL (sym >= ORS.char) & (sym <= ORS.asm) OR (sym >= ORS.then)
    END ;
    IF sym = ORS.ident THEN
      qualident(obj);  
      IF obj.class = ORB.SFunc THEN StandFunc(x, obj.val, obj.type)
      ELSE 
        ORG.MakeItem(x, obj, level); 
        selector(x);
        IF sym = ORS.lparen THEN
          ORS.Get(sym);
          IF ((x.type.form = ORB.Proc) OR (x.type.form = ORB.CProc)) & (x.type.base.form # ORB.NoTyp) THEN
            callType := ORG.PrepCall(x, rx); 
            ParamList(x, x.type.form = ORB.CProc); 
            ORG.Call(x, rx, callType); 
            x.type := x.type.base
          ELSE 
            ORS.Mark("not a function"); 
            ParamList(x, FALSE)
          END
        END
      END
    ELSIF sym = ORS.int     THEN ORG.MakeConstItem(x, ORB.intType, ORS.ival, 0); ORS.Get(sym)
    ELSIF sym = ORS.long    THEN ORG.MakeConstItem(x, ORB.longType, ORS.ival, ORS.ival1); ORS.Get(sym)
    ELSIF sym = ORS.real    THEN ORG.MakeRealItem(x, ORS.rval); ORS.Get(sym)
    ELSIF sym = ORS.char    THEN ORG.MakeConstItem(x, ORB.charType, ORS.ival, 0); ORS.Get(sym)
    ELSIF sym = ORS.nil     THEN ORS.Get(sym); ORG.MakeConstItem(x, ORB.nilType, 0, 0)
    ELSIF sym = ORS.string  THEN ORG.MakeStringItem(x, ORS.slen); ORS.Get(sym)
    ELSIF sym = ORS.lparen  THEN ORS.Get(sym); expression(x); Check(ORS.rparen, ") expected")
    ELSIF sym = ORS.lbrace  THEN ORS.Get(sym); set(x); Check(ORS.rbrace, "} expected")
    ELSIF sym = ORS.not     THEN ORS.Get(sym); factor(x); CheckBool(x); ORG.Not(x)
    ELSIF sym = ORS.false   THEN ORS.Get(sym); ORG.MakeConstItem(x, ORB.boolType, 0, 0)
    ELSIF sym = ORS.true    THEN ORS.Get(sym); ORG.MakeConstItem(x, ORB.boolType, 1, 0)
    ELSE ORS.Mark("not a factor"); ORG.MakeConstItem(x, ORB.intType, 0, 0)
    END
  END factor;

  PROCEDURE term(VAR x: ORG.Item);
    VAR y: ORG.Item; op, f: INTEGER;
  BEGIN factor(x); f := x.type.form;
    WHILE (sym >= ORS.times) & (sym <= ORS.and) DO
      op := sym; ORS.Get(sym);
      IF op = ORS.times THEN
        IF f = ORB.Int THEN factor(y); CheckInt(y); ORG.MulOp(x, y)
        ELSIF f = ORB.Real THEN factor(y); CheckReal(y); ORG.RealOp(op, x, y)
        ELSIF f = ORB.Set  THEN factor(y); CheckSet(y);  ORG.SetOp(op, x, y)
        ELSE ORS.Mark("bad type")
        END
      ELSIF (op = ORS.div) OR (op = ORS.mod) THEN
        CheckInt(x); factor(y); CheckInt(y); ORG.DivOp(op, x, y)
      ELSIF op = ORS.rdiv THEN
        IF f = ORB.Real THEN factor(y); CheckReal(y); ORG.RealOp(op, x, y)
        ELSIF f = ORB.Set THEN factor(y); CheckSet(y); ORG.SetOp(op, x, y)
        ELSE ORS.Mark("bad type")
        END
      ELSE (* op = and *) 
        CheckBool(x); ORG.And1(x); factor(y); CheckBool(y); ORG.And2(x, y)
      END
    END
  END term;

  PROCEDURE SimpleExpression(VAR x: ORG.Item);
    VAR y: ORG.Item; op: INTEGER;
  BEGIN
    IF sym = ORS.minus THEN ORS.Get(sym); term(x);
      IF x.type.form IN {ORB.Int, ORB.Real, ORB.Set} THEN ORG.Neg(x) ELSE CheckInt(x) END
    ELSIF sym = ORS.plus THEN ORS.Get(sym); term(x);
    ELSE term(x)
    END ;
    WHILE (sym >= ORS.plus) & (sym <= ORS.or) DO
      op := sym; ORS.Get(sym);
      IF op = ORS.or THEN ORG.Or1(x); CheckBool(x); term(y); CheckBool(y); ORG.Or2(x, y)
      ELSIF x.type.form = ORB.Int  THEN term(y); CheckInt(y);  ORG.AddOp(op, x, y)
      ELSIF x.type.form = ORB.Real THEN term(y); CheckReal(y); ORG.RealOp(op, x, y)
      ELSIF (x.type.form = ORB.CPointer) OR (x.type.form = ORB.Pointer) THEN ORS.Mark("operations on pointers not allowed")
      ELSE CheckSet(x); term(y); CheckSet(y); ORG.SetOp(op, x, y)
      END
    END
  END SimpleExpression;

  PROCEDURE expression0(VAR x: ORG.Item);
    VAR y: ORG.Item; obj: ORB.Object; rel, xf, yf: INTEGER;
  BEGIN SimpleExpression(x);
    IF (sym >= ORS.eql) & (sym <= ORS.geq) THEN
      rel := sym; ORS.Get(sym); SimpleExpression(y); xf := x.type.form; yf := y.type.form;
      IF x.type = y.type THEN
        IF (xf IN {ORB.Char, ORB.Int}) THEN ORG.IntRelation(rel, x, y)
        ELSIF xf = ORB.Real THEN ORG.RealRelation(rel, x, y)
        ELSIF (xf IN {ORB.Set, ORB.Pointer, ORB.Proc, ORB.CProc, ORB.NilTyp, ORB.Bool}) THEN
          IF rel <= ORS.neq THEN ORG.IntRelation(rel, x, y) ELSE ORS.Mark("only = or #") END
        ELSIF (xf = ORB.Array) & (x.type.base.form = ORB.Char) OR (xf = ORB.String) THEN
          ORG.StringRelation(rel, x, y)
        ELSE ORS.Mark("illegal comparison")
        END
      ELSIF (xf IN {ORB.Pointer, ORB.Proc, ORB.CProc}) & (yf = ORB.NilTyp)
          OR (yf IN {ORB.Pointer, ORB.Proc, ORB.CProc}) & (xf = ORB.NilTyp) THEN
        IF rel <= ORS.neq THEN ORG.IntRelation(rel, x,  y) ELSE ORS.Mark("only = or #") END
      ELSIF (xf = ORB.Pointer) & (yf = ORB.Pointer) &
          (IsExtension(x.type.base, y.type.base) OR IsExtension(y.type.base, x.type.base))
          OR (xf = ORB.Proc) & (yf = ORB.Proc) & EqualSignatures(x.type, y.type) 
          OR (xf = ORB.CProc) & (yf = ORB.CProc) & EqualSignatures(x.type, y.type) THEN
        IF rel <= ORS.neq THEN ORG.IntRelation(rel,  x, y) ELSE ORS.Mark("only = or #") END
      ELSIF (xf = ORB.Array) & 
            (x.type.base.form = ORB.Char) &
            ((yf = ORB.String) OR (yf = ORB.Array) & (y.type.base.form = ORB.Char)) OR 
            (yf = ORB.Array) & 
            (y.type.base.form = ORB.Char) & 
            (xf = ORB.String) THEN
        ORG.StringRelation(rel, x, y)
      ELSIF (xf = ORB.Char) & (yf = ORB.String) & (y.b = 2) THEN
        ORG.StrToChar(y); ORG.IntRelation(rel, x, y)
      ELSIF (yf = ORB.Char) & (xf = ORB.String) & (x.b = 2) THEN
        ORG.StrToChar(x); ORG.IntRelation(rel, x, y)
      ELSIF (xf = ORB.Int) & (yf = ORB.Int) THEN ORG.IntRelation(rel,  x, y)  (* BYTE *)
      ELSE ORS.Mark("illegal comparison")
      END ;
      x.type := ORB.boolType
    ELSIF sym = ORS.in THEN
      ORS.Get(sym); CheckInt(x); SimpleExpression(y); CheckSet(y); ORG.In(x, y) ;
      x.type := ORB.boolType
    ELSIF sym = ORS.is THEN
      ORS.Get(sym); qualident(obj); TypeTest(x, obj.type, FALSE) ;
      x.type := ORB.boolType
    END
  END expression0;

  (* statements *)

  PROCEDURE StandProc(pno: INTEGER);
    VAR nap, npar: INTEGER; (* nof actual/formal parameters *)
      x, y, z: ORG.Item;
  BEGIN Check(ORS.lparen, "( expected");
    npar := pno MOD 10; pno := pno DIV 10; expression(x); nap := 1;
    IF sym = ORS.comma THEN
      ORS.Get(sym); expression(y); nap := 2; z.type := ORB.noType;
      WHILE sym = ORS.comma DO ORS.Get(sym); expression(z); INC(nap) END
    ELSE y.type := ORB.noType
    END ;
    Check(ORS.rparen, ") expected");
    IF (npar = nap) OR (pno IN {0, 1}) THEN 
      IF pno IN {0, 1} THEN (* INC, DEC *)
        CheckInt(x); CheckReadOnly(x);
        IF y.type # ORB.noType THEN CheckInt(y) END ;
        ORG.Increment(pno, x, y)
      ELSIF pno IN {2, 3} THEN (* INCL, EXCL *)
        CheckSet(x); CheckReadOnly(x); CheckInt(y); ORG.Include(pno-2, x, y)
      ELSIF pno = 4 THEN CheckBool(x); ORG.Assert(x)
      ELSIF pno = 5 THEN(* NEW *) CheckReadOnly(x);
         IF (x.type.form = ORB.Pointer) & (x.type.base.form = ORB.Record) THEN ORG.New(x)
         ELSE ORS.Mark("not a pointer to record")
         END
      ELSIF pno = 6 THEN CheckReal(x); CheckInt(y); CheckReadOnly(x); ORG.Pack(x, y)
      ELSIF pno = 7 THEN CheckReal(x); CheckInt(y); CheckReadOnly(x); ORG.Unpk(x, y)
      ELSIF pno = 8 THEN
        IF x.type.form <= ORB.Set THEN ORG.Led(x) ELSE ORS.Mark("bad type") END
      ELSIF pno = 10 THEN CheckInt(x); ORG.Get(x, y)
      ELSIF pno = 11 THEN CheckInt(x); ORG.Put(x, y)
      ELSIF pno = 12 THEN CheckInt(x); CheckInt(y); CheckInt(z); ORG.Copy(x, y, z)
      ELSIF pno = 13 THEN CheckConst(x); CheckInt(x); ORG.LDPSR(x)
      ELSIF pno = 14 THEN CheckInt(x); ORG.LDREG(x, y)
      ELSIF pno = 15 THEN CheckInt(x); CheckConst(x); ORG.WSR(x, y)
      END
    ELSE ORS.Mark("wrong nof parameters")
    END
  END StandProc;

  PROCEDURE StatSequence;
    VAR obj: ORB.Object;
      (* orgtype: ORB.Type; original type of case var *)
      x, y, z, w: ORG.Item;
      L0, L1, rx, callType: INTEGER;

    PROCEDURE TypeCasePart;
      VAR obj: ORB.Object; L0: INTEGER;
        x: ORG.Item;

      PROCEDURE TypeCase(obj: ORB.Object; VAR x: ORG.Item);
        VAR typobj: ORB.Object; 
          orgtype: ORB.Type;  (* original type of case var *)
      BEGIN
        IF sym = ORS.ident THEN
          qualident(typobj); ORG.MakeItem(x, obj, level); orgtype := obj.type;
          IF typobj.class # ORB.Typ THEN ORS.Mark("not a type") END ;
          TypeTest(x, typobj.type, FALSE); obj.type := typobj.type;
          ORG.CFJump(x); Check(ORS.colon, ": expected"); StatSequence;
          obj.type := orgtype
        ELSE ORS.Mark("type id expected"); Check(ORS.colon, ": expected"); StatSequence
        END
      END TypeCase;

    BEGIN qualident(obj); Check(ORS.of, "OF expected"); ORG.GetLabel(L0); x.lf := 0;
      WHILE (sym < ORS.end) OR (sym = ORS.bar) DO
        IF sym = ORS.bar THEN ORS.Get(sym) ELSE 
          IF x.lf # 0 THEN ORG.PutLabel(x.lf); x.lf := 0 END ;
          TypeCase(obj, x); ORG.FJump(L0) 
        END
      END ;
      IF x.lf # 0 THEN ORG.PutLabel(x.lf); x.lf := 0 END ;
      IF sym = ORS.else THEN ORS.Get(sym); StatSequence END ;
      ORG.PutLabel(L0)
    END TypeCasePart;

    PROCEDURE NumericCasePart;
      VAR x: ORG.Item; L0, L1, L2, n, labelform: INTEGER;
        tab: ARRAY NofCases OF ORG.LabelRange;  (* ordered table of label ranges *)
      PROCEDURE NumericCase(LabelForm: INTEGER; VAR n: INTEGER; VAR tab: ARRAY OF ORG.LabelRange);
        VAR x, y: ORG.Item; i: INTEGER; continue: BOOLEAN;

        PROCEDURE CaseLabel(VAR x: ORG.Item);
        BEGIN expression(x); CheckConst(x);
          IF (x.type.form = ORB.String) & (x.b = 2) THEN ORG.StrToChar(x)
          ELSIF ~(x.type.form IN {ORB.Int, ORB.Char}) OR (x.a < 0) OR (x.a > 255) THEN
            ORS.Mark("invalid case label"); x.type := ORB.intType
          END
        END CaseLabel;

      BEGIN
        REPEAT CaseLabel(x);
          IF x.type.form # LabelForm THEN ORS.Mark("invalid label form") END ;
          IF sym = ORS.upto THEN ORS.Get(sym); CaseLabel(y);
            IF (x.type.form # y.type.form) OR (x.a >= y.a) THEN ORS.Mark("invalid label range"); y := x END
          ELSE y := x
          END ;
          IF n < NofCases THEN  (* enter label range into ordered table *)
            i := n; continue := TRUE;
            WHILE continue & (i > 0) DO
              IF tab[i - 1].low > y.a THEN tab[i] := tab[i - 1]; DEC(i)
              ELSE continue := FALSE;
                IF tab[i - 1].high >= x.a THEN ORS.Mark("overlapping case labels") END
              END
            END ;
            tab[i].low := x.a; tab[i].high := y.a; tab[i].label := ORG.Here(); INC(n)
          ELSE ORS.Mark("too many case labels")
          END ;
          IF sym = ORS.comma THEN ORS.Get(sym)
          ELSIF (sym < ORS.comma) OR (sym = ORS.semicolon) THEN ORS.Mark("comma expected")
          END
        UNTIL (sym > ORS.comma) & (sym # ORS.semicolon);
        Check(ORS.colon, ": expected"); StatSequence
      END NumericCase;

    BEGIN expression(x); CheckCaseExpr(x); ORG.GetLabel(L1); ORG.GetLabel(L0); ORG.CaseHead(x, L0, L1);
      Check(ORS.of, "OF expected"); n := 0; ORG.GetLabel(L2); labelform := x.type.form;
      WHILE (sym < ORS.end) OR (sym = ORS.bar) DO
        IF sym = ORS.bar THEN ORS.Get(sym) ELSE NumericCase(labelform, n, tab); ORG.FJump(L2) END
      END ;
      IF sym = ORS.else THEN ORS.Get(sym); ORG.PutLabel(L1); StatSequence; ORG.FJump(L2) ELSE L1 := -L1 END ;
      ORG.CaseTail(L0, L1, n, tab); 
      IF L1 < 0 THEN ORG.PutLabel(-L1) END ;
      ORG.PutLabel(L2)
    END NumericCasePart;

  BEGIN (* StatSequence *)
    REPEAT (* sync *) obj := NIL;
      IF ~((sym >= ORS.ident) & (sym <= ORS.asm) OR (sym >= ORS.semicolon)) THEN
        ORS.Mark("statement expected");
        REPEAT ORS.Get(sym) UNTIL (sym >= ORS.ident)
      END ;
      IF sym = ORS.ident THEN (* ----- ASSIGNMENT / PROCEDURE CALL ----- *)
        qualident(obj); 
        ORG.MakeItem(x, obj, level);
        IF x.mode = ORB.SProc THEN StandProc(obj.val)
        ELSE selector(x);
          IF sym = ORS.becomes THEN (* ----- assignment ----- *)
            ORS.Get(sym); CheckReadOnly(x); expression(y);
            IF CompTypes(x.type, y.type, FALSE) THEN
              IF (x.type.form <= ORB.Pointer) OR (x.type.form = ORB.Proc) OR (x.type.form = ORB.CProc) THEN ORG.Store(x, y)
              ELSIF x.type.form = ORB.CPointer THEN ORG.StoreAdr(x, y)
              ELSE ORG.StoreStruct(x, y)
              END
            ELSIF (x.type.form = ORB.Array) & (y.type.form = ORB.Array) & (x.type.base = y.type.base) & (y.type.len < 0) THEN
              ORG.StoreStruct(x, y)
            ELSIF (x.type.form = ORB.CArray) & (y.type.form = ORB.CArray) & (x.type.base = y.type.base) & (y.type.len < 0) THEN
              ORG.StoreStruct(x, y)
            ELSIF (x.type.form IN {ORB.Array, ORB.CArray}) & (y.type.form  IN {ORB.Array, ORB.CArray}) & (x.type.base.base = y.type.base.base) & (y.type.len < 0) THEN
              ORG.StoreStruct(x, y)
            ELSIF ((x.type.form = ORB.Array) OR (x.type.form = ORB.CArray)) & (x.type.base.form = ORB.Char) & (y.type.form = ORB.String) THEN
              ORG.CopyString(x, y)
            ELSIF (x.type.form = ORB.Array) & (x.type.base.form = ORB.Char) & (y.mode = ORB.Const) & (y.type.form = ORB.Char) THEN
              ORG.CharToStr(y); ORG.CopyString(x, y);
            ELSIF (x.type.form = ORB.Int) & (y.type.form = ORB.Int) THEN ORG.Store(x, y)  (* BYTE *)
            ELSIF (x.type.form = ORB.Char) & (y.type.form = ORB.String) & (y.b = 2) THEN
              ORG.StrToChar(y); ORG.Store(x, y)
            ELSE 
              ORS.Mark("illegal assignment");
              
              
              Out.Ln; Out.String("--> x.type.form: "); Out.Int(x.type.form, 0);
              Out.Ln; Out.String("--> y.type.form: "); Out.Int(y.type.form, 0);
              Out.Ln; Out.String("--> x.type.base.form: "); Out.Int(x.type.base.base.form, 0);
              Out.Ln; Out.String("--> y.type.base.form: "); Out.Int(y.type.base.base.form, 0);
              Out.Ln; Out.String("--> x.type.len: "); Out.Int(x.type.len, 0);
              Out.Ln; Out.String("--> y.type.len: "); Out.Int(y.type.len, 0);
            END
          ELSIF sym = ORS.eql THEN ORS.Mark("should be :="); ORS.Get(sym); expression(y)
          ELSIF sym = ORS.lparen THEN (* ----- procedure call ----- *)
            ORS.Get(sym);
            IF ((x.type.form = ORB.Proc) OR (x.type.form = ORB.CProc)) & (x.type.base.form = ORB.NoTyp) THEN
              callType := ORG.PrepCall(x, rx); 
              ParamList(x, x.type.form = ORB.CProc); 
              ORG.Call(x, rx, callType)
            ELSE 
              ORS.Mark("not a procedure"); ParamList(x, FALSE);
              Out.Ln; Out.Int(x.type.form, 0); Out.Int(x.type.base.form, 4)
            END
          ELSIF (x.type.form = ORB.Proc) OR (x.type.form = ORB.CProc) THEN (* procedure call without parameters *)
            IF x.type.nofpar > 0 THEN ORS.Mark("missing parameters") END ;
            IF x.type.base.form = ORB.NoTyp THEN 
              callType := ORG.PrepCall(x, rx); 
              ORG.Call(x, rx, callType) 
            ELSE 
              ORS.Mark("not a procedure") 
            END
          ELSIF x.mode = ORB.Typ THEN 
            ORS.Mark("illegal assignment");
            (* 
            Out.Ln; Out.String("--> x.type.form: "); Out.Int(x.type.form, 0);
            Out.Ln; Out.String("--> y.type.form: "); Out.Int(y.type.form, 0) *)
          ELSE ORS.Mark("not a procedure")
          END
        END
      ELSIF sym = ORS.if THEN (* ----- IF ----- *)
        ORS.Get(sym); 
        L0 := 0; ORG.ClearLabels(x);
        expression(x); 
        CheckBool(x); ORG.CFJump(x);
        Check(ORS.then, "THEN expected");
        StatSequence;
        WHILE sym = ORS.elsif DO
          ORS.Get(sym);
          IF L0 = 0 THEN ORG.GetLabel(L0) END ; ORG.FJump(L0); 
          ORG.PutLabel(x.lf); x.lf := 0; 
          expression(x); 
          CheckBool(x); ORG.CFJump(x); 
          Check(ORS.then, "THEN expected"); 
          StatSequence
        END ;
        IF sym = ORS.else THEN 
          ORS.Get(sym); 
          IF L0 = 0 THEN ORG.GetLabel(L0) END ; ORG.FJump(L0); 
          ORG.PutLabel(x.lf); x.lf := 0;
          StatSequence
        END ;
        IF x.lf # 0 THEN ORG.PutLabel(x.lf); x.lf := 0 END ; 
        IF   L0 # 0 THEN ORG.PutLabel(L0)   END ;
        Check(ORS.end, "END expected")
      ELSIF sym = ORS.while THEN (* ----- WHILE ----- *)
        ORS.Get(sym); 
        L0 := ORG.Here(); ORG.ClearLabels(x);   
        expression(x); 
        CheckBool(x); ORG.CFJump(x);
        Check(ORS.do, "DO expected"); 
        StatSequence; 
        ORG.BJump(L0);
        WHILE sym = ORS.elsif DO
          ORS.Get(sym); 
          ORG.PutLabel(x.lf); x.lf := 0; 
          expression(x); 
          CheckBool(x); ORG.CFJump(x);
          Check(ORS.do, "DO expected"); StatSequence; ORG.BJump(L0)
        END ;
        ORG.PutLabel(x.lf); x.lf := 0;
        Check(ORS.end, "END expected")
      ELSIF sym = ORS.repeat THEN (* ----- REPEAT ----- *)
        ORS.Get(sym); L0 := ORG.Here(); 
        StatSequence;
        IF sym = ORS.until THEN
          ORS.Get(sym); expression(x); CheckBool(x); 
          ORG.CBJump(x, L0)
        ELSE 
          ORS.Mark("missing UNTIL")
        END ;
        IF x.lt # 0 THEN ORG.PutLabel(x.lt); x.lt := 0 END 
      ELSIF sym = ORS.for THEN (* ----- FOR ----- *)
        ORS.Get(sym);
        IF sym = ORS.ident THEN
          qualident(obj); ORG.MakeItem(x, obj, level); CheckInt(x); CheckReadOnly(x);
          IF sym = ORS.becomes THEN
            ORS.Get(sym); expression(y); CheckInt(y); ORG.For0(x, y); L0 := ORG.Here();
            Check(ORS.to, "TO expected"); expression(z); CheckInt(z); obj.rdo := TRUE;
            IF sym = ORS.by THEN ORS.Get(sym); expression(w); CheckConst(w); CheckInt(w)
            ELSE ORG.MakeConstItem(w, ORB.intType, 1, 0)
            END ;
            Check(ORS.do, "DO expected"); ORG.For1(x, y, z, w, L1);
            StatSequence; Check(ORS.end, "END expected");
            ORG.For2(x, y, w); ORG.BJump(L0); ORG.PutLabel(L1); obj.rdo := FALSE
          ELSE ORS.Mark(":= expected")
          END
        ELSE ORS.Mark("identifier expected")
        END
      ELSIF sym = ORS.case THEN (* ----- CASE ----- *)
        ORS.Get(sym);
        IF sym = ORS.ident THEN obj := ORB.thisObj() END ;
        IF (obj # NIL) & (obj.type # NIL) &
           ((obj.type.form = ORB.Pointer) OR 
            (obj.type.form = ORB.Record) & 
            (obj.class = ORB.Par)) THEN TypeCasePart
        ELSE NumericCasePart
        END ;
        Check(ORS.end, "END expected")
      ELSIF sym = ORS.asm THEN 
        ORG.assembler; ORS.Get(sym)
      END ;
      ORG.CheckRegs;
      IF sym = ORS.semicolon THEN ORS.Get(sym)
      ELSIF sym < ORS.semicolon THEN ORS.Mark("semicolon expected")
      END
    UNTIL sym > ORS.semicolon
  END StatSequence;

  (* Types and declarations *)

  PROCEDURE CheckForCDecl(): BOOLEAN;
    VAR cdecl: BOOLEAN; decl: ORS.Ident;
  BEGIN
    cdecl := FALSE;
    IF sym = ORS.lbrak THEN ORS.Get(sym); 
      IF sym = ORS.ident THEN
        ORS.CopyId(decl);
        IF decl = "CDECL" THEN cdecl := TRUE ELSE ORS.Mark("CDECL expected") END ;
        ORS.Get(sym)
      ELSE ORS.Mark("CDECL expected")
      END ;
      Check(ORS.rbrak, "] expected")
    END
    RETURN cdecl
  END CheckForCDecl;

  PROCEDURE IdentList(class: INTEGER; VAR first: ORB.Object);
    VAR obj: ORB.Object;
  BEGIN
    IF sym = ORS.ident THEN
      ORB.NewObj(first, ORS.id, class); ORS.Get(sym); CheckExport(first.expo);
      WHILE sym = ORS.comma DO
        ORS.Get(sym);
        IF sym = ORS.ident THEN ORB.NewObj(obj, ORS.id, class); ORS.Get(sym); CheckExport(obj.expo)
        ELSE ORS.Mark("ident expected")
        END
      END ;
      IF sym = ORS.colon THEN ORS.Get(sym) ELSE ORS.Mark(": expected") END
    ELSE first := NIL
    END
  END IdentList;
  
  PROCEDURE ArrayType(VAR type: ORB.Type; cdecl: BOOLEAN);
    VAR x: ORG.Item; typ: ORB.Type; len: INTEGER;
  BEGIN 
    cdecl := CheckForCDecl() OR cdecl;
    NEW(typ); typ.form := ORB.NoTyp;
    IF sym = ORS.of THEN (* open array type *)
      ORS.Get(sym); Type(typ.base, cdecl); typ.len := -1; typ.size := 0;
      IF typ.base.form = ORB.Array THEN ORS.Mark("multi-dimensional open arrays not allowed") END
    ELSE
      expression(x);
      IF (x.mode = ORB.Const) & (x.type.form = ORB.Int) & (x.a >= 0) THEN 
        len := x.a
      ELSE len := 1; ORS.Mark("not a valid length")
      END ;
      IF sym = ORS.of THEN 
        ORS.Get(sym); Type(typ.base, cdecl);
        IF (typ.base.form = ORB.Array) & (typ.base.len < 0) THEN 
          ORS.Mark("dyn array not allowed") 
        END
      ELSIF sym = ORS.comma THEN ORS.Get(sym); ArrayType(typ.base, cdecl)
      ELSE ORS.Mark("OF expected"); typ.base := ORB.intType
      END ;
      typ.size := (len * typ.base.size + 3) DIV 4 * 4; typ.len := len
    END ;
    IF cdecl THEN typ.form := ORB.CArray ELSE typ.form := ORB.Array END ; type := typ
  END ArrayType;

  PROCEDURE RecordType(VAR type: ORB.Type; cdecl: BOOLEAN);
    VAR obj, obj0, new, bot, base: ORB.Object;
      typ, tp: ORB.Type;
      offset, off, n: INTEGER;
  BEGIN 
    NEW(typ); 
    cdecl := CheckForCDecl() OR cdecl;
    typ.form := ORB.NoTyp; typ.base := NIL; typ.mno := -level; typ.nofpar := 0; typ.len := 0; 
    offset := 0; bot := NIL;
    IF (~cdecl) & (sym = ORS.lparen) THEN
      ORS.Get(sym); (* record extension *)
      IF level # 0 THEN ORS.Mark("extension of local types not implemented") END ;
      IF sym = ORS.ident THEN
        qualident(base);
        IF base.class = ORB.Typ THEN
          IF base.type.form = ORB.Record THEN typ.base := base.type
          ELSE typ.base := ORB.intType; ORS.Mark("invalid extension")
          END ;
          typ.nofpar := typ.base.nofpar + 1; (* "nofpar" here abused for extension level *)
          bot := typ.base.dsc; offset := typ.base.size
        ELSE ORS.Mark("type expected")
        END
      ELSE ORS.Mark("ident expected")
      END ;
      Check(ORS.rparen, ") expected")
    END ;
    WHILE sym = ORS.ident DO  (* fields *)
      n := 0; obj := bot;
      WHILE sym = ORS.ident DO
        obj0 := obj;
        WHILE (obj0 # NIL) & (obj0.name # ORS.id) DO obj0 := obj0.next END ;
        IF obj0 # NIL THEN ORS.Mark("mult def") END ;
        NEW(new); ORS.CopyId(new.name); new.class := ORB.Fld; new.next := obj; obj := new; INC(n);
        ORS.Get(sym); CheckExport(new.expo);
        IF (sym # ORS.comma) & (sym # ORS.colon) THEN ORS.Mark("comma expected")
        ELSIF sym = ORS.comma THEN ORS.Get(sym)
        END
      END ;
      Check(ORS.colon, "colon expected"); Type(tp, cdecl);
      IF (tp.form = ORB.Array) & (tp.len < 0) THEN ORS.Mark("dyn array not allowed") END ;
      IF tp.size > 1 THEN
        IF tp.size = 2 THEN
          offset := (offset + 1) DIV 2 * 2
        ELSE
          offset := (offset + 3) DIV 4 * 4 
        END
      END ;
      offset := offset + n * tp.size; off := offset; obj0 := obj;
      WHILE obj0 # bot DO obj0.type := tp; obj0.lev := 0; off := off - tp.size; obj0.val := off; obj0 := obj0.next END ;
      bot := obj;
      IF sym = ORS.semicolon THEN ORS.Get(sym) ELSIF sym # ORS.end THEN ORS.Mark(" ; or END expected") END
    END ;
    IF cdecl THEN typ.form := ORB.CRecord ELSE typ.form := ORB.Record END ; typ.dsc := bot; typ.size := (offset + 3) DIV 4 * 4; type := typ
  END RecordType;

  PROCEDURE FPSection(VAR adr: INTEGER; VAR nofpar: INTEGER; cdecl: BOOLEAN);
    VAR obj, first: ORB.Object; tp: ORB.Type;
      parsize: INTEGER; cl: INTEGER; rdo: BOOLEAN;
  BEGIN
    IF sym = ORS.var THEN ORS.Get(sym); cl := ORB.Par ELSE cl := ORB.Var END ;
    IdentList(cl, first); FormalType(tp, 0, cdecl); rdo := FALSE;
    IF (cl = ORB.Var) & (tp.form >= ORB.Array) THEN cl := ORB.Par; rdo := TRUE END ;
    IF ~cdecl & ((tp.form = ORB.Array) & (tp.len < 0) OR (tp.form = ORB.Record)) THEN
      parsize := 2 * ORG.WordSize  (* open array or record, needs second word for length or type tag *)
    ELSE parsize := ORG.WordSize
    END ;
    obj := first;
    WHILE obj # NIL DO
      INC(nofpar); obj.class := cl; obj.type := tp; obj.rdo := rdo; obj.lev := level; obj.val := adr;
      adr := adr + parsize; obj := obj.next
    END ;
    IF adr >= 52 THEN ORS.Mark("too many parameters") END
  END FPSection;

  PROCEDURE ProcedureType(ptype: ORB.Type; VAR parblksize: INTEGER; cdecl: BOOLEAN);
    VAR obj: ORB.Object; size: INTEGER; nofpar: INTEGER;
  BEGIN ptype.base := ORB.noType; size := parblksize; nofpar := 0; ptype.dsc := NIL;
    IF sym = ORS.lparen THEN
      ORS.Get(sym);
      IF sym = ORS.rparen THEN ORS.Get(sym)
      ELSE FPSection(size, nofpar, cdecl);
        WHILE sym = ORS.semicolon DO ORS.Get(sym); FPSection(size, nofpar, cdecl) END ;
        Check(ORS.rparen, ") expected")
      END ;
      IF sym = ORS.colon THEN  (* function *)
        ORS.Get(sym);
        IF sym = ORS.ident THEN
          qualident(obj); ptype.base := obj.type; 
          IF ~((obj.class = ORB.Typ) & (obj.type.form IN {ORB.Byte .. ORB.CPointer, ORB.Proc, ORB.CProc})) THEN
            ORS.Mark2("illegal function type: ", obj.name)
          END
        ELSE ORS.Mark("type identifier expected")
        END
      END
    END ;
    ptype.nofpar := nofpar; parblksize := size
  END ProcedureType;

  PROCEDURE FormalType0(VAR typ: ORB.Type; dim: INTEGER; cdecl: BOOLEAN);
    VAR 
      obj: ORB.Object; dmy: INTEGER; 
  BEGIN
    IF sym = ORS.ident THEN
      qualident(obj);
      IF obj.class = ORB.Typ THEN
        typ := obj.type;
        IF cdecl & (typ.form IN {ORB.Array, ORB.Proc, ORB.Record, ORB.Pointer}) THEN
          ORS.Mark2("type must be a CDECL qualified type: ", obj.name)
        END 
      ELSE 
        ORS.Mark2("not a type: ", obj.name); 
        typ := ORB.intType 
      END
    ELSIF sym = ORS.array THEN
      ORS.Get(sym); 
      cdecl := CheckForCDecl() OR cdecl;
      Check(ORS.of, "OF expected");
      IF dim >= 1 THEN ORS.Mark("multi-dimensional open arrays not implemented") END ;
      NEW(typ); 
      IF cdecl THEN typ.form := ORB.CArray; typ.size := ORG.WordSize
      ELSE typ.form := ORB.Array; typ.size := 2 * ORG.WordSize END ; 
      typ.len := -1;
      FormalType(typ.base, dim + 1, cdecl);
    ELSIF sym = ORS.procedure THEN
      ORS.Get(sym); ORB.OpenScope;
      cdecl := CheckForCDecl() OR cdecl;
      NEW(typ); 
      IF cdecl THEN typ.form := ORB.CProc ELSE typ.form := ORB.Proc END ;
      typ.size := ORG.WordSize; dmy := 0; ProcedureType(typ, dmy, cdecl);
      typ.dsc := ORB.topScope.next; ORB.CloseScope
    ELSE ORS.Mark("identifier expected"); typ := ORB.noType
    END
  END FormalType0;

  PROCEDURE CheckRecLevel(lev: INTEGER);
  BEGIN
    IF lev # 0 THEN ORS.Mark("ptr base must be global") END
  END CheckRecLevel;

  PROCEDURE Type0(VAR type: ORB.Type; cdecl: BOOLEAN);
    VAR 
      dmy: INTEGER; obj: ORB.Object; ptbase: PtrBase;
  BEGIN type := ORB.intType; (* sync *)
    IF (sym # ORS.ident) & (sym < ORS.array) THEN ORS.Mark("not a type");
      REPEAT ORS.Get(sym) UNTIL (sym = ORS.ident) OR (sym >= ORS.array)
    END ;
    IF sym = ORS.ident THEN
      qualident(obj);
      IF obj.class = ORB.Typ THEN
        IF (obj.type # NIL) & (obj.type.form # ORB.NoTyp) THEN type := obj.type END
      ELSE ORS.Mark("not a type or undefined")
      END
    ELSIF sym = ORS.array THEN ORS.Get(sym); ArrayType(type, cdecl)
    ELSIF sym = ORS.record THEN
      ORS.Get(sym); RecordType(type, cdecl); Check(ORS.end, "END expected")
    ELSIF sym = ORS.pointer THEN
      ORS.Get(sym); 
      cdecl := CheckForCDecl() OR cdecl;
      Check(ORS.to, "TO expected");
      NEW(type); IF cdecl THEN type.form := ORB.CPointer ELSE type.form := ORB.Pointer END ; 
      type.size := ORG.WordSize; type.base := ORB.intType;
      IF sym = ORS.ident THEN
        obj := ORB.thisObj();
        IF obj # NIL THEN
          IF cdecl THEN
            IF (obj.type.form IN {ORB.Array, ORB.Proc, ORB.Record, ORB.Pointer}) THEN
              ORS.Mark2("base type must be a CDECL qualified type: ", obj.name)
            ELSIF obj.class = ORB.Mod THEN ORS.Mark("external base type not implemented")
            END ;
            CheckRecLevel(obj.lev); type.base := obj.type
          ELSE
            IF (obj.class = ORB.Typ) & (obj.type.form IN {ORB.Record, ORB.CRecord, ORB.NoTyp}) THEN
              CheckRecLevel(obj.lev); type.base := obj.type
            ELSIF obj.class = ORB.Mod THEN ORS.Mark("external base type not implemented")
            ELSE ORS.Mark2("not a valid base type: ", obj.name)
            END
          END
        ELSE CheckRecLevel(level); (*enter into list of forward references to be fixed in Declarations*)
          NEW(ptbase); ORS.CopyId(ptbase.name); ptbase.type := type; ptbase.next := pbsList; pbsList := ptbase
        END ;
        ORS.Get(sym)
      ELSE Type(type.base, cdecl);
        IF ((type.base.form # ORB.Record) & (type.base.form # ORB.CRecord)) OR (type.base.typobj = NIL) THEN ORS.Mark("must point to named record") END ;
        CheckRecLevel(level)
      END
    ELSIF sym = ORS.procedure THEN
      ORS.Get(sym); ORB.OpenScope;
      cdecl := CheckForCDecl() OR cdecl;
      NEW(type); 
      IF cdecl THEN type.form := ORB.CProc ELSE type.form := ORB.Proc END ; 
      type.size := ORG.WordSize; dmy := 0;
      ProcedureType(type, dmy, cdecl); type.dsc := ORB.topScope.next; ORB.CloseScope
    ELSE ORS.Mark("illegal type")
    END
  END Type0;

  PROCEDURE Declarations(VAR varsize: INTEGER; cdecl: BOOLEAN);
    VAR obj, first: ORB.Object;
      x: ORG.Item; tp: ORB.Type; ptbase: PtrBase;
      expo: BOOLEAN; id: ORS.Ident;
  BEGIN (* sync *) pbsList := NIL;
    ORG.e("Declarations cdecl:"); ORG.eInt(ORD(cdecl));
    IF (sym < ORS.const) & (sym # ORS.end) & (sym # ORS.return) THEN ORS.Mark("declaration?");
      REPEAT ORS.Get(sym) UNTIL (sym >= ORS.const) OR (sym = ORS.end) OR (sym = ORS.return)
    END ;
    IF sym = ORS.const THEN
      ORS.Get(sym);
      WHILE sym = ORS.ident DO
        ORS.CopyId(id); ORS.Get(sym); CheckExport(expo);
        IF sym = ORS.eql THEN ORS.Get(sym) ELSE ORS.Mark("= expected") END ;
        expression(x);
        IF (x.type.form = ORB.String) & (x.b = 2) THEN ORG.StrToChar(x) END ;
        ORB.NewObj(obj, id, ORB.Const); obj.expo := expo;
        IF x.mode = ORB.Const THEN 
          obj.val := x.a; obj.lev := level; obj.type := x.type;
        ELSE ORS.Mark("expression not constant"); obj.type := ORB.intType
        END ;
        Check(ORS.semicolon, "; expected")
      END
    END ;
    IF sym = ORS.type THEN
      ORS.Get(sym);
      WHILE sym = ORS.ident DO
        ORS.CopyId(id); ORS.Get(sym); CheckExport(expo);
        IF sym = ORS.eql THEN ORS.Get(sym) ELSE ORS.Mark("= expected") END ;
        Type(tp, cdecl);
        ORB.NewObj(obj, id, ORB.Typ); obj.type := tp; obj.expo := expo; obj.lev := level;
        IF tp.typobj = NIL THEN tp.typobj := obj END ;
        IF expo & (obj.type.form  IN {ORB.Record, ORB.CRecord}) THEN obj.exno := exno; INC(exno) ELSE obj.exno := 0 END ;
        IF tp.form IN {ORB.Record, ORB.CRecord} THEN
          ptbase := pbsList;  (* check whether this is base of a pointer type; search and fixup *)
          WHILE ptbase # NIL DO
            IF obj.name = ptbase.name THEN 
              ptbase.type.base := obj.type;
              IF (ptbase.type.form = ORB.CPointer) & (tp.form = ORB.Record) THEN
                ORS.Mark2("base form must be a CDECL Record ", obj.name)
              END
            END ;
            ptbase := ptbase.next
          END ;
          IF level = 0 THEN ORG.BuildTD(tp, tdc) END    (*type descriptor; len used as its address*)
        END ;
        Check(ORS.semicolon, "; expected")
      END
    END ;
    IF (~cdecl) & (sym = ORS.var) THEN
      ORS.Get(sym);
      WHILE sym = ORS.ident DO
        IdentList(ORB.Var, first); Type(tp, FALSE);
        obj := first;
        WHILE obj # NIL DO
          obj.type := tp; obj.lev := level;
          IF tp.size > 1 THEN varsize := (varsize + 3) DIV 4 * 4 (*align*) END ;
          obj.val := varsize; varsize := varsize + obj.type.size;
          IF obj.expo THEN obj.exno := exno; INC(exno) END ;
          obj := obj.next
        END ;
        Check(ORS.semicolon, "; expected")
      END
    END ;
    varsize := (varsize + 3) DIV 4 * 4;
    ptbase := pbsList;
    WHILE ptbase # NIL DO
      IF ptbase.type.base.form = ORB.Int THEN ORS.Mark("undefined pointer base of") END ;
      ptbase := ptbase.next
    END ;
    IF (sym >= ORS.const) & (sym <= ORS.var) THEN ORS.Mark("declaration in bad order") END
  END Declarations;

  PROCEDURE ProcedureDecl(cdecl: BOOLEAN);
    VAR proc: ORB.Object;
      type: ORB.Type;
      procid: ORS.Ident;
      decl: ORS.Ident;
      x: ORG.Item;
      locblksize, parblksize: INTEGER;
      int: BOOLEAN;
      intLevel: INTEGER;
  BEGIN (* ProcedureDecl *) 
    ORG.e("ProcedureDecl cdecl:"); ORG.eInt(ORD(cdecl));
    int := FALSE; ORS.Get(sym); 
    IF sym = ORS.lbrak THEN ORS.Get(sym); 
      IF sym = ORS.int THEN
        int := TRUE; intLevel := ORS.ival; ORS.Get(sym);
      ELSIF sym = ORS.ident THEN
        ORS.CopyId(decl);
        IF decl = "CDECL" THEN cdecl := TRUE;
        ELSE ORS.Mark("CDECL expected") END ;
        ORS.Get(sym)
      ELSE ORS.Mark("Interrupt Level or CDECL expected"); intLevel := 0
      END ;
      Check(ORS.rbrak, "] expected");
    END ;
    IF sym = ORS.ident THEN
      ORS.CopyId(procid); ORS.Get(sym);
      ORB.NewObj(proc, ORS.id, ORB.Const);
      IF int THEN parblksize := 0 (* to be defined *) ELSE parblksize := 0 END ;
      NEW(type); 
      IF cdecl THEN type.form := ORB.CProc ELSE type.form := ORB.Proc END ; 
      type.size := ORG.WordSize;
      proc.type := type; proc.val := -1; proc.lev := level; 
      CheckExport(proc.expo);
      IF proc.expo THEN proc.exno := exno; INC(exno) END ;
      ORB.OpenScope; INC(level); type.base := ORB.noType;
      ProcedureType(type, parblksize, cdecl);  (* formal parameter list *)
      IF cdecl THEN proc.type.dsc := ORB.topScope.next; ORB.CloseScope; DEC(level);
      ELSE
        Check(ORS.semicolon, "; expected");
        locblksize := parblksize; Declarations(locblksize, FALSE);
        proc.type.dsc := ORB.topScope.next;
        IF sym = ORS.procedure THEN
          REPEAT ProcedureDecl(FALSE); Check(ORS.semicolon, "; expected") UNTIL sym # ORS.procedure;
          proc.type.dsc := ORB.topScope.next
        END ;
        ORG.Enter(procid, proc.expo, parblksize, locblksize, int);
        IF sym = ORS.begin THEN ORS.Get(sym); StatSequence END ;
        IF sym = ORS.return THEN
          ORS.Get(sym); expression(x);
              (* 
              Out.Ln; Out.String("--> type.base.form: "); Out.Int(type.base.form, 0);
              Out.Ln; Out.String("--> x.type.form: "); Out.Int(x.type.form, 0); *)
          IF type.base = ORB.noType THEN ORS.Mark("this is not a function")
          ELSIF ~CompTypes(type.base, x.type, FALSE) THEN 
            IF (type.base.form = ORB.Char) & (x.type.form = ORB.String) & (x.b = 2) THEN
              ORG.StrToChar(x);
            ELSIF (type.base.form # x.type.form) OR  (type.base.size <= x.type.size) THEN
              ORS.Mark("wrong result type");
              (* 
              Out.Ln; Out.String("--> type.base.form: "); Out.Int(type.base.form, 0);
              Out.Ln; Out.String("--> x.type.form: "); Out.Int(x.type.form, 0); *)
            END
          END
        ELSIF type.base.form # ORB.NoTyp THEN
          ORS.Mark("function without result"); type.base := ORB.noType
        END ;
        ORG.Return(procid, type, x, locblksize, int, intLevel);
        ORB.CloseScope; DEC(level); Check(ORS.end, "END expected");
        IF sym = ORS.ident THEN
          IF ORS.id # procid THEN ORS.Mark("no match") END ;
          ORS.Get(sym)
        ELSE ORS.Mark("no proc id")
        END
      END
    ELSE ORS.Mark("proc id expected")
    END
  END ProcedureDecl;

  PROCEDURE ImportList;
    VAR impid, impid1: ORS.Ident;
  BEGIN
    REPEAT 
      ORS.Get(sym);
      IF sym = ORS.ident THEN
        ORS.CopyId(impid); ORS.Get(sym);
        IF sym = ORS.becomes THEN
          ORS.Get(sym);
          IF sym = ORS.ident THEN ORS.CopyId(impid1); ORS.Get(sym)
          ELSE ORS.Mark("id expected"); impid1 := impid
          END
        ELSE impid1 := impid
        END ;
        ORB.Import(impid, impid1)
      ELSE ORS.Mark("id expected")
      END
    UNTIL sym # ORS.comma
  END ImportList;

  PROCEDURE Assembler(moduleId: ORS.Ident; outputFolder: ARRAY OF CHAR);
    VAR 
      inFile, outFile: ARRAY 256 OF CHAR;
      i : INTEGER;
  BEGIN
    ORB.MakeFileName(inFile,  outputFolder, moduleId, ".S");
    IF objectFileName[0] = 0X THEN i := 0; 
      ORB.MakeFileName(outFile, outputFolder, moduleId, ".o");
    ELSE
      ORB.MakeFileName(outFile, outputFolder, objectFileName, "");
    END ;
    i := SYS.Assembler(inFile, outFile);
    IF i # 0 THEN ORS.Mark("There is some assembler error.") END
  END Assembler;

  PROCEDURE Module(verbose : BOOLEAN);
    VAR
      key: INTEGER;
      cdecl: BOOLEAN;
  BEGIN 
    IF verbose THEN Out.String("  compiling ") END ;
    ORS.Get(sym);
    IF sym = ORS.module THEN
      ORS.Get(sym);
      dc := 0; tdc := 0;
      ORB.Init(importPath); ORB.OpenScope;
      cdecl := CheckForCDecl();
      IF cdecl THEN ORG.e("CModule ") END ;
      IF sym = ORS.ident THEN
        ORS.CopyId(modid); ORS.Get(sym);
        IF verbose THEN Out.String(modid) END
      ELSE ORS.Mark("identifier expected")
      END ;
      Check(ORS.semicolon, "; expected"); level := 0; exno := 1; key := 0;
      IF sym = ORS.import THEN ImportList; Check(ORS.semicolon, "; expected") END ;
      ORG.Open(modid); Declarations(dc, cdecl); ORG.SetDataSize((dc + 3) DIV 4 * 4);
      WHILE sym = ORS.procedure DO ProcedureDecl(cdecl); Check(ORS.semicolon, "; expected") END ;
      IF ~cdecl THEN
        ORG.Header;
        IF sym = ORS.begin THEN ORS.Get(sym); StatSequence END
      END ;
      Check(ORS.end, "END expected");
      IF sym = ORS.ident THEN
        IF ORS.id # modid THEN ORS.Mark("no match") END ;
        ORS.Get(sym)
      ELSE ORS.Mark("identifier missing")
      END ;
      IF sym # ORS.period THEN 
        ORS.Mark("period missing")
      END ;
      IF ORS.errcnt = 0 THEN
        ORB.Export(modid, newSF, key, cdecl, outputFolder);
        IF newSF & verbose THEN Out.String(" new symbol file") END
      END ;
      IF DEBUG OR (ORS.errcnt = 0) THEN
        ORG.Close(modid, key, exno, outputFolder, cdecl);
        IF ORS.errcnt = 0 THEN Assembler(modid, outputFolder) END ;
        IF verbose THEN Out.Int(dc, 6); Out.Hex(key) END
      END ;
      IF ORS.errcnt # 0 THEN 
        Out.Ln; Out.String("compilation FAILED; "); 
        Out.Int(ORS.errcnt,0); Out.String(" error(s) detected.");
      END ;
      IF verbose THEN Out.Ln END ;
      ORB.CloseScope; pbsList := NIL
    ELSE ORS.Mark("must start with MODULE")
    END ;
  END Module;

  PROCEDURE ExtractFolder(VAR folder: ARRAY OF CHAR; filename: ARRAY OF CHAR);
    VAR i, j: INTEGER;
  BEGIN 
    i := 0;
    WHILE (i < LEN(filename)) & (filename[i] # 0X) DO INC(i) END ;
    WHILE (i >= 0) & (filename[i] # "/") DO DEC(i) END ;
    j := 0;
    WHILE (j < i) DO folder[j] := filename[j]; INC(j) END ;
    folder[j] := 0X;
  END ExtractFolder;

  PROCEDURE ExtractExtension(VAR ext: ARRAY OF CHAR; filename: ARRAY OF CHAR);
    VAR i, j: INTEGER;
  BEGIN 
    i := 0;
    WHILE (i < LEN(filename)) & (filename[i] # 0X) DO INC(i) END ;
    WHILE (i >= 0) & (filename[i] # ".") DO DEC(i) END ;
    j := 0;
    WHILE (i < LEN(filename)) & (filename[i] # 0X) & (j < 9) DO ext[j] := filename[i]; INC(j); INC(i) END ;
    ext[j] := 0X;
  END ExtractExtension;
  
  PROCEDURE Compile*(filename : ARRAY OF CHAR; 
                     overrideSymbolFile,
                     generateCheckCode,
                     regOptimization,
                     regOptList,
                     verbose,
                     sourceToAssembly : BOOLEAN;
                     outFolder, impPath, objName : ARRAY OF CHAR);
    VAR (* beg, end, time: INTEGER; *)
      T: Texts.Text;
      (*S: Texts.Scanner; *)
  BEGIN 
    IF verbose THEN
      Out.Ln; Out.String("ESP32 Oberon-07 Compiler Version ");
      Out.String(Config.CompilerVersion)
    END ;
    newSF := overrideSymbolFile;

    outputFolder := outFolder;
    importPath := impPath;
    objectFileName := objName;
    
    ExtractFolder(sourceFolder, filename);
    ExtractExtension(fileExtension, filename);

    NEW(T);
    Texts.Open(T, filename);
    IF T.len > 0 THEN 
      ORG.Init(generateCheckCode, sourceToAssembly, regOptimization, regOptList);
      ORS.Init(T, 0);
      Module(verbose);
      IF ORS.errcnt # 0 THEN Out.Ln; SYS.Exit(1) END
    ELSE
      Out.Ln;  Out.String(filename); Out.String(" not found");
      SYS.Exit(1)
    END
  END Compile;

BEGIN 
  NEW(dummy); dummy.class := ORB.Var; dummy.type := ORB.intType;
  expression := expression0; Type := Type0; FormalType := FormalType0
END ORP.
