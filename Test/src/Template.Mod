MODULE T;
  IMPORT Test, Out;

  PROCEDURE Put(ch: CHAR);
  BEGIN
    Out.Char(ch); Out.Flush
  END Put;

  PROCEDURE Run*;
    VAR i: INTEGER;

  BEGIN
    Out.String("Template: "); Out.Flush;

    (* Operations *)

    Put("A"); i := 25;

    Put(".");

    (* Verifications *)

    Put("a"); Test.Assert(i = 25, "Integer Assignment");

    (* The End *)
    
    Put("."); Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  Test.Register(Run)
END T.