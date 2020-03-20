MODULE TestConstFunc;
  IMPORT Out, SYSTEM;
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
    Out.Int(ORD(b), 10)
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
    Out.Int(len1, 10); Out.Int(LEN(a1), 10);
    Out.Int(len2, 10); Out.Int(LEN(a2[0]), 10);
    Out.Int(len3, 10);  Out.Int(AND(LEN(a2[0]), a2[0][u]), 10)
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
      Out.Real(abs, 10); Out.Real(ABS(r), 10); Out.Ln;
      i := posInt;
      WriteBool(odd); WriteBool(ODD(i)); Out.Ln;
      r := posReal;
      Out.Int(floor, 10); Out.Int(FLOOR(r), 10); Out.Ln;
      i := posInt;
      Out.Real(flt, 10); Out.Real(FLT(i), 10); Out.Ln;
      c := a;
      Out.Int(ord, 10); Out.Int(ORD(c), 10); Out.Ln;
      i := intA;
      Out.Char(chr); Out.Char(CHR(i)); Out.Ln;
      (* LenP(z, z, y); Out.Ln; *)
      i := intA;
      j := posInt;
      Out.Int(lsl, 10); Out.Int(LSL(i, j), 10); Out.Ln;
      Out.Int(asr, 10); Out.Int(ASR(i, j), 10); Out.Ln;
      Out.Int(ror, 10); Out.Int(ROR(i, j), 10); Out.Ln;
      Out.Int(and, 10); Out.Int(AND(i, j), 10); Out.Ln;
      Out.Int(bor, 10); Out.Int(BOR(i, j), 10); Out.Ln;
      Out.Int(not, 10); Out.Int(NOT(i), 10); Out.Ln;
      s := set;
      Out.Int(int, 10); Out.Int(SYSTEM.VAL(INTEGER, s), 10); Out.Ln;
  END P;

BEGIN
  r := negReal;
  Out.Real(abs, 10); Out.Real(ABS(r), 10); Out.Ln;
  i := posInt;
  WriteBool(odd); WriteBool(ODD(i)); Out.Ln;
  r := posReal;
  Out.Int(floor, 10); Out.Int(FLOOR(r), 10); Out.Ln;
  i := posInt;
  Out.Real(flt, 10); Out.Real(FLT(i), 10); Out.Ln;
  c := a;
  Out.Int(ord, 10); Out.Int(ORD(c), 10); Out.Ln;
  i := intA;
  Out.Char(chr); Out.Char(CHR(i)); Out.Ln;
  LenP(z, z, y); Out.Ln;
  i := intA;
  j := posInt;
  Out.Int(lsl, 10); Out.Int(LSL(i, j), 10); Out.Ln;
  Out.Int(asr, 10); Out.Int(ASR(i, j), 10); Out.Ln;
  Out.Int(ror, 10); Out.Int(ROR(i, j), 10); Out.Ln;
  Out.Int(and, 10); Out.Int(AND(i, j), 10); Out.Ln;
  Out.Int(bor, 10); Out.Int(BOR(i, j), 10); Out.Ln;
  Out.Int(not, 10); Out.Int(NOT(i), 10); Out.Ln;
  s := set;
  Out.Int(int, 10); Out.Int(SYSTEM.VAL(INTEGER, s), 10); Out.Ln;
  P
END TestConstFunc.