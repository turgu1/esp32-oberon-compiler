MODULE Main;
  IMPORT SYSTEM, Kernel, Out;

  CONST VECBASE = 231;
  TYPE
    rec = RECORD a, b, c: INTEGER END;
  VAR 
    i: INTEGER;
    r: rec;
    time: Kernel.ClockTime;
    

BEGIN
  Kernel.Init;
  
  Out.String("ALLO!!!"); Out.Ln; Out.Flush;
  i := SYSTEM.RSR(VECBASE);
  Out.String("Vector base: "); Out.Hex(i,0); Out.Ln;

  r.a := 3;

  FOR i := 0 TO 100000 DO END;
  
  Kernel.Time(time);
  Out.String("System time: ");
  Out.Hex(time.high,  9);
  Out.Hex(time.low,   8);
  Out.Ln;

  FOR i := 0 TO 100000 DO END;
  
  Kernel.Time(time);
  Out.String("System time: ");
  Out.Hex(time.high,  9);
  Out.Hex(time.low,   8);
  Out.Ln;

  WHILE TRUE DO END;
END Main.
