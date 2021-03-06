MODULE Byte;
  IMPORT SYSTEM, Out, T := Test;
  VAR x : INTEGER;
      y : BYTE;
      r : RECORD y : BYTE END;
      ar : ARRAY 1 OF BYTE;

  PROCEDURE P1(i : BYTE): INTEGER;
  BEGIN
    RETURN ORD(i) + 1
  END P1;

  PROCEDURE P2(i : INTEGER): BYTE;
  BEGIN
    RETURN SYSTEM.VAL(BYTE, i + 1)
  END P2;

  PROCEDURE P3(i: INTEGER): BYTE;
  BEGIN
    RETURN i
  END P3;

  PROCEDURE Par1(b : BYTE);
  BEGIN
    T.Assert(b = 128, "Byte parameter")
  END Par1;

  PROCEDURE Ret1(): BYTE;
  VAR b: BYTE;
  BEGIN
    b := 8;
    RETURN b
  END Ret1;

  PROCEDURE P4;
    VAR x : INTEGER;
      y : BYTE;
      r : RECORD y : BYTE END;
      ar : ARRAY 1 OF BYTE;
  BEGIN
    Out.String("BYTE operations on local variables: "); Out.Flush;

    T.First("A"); 
    
    T.Assert(P1(255) = 256, "Byte parameter to integer return");
    T.Assert(P2(256) = 1,   "Integer to byte transform");
    (* T.Assert(P3(258) = 2,   "Integer to byte return"); Not working *) 
    y := 255; x := 129; T.Assert((y = 255) & (x = 129), "Byte Const Assignments");
    x := y + 1;         T.Assert(x = 256,     "Byte to integer with arithmetic");
    x := y;             T.Assert(x = 255,     "Byte Variable assignment" );
    r.y := 255;         T.Assert(r.y = 255,   "Byte field Const Assignment");
    x := 129; r.y := x; T.Assert(r.y = 129,   "Byte field variable assignment");
    x := r.y + 1;       T.Assert(x   = 130,   "Byte field simple artithmetic");
    ar[0] := x;         T.Assert(ar[0] = 130, "To Byte array entry assignment");
    x := ar[0] + 1;     T.Assert(x = 131,     "Byte array simple arithmetic and assignment");
    x := ar[0];         T.Assert(x = 130,     "Byte array entry to variable assignment");
    y := x;             T.Assert(x = y,       "Byte equality");
    x := Ret1();        T.Assert(x = 8,       "Byte return value");
    Par1(128);
    T.End;
  END P4;

  PROCEDURE Run*;
  BEGIN
    P4;

    Out.String(" BYTE operations: "); Out.Flush;

    T.First("a"); 
    
    T.Assert(P1(255) = 256, "Byte parameter to integer return");
    T.Assert(P2(256) = 1,   "Integer to byte transform");
    (* T.Assert(P3(258) = 2,   "Integer to byte return"); Not working *) 
    y := 255; x := 129; T.Assert((y = 255) & (x = 129), "Byte Const Assignments");
    x := y + 1;         T.Assert(x = 256,     "Byte to integer with arithmetic");
    x := y;             T.Assert(x = 255,     "Byte Variable assignment" );
    r.y := 255;         T.Assert(r.y = 255,   "Byte field Const Assignment");
    x := 129; r.y := x; T.Assert(r.y = 129,   "Byte field variable assignment");
    x := r.y + 1;       T.Assert(x   = 130,   "Byte field simple artithmetic");
    ar[0] := x;         T.Assert(ar[0] = 130, "To Byte array entry assignment");
    x := ar[0] + 1;     T.Assert(x = 131,     "Byte array simple arithmetic and assignment");
    x := ar[0];         T.Assert(x = 130,     "Byte array entry to variable assignment");
    y := x;             T.Assert(x = y,       "Byte equality");
    x := Ret1();        T.Assert(x = 8,       "Byte return value");
    Par1(128);

    T.End; Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  T.Register(Run)
END Byte.
