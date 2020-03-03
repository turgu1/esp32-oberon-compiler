MODULE Test;

  IMPORT Out;

  CONST 
    MaxTestProc = 200;

  TYPE
    TestProc* = PROCEDURE ();

  VAR
    assertCallCount,
    errorCount: INTEGER;
    testProcs: ARRAY MaxTestProc OF TestProc;
    registryCount: INTEGER;

  PROCEDURE Register*(proc: TestProc);
  BEGIN
    IF registryCount < (MaxTestProc - 1) THEN
      testProcs[registryCount] := proc;
      INC(registryCount)
    END
  END Register;

  PROCEDURE Exec*() : INTEGER;
  VAR
    i : INTEGER;
  BEGIN
    errorCount := 0;
    FOR i := 0 TO registryCount - 1 DO
      testProcs[i]();
    END;
    RETURN errorCount
  END Exec;

  PROCEDURE Assert*(cond: BOOLEAN; msg: ARRAY OF CHAR);
  BEGIN
    INC(assertCallCount);
    IF ~cond THEN
      Out.Ln;
      Out.String("Assert Failed: ");
      Out.String(msg);
      INC(errorCount)
    END
  END Assert;

  PROCEDURE Completed*(): INTEGER;
  BEGIN
    Out.Ln;
    Out.Ln; Out.String("Test Completed. "); 
    Out.Ln; Out.String("Number of Test Procedures: "); Out.Int(registryCount, 0); 
    Out.Ln; Out.String("Number of Assertion made: "); Out.Int(assertCallCount, 0); 
    IF errorCount > 0 THEN
      Out.Ln; Out.String("There is "); Out.Int(errorCount, 0); Out.String(" observed.")
    ELSE
      Out.Ln; Out.String("No Error! Life is good!!")
    END;
    RETURN errorCount
  END Completed;

  PROCEDURE Setup*;
  BEGIN
    assertCallCount := 0;
    errorCount      := 0;
    registryCount   := 0
  END Setup;

BEGIN
  Setup
END Test.

