MODULE Main;

IMPORT Out, Test;

VAR
  count : INTEGER;

BEGIN
  WHILE TRUE DO END;
  Out.Setup;

  Out.String("ESP32 Oberon Compiler Test Suite."); Out.Ln;
  Out.String("Start"); Out.Ln;

  count := Test.Exec();
  count := Test.Completed();
  
  Out.String("[The End]"); Out.Ln;
  WHILE TRUE DO END
END Main.
