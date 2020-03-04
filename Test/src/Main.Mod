MODULE Main;

IMPORT Out;

VAR
  count : INTEGER;

BEGIN
  FOR count := 0 TO 10000000 DO END;
  Out.String("ESP32 Oberon Compiler Test Suite."); Out.Ln; 
  Out.String("Start"); Out.Ln;
(*)
  count := Test.Exec();
  count := Test.Completed();
  
  Out.String("[The End]"); Out.Ln;
  *)

  WHILE TRUE DO 
    Out.Char("Z"); 
    Out.Char("l"); 
    Out.Char("o"); 
    Out.Char("o"); 
    Out.Char("b"); 
    Out.Char("o"); 
    Out.Char("o"); 
    Out.Char("k"); 
    Out.Ln;
    FOR count := 0 TO 10000000 DO END;
  END
END Main.
