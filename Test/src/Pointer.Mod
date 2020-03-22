MODULE Pointer;
  IMPORT T := Test, Out;
  TYPE
    REC = RECORD i, j: INTEGER END;
  VAR 
    p : POINTER TO REC;

  PROCEDURE Run*;
    VAR i: INTEGER;
  BEGIN
    Out.String("Template: "); Out.Flush;

    (* Operations *)

    T.First("A"); 
    
    T.Assert(p = NIL, "p = NIL");
    NEW(p); 
 
    T.End;

    (* Verifications *)

    T.First("a"); 
    
    T.Assert(p # NIL, "NEW(p)");

    (* The End *)
    
    T.End; Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  T.Register(Run)
END Pointer.