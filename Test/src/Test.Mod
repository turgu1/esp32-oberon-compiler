MODULE Test;

  IMPORT Out;

  CONST 
    MaxTestProc = 200;

  TYPE
    TestProc* = PROCEDURE ();

  VAR
    errorCount: INTEGER;
    registry: ARRAY MaxTestProc OF TestProc;
    registryCount: INTEGER;

  PROCEDURE Register*(proc: TestProc);
  BEGIN
    IF registryCount < (MaxTestProc - 1) THEN
      registry[registryCount] := proc;
      INC(registryCount)
    END
  END Register;

  PROCEDURE Exec*() : INTEGER;
  VAR
    i : INTEGER;
  BEGIN
    errorCount := 0;
    FOR i := 0 TO registryCount - 1 DO
      registry[i]();
    END;
    RETURN errorCount
  END Exec;

  PROCEDURE Assert*(cond: BOOLEAN; msg: ARRAY OF CHAR);
  BEGIN
    IF ~cond THEN
      Out.String(msg);
      Out.Ln;
      INC(errorCount)
    END
  END Assert;

  PROCEDURE Completed*(): INTEGER;
  BEGIN
    Out.String("Test Completed. ");
    IF errorCount > 0 THEN
      Out.String("There is ");
      Out.Int(errorCount, 0);
      Out.String(" observed.")
    ELSE
      Out.String("No Error!")
    END;
    Out.Ln;
    RETURN errorCount
  END Completed;

  PROCEDURE Setup*;
  BEGIN
    errorCount := 0;
    registryCount := 0
  END Setup;

BEGIN
  Out.Ln;
  Setup
END Test.

