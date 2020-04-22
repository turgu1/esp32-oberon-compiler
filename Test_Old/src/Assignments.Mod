MODULE Assignments;
  IMPORT T := Test, Out;

  VAR
    i: INTEGER;
    j: INTEGER;
    r: REAL;
    s: SET;
    a: ARRAY 10 OF INTEGER;
    t: ARRAY 20 OF CHAR;
    b,c: BOOLEAN;
    k, ret: INTEGER;
    rec: RECORD i: INTEGER; b: BOOLEAN END;

  PROCEDURE ProcTests(VAR i: INTEGER; r: REAL): INTEGER;
    VAR a: INTEGER;
  BEGIN
    a := FLOOR(r);
    i := i + 1;
    RETURN a + i
  END ProcTests;

  PROCEDURE Run*;
  BEGIN
    Out.String("Assignments: "); Out.Flush;

    (* Operations *)
    
    T.First("A"); i     := 25;
    T.Next;       r     := 3.0;
    T.Next;       s     := {1, 2, 3};
    T.Next;       a[7]  := 31;
    T.Next;       t     := "This is a test";
    T.Next;       b     := 3 < 5;
    T.Next;       c     := i > 30;
    T.Next;       rec.i := 21;
    T.Next;       rec.b := TRUE;
    T.Next;       k     := i;
    T.Next;       ret   := ProcTests(k, r);

    T.End;

    (* Verifications *)

    T.First("a"); T.Assert(i = 25,        "Integer Assignment");
    T.Next;       T.Assert(r = 3.0,       "Real Assignment");
    T.Next;       T.Assert(s = {1, 2, 3}, "Set Assignment");
    T.Next;       T.Assert(a[7] = 31,     "Array Assignment");
    T.Next;       T.Assert(t = "This is a test", "String Assignment");
    T.Next;       T.Assert(b,             "Boolean assignment");
    T.Next;       T.Assert(~c,            "Boolean False assignment");
    T.Next;       T.Assert(j = 0,         "Memory initialization");
    T.Next;       T.Assert(rec.i = 21,    "Record integer assignment");
    T.Next;       T.Assert(k = 26,        "Record boolean assignment");
    T.Next;       T.Assert(ret = 29,      "Record boolean assignment");
    T.Next;       T.Assert(rec.b,         "Record boolean assignment");
    
    (* The End *)

    T.End; Out.String(" End"); Out.Ln; Out.Flush;
  END Run;

BEGIN
  T.Register(Run)
END Assignments.
