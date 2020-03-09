MODULE Main;
  IMPORT SYSTEM, Kernel, Out;

  CONST 
    VECBASE   =     231;
    OneSecond = 10000000;
  TYPE
    rec = RECORD a, b, c: INTEGER END;
  VAR 
    i: INTEGER;
    time: Kernel.ClockTime;
    

BEGIN
  Kernel.Init;
  
  Out.String("ALLO!!!"); Out.Ln; Out.Flush;
  i := SYSTEM.RSR(VECBASE);
  Out.String("Vector base: "); Out.Hex(i,0); Out.Ln;

  WHILE TRUE DO
    Kernel.Wait(10 * OneSecond);
    Out.Char("Z");
  END;
END Main.
