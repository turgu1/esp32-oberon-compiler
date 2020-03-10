MODULE TestConstFunc;
  IMPORT Out;
  IMPORT SYSTEM;
  CONST
    negReal = -2.5;
    posReal = 3.2;
    posInt = 2;
    a = "A";
    intA = 65;
    abs = ABS(negReal);
    odd = ODD(posInt);
    floor = FLOOR(posReal);
    flt = FLT(posInt);
    ord = ORD(a);
    chr = CHR(intA);
    lsl = LSL(intA, posInt);
    asr = ASR(intA, posInt);
    ror = ROR(intA, posInt);
    and = AND(intA, posInt);
    bor = BOR(intA, posInt);
    not = NOT(intA);
    set = {5};
    int = SYSTEM.VAL(INTEGER, set);
  TYPE arr5 = ARRAY 5 OF INTEGER;
       ARR = ARRAY 3 OF INTEGER;
  VAR
    r: REAL; i, j: INTEGER; c: CHAR;
    z: ARRAY 5 OF INTEGER; s: SET;
    y: ARRAY 4 OF ARR;

  PROCEDURE WriteBool(b: BOOLEAN);
  BEGIN
    Out.Int(ORD(b))
  END WriteBool;

  PROCEDURE LenP(a0: ARRAY OF INTEGER; a1: arr5; VAR a2: ARRAY OF ARR);
    CONST
       (* len0 = LEN(a0); ERROR expression not constant *)
       len1 = LEN(a1);
       len2 = LEN(a2[0]);
       len3 = AND(LEN(a2[0]), 1);
     VAR u: INTEGER;
  BEGIN
    u := 1;
    a2[0][u] := 1;
    Out.Int(len1); Out.Int(LEN(a1));
    Out.Int(len2); Out.Int(LEN(a2[0]));
    Out.Int(len3);  Out.Int(AND(LEN(a2[0]), a2[0][u]))
  END LenP;


  PROCEDURE P;
    CONST
      negReal = -2.5;
      posReal = 3.2;
      posInt = 2;
      a = "A";
      intA = 65;
      abs = ABS(negReal);
      odd = ODD(posInt);
      floor = FLOOR(posReal);
      flt = FLT(posInt);
      ord = ORD(a);
      chr = CHR(intA);
      lsl = LSL(intA, posInt);
      asr = ASR(intA, posInt);
      ror = ROR(intA, posInt);
      and = AND(intA, posInt);
      bor = BOR(intA, posInt);
      not = NOT(intA);
      set = {5};
      int = SYSTEM.VAL(INTEGER, set);
    TYPE arr5 = ARRAY 5 OF INTEGER;
         ARR = ARRAY 3 OF INTEGER;
    VAR
      r: REAL; i, j: INTEGER; c: CHAR;
      z: ARRAY 5 OF INTEGER; s: SET;
      y: ARRAY 4 OF ARR;
    BEGIN
      r := negReal;
      Out.Real(abs); Out.Real(ABS(r)); Out.Ln;
      i := posInt;
      WriteBool(odd); WriteBool(ODD(i)); Out.Ln;
      r := posReal;
      Out.Int(floor); Out.Int(FLOOR(r)); Out.Ln;
      i := posInt;
      Out.Real(flt); Out.Real(FLT(i)); Out.Ln;
      c := a;
      Out.Int(ord); Out.Int(ORD(c)); Out.Ln;
      i := intA;
      Out.Char(chr); Out.Char(CHR(i)); Out.Ln;
      LenP(z, z, y); Out.Ln;
      i := intA;
      j := posInt;
      Out.Int(lsl); Out.Int(LSL(i, j)); Out.Ln;
      Out.Int(asr); Out.Int(ASR(i, j)); Out.Ln;
      Out.Int(ror); Out.Int(ROR(i, j)); Out.Ln;
      Out.Int(and); Out.Int(AND(i, j)); Out.Ln;
      Out.Int(bor); Out.Int(BOR(i, j)); Out.Ln;
      Out.Int(not); Out.Int(NOT(i)); Out.Ln;
      s := set;
      Out.Int(int); Out.Int(SYSTEM.VAL(INTEGER, s)); Out.Ln;
  END P;

BEGIN
  r := negReal;
  Out.Real(abs); Out.Real(ABS(r)); Out.Ln;
  i := posInt;
  WriteBool(odd); WriteBool(ODD(i)); Out.Ln;
  r := posReal;
  Out.Int(floor); Out.Int(FLOOR(r)); Out.Ln;
  i := posInt;
  Out.Real(flt); Out.Real(FLT(i)); Out.Ln;
  c := a;
  Out.Int(ord); Out.Int(ORD(c)); Out.Ln;
  i := intA;
  Out.Char(chr); Out.Char(CHR(i)); Out.Ln;
  LenP(z, z, y); Out.Ln;
  i := intA;
  j := posInt;
  Out.Int(lsl); Out.Int(LSL(i, j)); Out.Ln;
  Out.Int(asr); Out.Int(ASR(i, j)); Out.Ln;
  Out.Int(ror); Out.Int(ROR(i, j)); Out.Ln;
  Out.Int(and); Out.Int(AND(i, j)); Out.Ln;
  Out.Int(bor); Out.Int(BOR(i, j)); Out.Ln;
  Out.Int(not); Out.Int(NOT(i)); Out.Ln;
  s := set;
  Out.Int(int); Out.Int(SYSTEM.VAL(INTEGER, s)); Out.Ln;
  P
END TestConstFunc.