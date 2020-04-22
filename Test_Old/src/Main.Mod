MODULE Main;

IMPORT SYSTEM, Test, Out, Kernel;

VAR
  count : INTEGER;

PROCEDURE ShowStackAdr;
VAR
  adr : INTEGER;
BEGIN
  adr := SYSTEM.ADR(adr);
  Out.Ln; Out.String("Stack Address: "); Out.Hex(adr, 0); Out.Ln;
END ShowStackAdr;

BEGIN
  Kernel.Init;
  
  FOR count := 0 TO 100000 DO END;
  ShowStackAdr;
  Out.Ln;
  Out.String("ESP32 Oberon Compiler Test Suite."); Out.Ln; 

  count := Test.Exec();
  count := Test.Completed();
  
  Out.Ln; Out.Ln; Out.String("[The End]"); Out.Ln;

  WHILE TRUE DO 
    Out.Char("Z"); 
    FOR count := 0 TO 10000000 DO END;
  END
END Main.
