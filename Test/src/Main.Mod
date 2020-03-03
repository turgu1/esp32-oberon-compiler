MODULE Main;

IMPORT Out, Test;

VAR
  count : INTEGER;

BEGIN
  Out.Setup;

  Out.String("ESP32 Oberon Compiler Test Suite."); Out.Ln;
  Out.String("Start"); Out.Ln;

  count := Test.Exec();
  count := Test.Completed();

  WHILE TRUE DO END
END Main.
