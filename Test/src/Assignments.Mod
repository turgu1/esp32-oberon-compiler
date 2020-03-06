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
  rec: RECORD i: INTEGER; b: BOOLEAN END;

PROCEDURE Put(ch: CHAR);
BEGIN
  Out.Char(ch); (* Out.Flush *)
END Put;

PROCEDURE Run*;
BEGIN
  Out.String("Assignments: ");

  Put("1"); i := 25;
  (* Put("2"); *) r := 3.0;
  (* Put("3"); *) s := {1, 2, 3};
  (* Put("4"); *) a[7] := 31;
  (* Put("5"); *) t := "This is a test";
  (* Put("6"); *) b := 3 < 5;
  (* Put("7"); *) c := i > 30;
  (* Put("8"); *) rec.i := 21;
  (* Put("9"); *) rec.b := TRUE;

  (* Put("."); *)
  Put(">");
  (* Put("A"); *) Test.Assert(i = 25,        "Integer Assignment");
  (* Put("B"); *) Test.Assert(r = 3.0,       "Real Assignment");
  (* Put("C"); *) Test.Assert(s = {1, 2, 3}, "Set Assignment");
  (* Put("D"); *) Test.Assert(a[7] = 31,     "Array Assignment");
  (* Put("E"); *) Test.Assert(t = "This is a test", "String Assignment");
  (* Put("F"); *) Test.Assert(b,             "Boolean assignment");
  (* Put("G"); *) Test.Assert(~c,            "Boolean False assignment");
  (* Put("H"); *) Test.Assert(j = 0,         "Memory initialization");
  (* Put("I"); *) Test.Assert(rec.i = 21,    "Record integer assignment");
  (* Put("J"); *) Test.Assert(rec.b,         "Record boolean assignment");
  (* Put("."); *)

  Out.String(" End"); Out.Ln;
END Run;

BEGIN
  Test.Register(Run)
END Assignments.
