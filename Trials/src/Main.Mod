MODULE Main;
  IMPORT SYSTEM, Kernel, Out;
  TYPE 
    R = RECORD i, j: INTEGER END;
    P = POINTER TO R;
  VAR 
    i: INTEGER;
    p: P;

BEGIN
  Kernel.Init;

  (* NEW(p); *)

  WHILE TRUE DO
    FOR i := 15 TO 0 BY -1 DO
      Out.Char(0DX); Out.String("... "); Out.Int(i, 0); Out.Char(" "); 
      Kernel.Wait(1000000);
    END;
    NEW(p);
    Out.Ln;
  END;

  WHILE TRUE DO  END;
END Main.
