MODULE Main;
  IMPORT SYSTEM, Kernel, Out, In, Watchdog;
  TYPE
    Rec1 = RECORD x: INTEGER END;
    Rec2 = RECORD y: INTEGER END;
    P1 = POINTER TO Rec1;
    P2 = POINTER TO Rec2;
  VAR 
    i: INTEGER;
    aa: ARRAY 6 OF CHAR;
    p: P1;
    proc: PROCEDURE ();

  PROCEDURE Check1;
    VAR 
      j: INTEGER;
      a: ARRAY 5 OF CHAR;
      i: CHAR;
  BEGIN
    j := 5;
    i := a[j];
  END Check1;

  PROCEDURE Check2;
    VAR 
      p1: P1;
      p2: P2;
      p3: P2;
      i: INTEGER;

    PROCEDURE Test(p: P2);
    VAR i: INTEGER;
    BEGIN
      i := p.y;
    END Test;

  BEGIN
    NEW(p1);
    i := SYSTEM.VAL(INTEGER, p1);
    p3 := SYSTEM.VAL(P2, i);
    Test(p3);
  END Check2;

  PROCEDURE Check3(a: ARRAY OF CHAR);
    VAR aa: ARRAY 5 OF CHAR;
  BEGIN
    aa := a;
  END Check3;

  PROCEDURE Check4;
    VAR 
      i: INTEGER;
  BEGIN
    i := p.x;
  END Check4;

  PROCEDURE Check5;
  VAR 
    i: INTEGER;
  BEGIN
    i := SYSTEM.VAL(INTEGER, proc);
    Out.Ln; Out.String("Proc: "); Out.Hex(i, 0);
    proc();
  END Check5;

  PROCEDURE Check6;
    VAR
      i, j: INTEGER;
  BEGIN
    j := 0;
    i := i DIV j;
  END Check6;

  PROCEDURE  Check7;
    VAR i: INTEGER;
  BEGIN
    i := 2;
    ASSERT(i = 0);
  END Check7;

  PROCEDURE Check8;
  BEGIN
    Watchdog.ShowRegs;
    (* Watchdog.Init;
    Watchdog.ShowRegs;
    Kernel.EnableWatchdog *)
  END Check8;

BEGIN
  Kernel.Init;

  WHILE TRUE DO
    Out.Ln;
    Out.String("> ");
    In.Int(i);
    IF In.Done THEN
      CASE i OF
        1: Check1 |
        2: Check2 |
        3: Check3(aa) |
        4: Check4 |
        5: proc := NIL; Check5 |
        6: Check6 |
        7: Check7 |
        8: Check8 
      END
    ELSE
      Out.String("[TimeOut]")
    END
  END
END Main.