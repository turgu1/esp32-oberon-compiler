MODULE Sample;
  IMPORT T.Test, Out;

  PROCEDURE Put(ch: CHAR);
  BEGIN
    Out.Char(ch); Out.Flush
  END Put;

  PROCEDURE Run*;
    VAR i: INTEGER;

  BEGIN
    Out.String("Template: "); Out.Flush;

    (* Operations *)

    T.First("A"); 
    
    i := 25;

    T.End;

    (* Verifications *)

    T.First("a"); 
    
    T.Assert(i = 25, "Integer Assignment");

    (* The End *)
    
    T.End; Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  T.Register(Run)
END Sample.