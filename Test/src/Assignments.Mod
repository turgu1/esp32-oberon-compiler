MODULE Assignments;
IMPORT Test;

VAR
  i: INTEGER;
  j: INTEGER;
  r: REAL;
  s: SET;
  a: ARRAY 10 OF INTEGER;
  t: ARRAY 20 OF CHAR;
  b,c: BOOLEAN;
  rec: RECORD i: INTEGER; b: BOOLEAN END;

PROCEDURE Run;
BEGIN
  i := 25;
  r := 3.0;
  s := {1, 2, 3};
  a[7] := 31;
  t := "This is a test";
  b := 3 < 5;
  c := i > 30;
  rec.i := 21;
  rec.b := TRUE;

  Test.Assert(i = 25,        "Integer Assignment");
  Test.Assert(r = 3.0,       "Real Assignment");
  Test.Assert(s = {1, 2, 3}, "Set Assignment");
  Test.Assert(a[7] = 31,     "Array Assignment");
  Test.Assert(t =            "This is a test", "String Assignment");
  Test.Assert(b,             "Boolean assignment");
  Test.Assert(~c,            "Boolean False assignment");
  Test.Assert(j = 0,         "Memory initialization");
  Test.Assert(rec.i = 21,    "Record integer assignment");
  Test.Assert(rec.b,         "Record boolean assignment");
END Run;

BEGIN
  (*Test.Register(Run)*)
END Assignments.
