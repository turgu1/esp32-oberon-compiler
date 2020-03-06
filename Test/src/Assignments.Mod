MODULE Assignments;
IMPORT Test, Out;

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

PROCEDURE Put(ch: CHAR);
BEGIN
  Out.Char(ch); (* Out.Flush *)
END Put;

PROCEDURE ProcTests(VAR i: INTEGER; r: REAL): INTEGER;
VAR a: INTEGER;
BEGIN
  a := FLOOR(r);
  i := i + 1;
  RETURN a + i
END ProcTests;

PROCEDURE Run*;
BEGIN
  Out.String("Assignments: ");

  Put("A"); i     := 25;
  Put("B"); r     := 3.0;
  Put("C"); s     := {1, 2, 3};
  Put("D"); a[7]  := 31;
  Put("E"); t     := "This is a test";
  Put("F"); b     := 3 < 5;
  Put("G"); c     := i > 30;
  Put("H"); rec.i := 21;
  Put("I"); rec.b := TRUE;

  Put("J"); k     := i;
  Put("K"); ret   := ProcTests(k, r);

  Put(".");

  Put("a"); Test.Assert(i = 25,        "Integer Assignment");
  Put("b"); Test.Assert(r = 3.0,       "Real Assignment");
  Put("c"); Test.Assert(s = {1, 2, 3}, "Set Assignment");
  Put("d"); Test.Assert(a[7] = 31,     "Array Assignment");
  Put("e"); Test.Assert(t = "This is a test", "String Assignment");
  Put("f"); Test.Assert(b,             "Boolean assignment");
  Put("g"); Test.Assert(~c,            "Boolean False assignment");
  Put("h"); Test.Assert(j = 0,         "Memory initialization");
  Put("j"); Test.Assert(rec.i = 21,    "Record integer assignment");
  Put("k"); Test.Assert(k = 26,        "Record boolean assignment");
  Put("l"); Test.Assert(ret = 29,      "Record boolean assignment");
  Put("m"); Test.Assert(rec.b,         "Record boolean assignment");
  
  Put(".");

  Out.String(" End"); Out.Ln;
END Run;

BEGIN
  Test.Register(Run)
END Assignments.
