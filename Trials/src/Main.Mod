MODULE Main;
  IMPORT Kernel, Out, In;
  VAR 
    a: ARRAY 120 OF CHAR;
    i: INTEGER;
BEGIN
  Kernel.Init;

  WHILE TRUE DO
    Out.Ln;
    Out.String("> ");
    In.Int(i);
    IF In.Done THEN
      Out.Int(i, 0)
    ELSE
      Out.String("[TimeOut]")
    END
  END
END Main.