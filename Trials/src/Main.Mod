MODULE Main;
  IMPORT SYSTEM, Out, Math;
  VAR r: REAL;
BEGIN
  r := Math.sqrt(25.0);
  Out.String("Value of sqrt(25.0): "); Out.Real(r, 15); Out.RealFix(r, 15, 8); Out.Ln;

  r := Math.exp(25.0);
  Out.String("Value of exp(25.0): "); Out.Real(r, 15); Out.RealFix(r, 15, 8); Out.Ln;

  r := Math.ln(25.0);
  Out.String("Value of ln(25.0): "); Out.Real(r, 15); Out.RealFix(r, 15, 8); Out.Ln;
  
  r := Math.sin(1.0);
  Out.String("Value of sin(1.0): "); Out.Real(r, 15); Out.RealFix(r, 15, 8); Out.Ln;

  r := Math.cos(1.0);
  Out.String("Value of cos(1.0): "); Out.Real(r, 15); Out.RealFix(r, 15, 8); Out.Ln;

  WHILE TRUE DO  END;
END Main.
