MODULE ShortInt;
  IMPORT SYSTEM, Out, T := Test;
  VAR x : INTEGER;
      y : SHORTINT;
      r : RECORD y : SHORTINT END;
      ar : ARRAY 1 OF SHORTINT;

  PROCEDURE P1(i : SHORTINT): INTEGER;
  BEGIN
    RETURN ORD(i) + 1
  END P1;

  PROCEDURE P2(i : INTEGER): SHORTINT;
  BEGIN
    RETURN SYSTEM.VAL(SHORTINT, i + 1)
  END P2;

  PROCEDURE P3(i: INTEGER): SHORTINT;
  BEGIN
    RETURN i
  END P3;

  PROCEDURE Par1(b : SHORTINT);
  BEGIN
    T.Assert(b = 258, "ShortInt parameter")
  END Par1;

  PROCEDURE Ret1(): SHORTINT;
  VAR b: SHORTINT;
  BEGIN
    b := 337;
    RETURN b
  END Ret1;

  PROCEDURE P4;
    VAR x : INTEGER;
      y : SHORTINT;
      r : RECORD y : SHORTINT END;
      ar : ARRAY 1 OF SHORTINT;
  BEGIN
    Out.String("SHORTINT operations on local variables: "); Out.Flush;

    T.First("A"); 
    
    T.Assert(P1(65535) = 65536, "ShortInt parameter to integer return");
    T.Assert(P2(65536) = 1,   "Integer to byte transform");
    (* T.Assert(P3(258) = 2,   "Integer to byte return"); Not working *) 
    y := 65535; x := 129; T.Assert((y = 65535) & (x = 129), "ShortInt Const Assignments");
    x := y + 1;         T.Assert(x = 65536,   "ShortInt to integer with arithmetic");
    x := y;             T.Assert(x = 65535,   "ShortInt Variable assignment" );
    r.y := 65535;       T.Assert(r.y = 65535, "ShortInt field Const Assignment");
    x := 129; r.y := x; T.Assert(r.y = 129,   "ShortInt field variable assignment");
    x := r.y + 1;       T.Assert(x   = 130,   "ShortInt field simple artithmetic");
    ar[0] := x;         T.Assert(ar[0] = 130, "To ShortInt array entry assignment");
    x := ar[0] + 1;     T.Assert(x = 131,     "ShortInt array simple arithmetic and assignment");
    x := ar[0];         T.Assert(x = 130,     "ShortInt array entry to variable assignment");
    y := x;             T.Assert(x = y,       "ShortInt equality");
    x := Ret1();        T.Assert(x = 337,     "ShortInt return value");
    Par1(258);
    T.End;
  END P4;

  PROCEDURE Run*;
  BEGIN
    P4;

    Out.String(" SHORTINT operations: "); Out.Flush;

    T.First("a"); 
    
    T.Assert(P1(65535) = 65536, "ShortInt parameter to integer return");
    T.Assert(P2(65536) = 1,     "Integer to ShortInt transform");
    (* T.Assert(P3(65538) = 2,   "Integer to ShortInt return"); Not working *) 
    y := 65535; x := 129; T.Assert((y = 65535) & (x = 129), "ShortInt Const Assignments");
    x := y + 1;         T.Assert(x = 65536,   "ShortInt to integer with arithmetic");
    x := y;             T.Assert(x = 65535,   "ShortInt Variable assignment" );
    r.y := 65535;       T.Assert(r.y = 65535, "ShortInt field Const Assignment");
    x := 129; r.y := x; T.Assert(r.y = 129,   "ShortInt field variable assignment");
    x := r.y + 1;       T.Assert(x   = 130,   "ShortInt field simple artithmetic");
    ar[0] := x;         T.Assert(ar[0] = 130, "To ShortInt array entry assignment");
    x := ar[0] + 1;     T.Assert(x = 131,     "ShortInt array simple arithmetic and assignment");
    x := ar[0];         T.Assert(x = 130,     "ShortInt array entry to variable assignment");
    y := x;             T.Assert(x = y,       "ShortInt equality");
    x := Ret1();        T.Assert(x = 337,     "ShortInt return value");
    Par1(258);

    T.End; Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  T.Register(Run)
END ShortInt.
