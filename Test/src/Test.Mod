MODULE Test;

  IMPORT Out;

  CONST 
    MaxTestProc = 200;

  TYPE
    TestProc* = PROCEDURE ();

  VAR
    assertCallCount: INTEGER;
    errorCount:      INTEGER; 
    registryCount:   INTEGER;
    testProcs: ARRAY MaxTestProc OF TestProc;

    nextCh, firstCh, maxCh: CHAR;

  PROCEDURE Put(ch: CHAR);
  BEGIN
    Out.Char(ch); Out.Flush
  END Put;

  PROCEDURE End*;
  BEGIN
    Put(".");
  END End;
  
  PROCEDURE First*(ch: CHAR);
  BEGIN
    firstCh := ch;
    Put(ch);
    nextCh := CHR(ORD(ch) + 1);
    maxCh := CHR(ORD(ch) + 26)
  END First;

  PROCEDURE Next*;
  BEGIN
    Put(nextCh);
    nextCh := CHR(ORD(nextCh) + 1);
    IF nextCh >= maxCh THEN nextCh := firstCh END
  END Next;

  PROCEDURE Register*(proc: TestProc);
  BEGIN
    Out.Ln;
    IF registryCount < (MaxTestProc - 1) THEN
      testProcs[registryCount] := proc;
      INC(registryCount)
    END
  END Register;

  PROCEDURE Exec*() : INTEGER;
  VAR
    i : INTEGER;
  BEGIN
    Out.String("Start"); Out.Ln; Out.Ln;
    errorCount := 0;
    FOR i := 0 TO registryCount - 1 DO
      testProcs[i]();
    END;
    RETURN errorCount
  END Exec;

  PROCEDURE Assert*(cond: BOOLEAN; msg: ARRAY OF CHAR);
  BEGIN 
    INC(assertCallCount);
    IF  ~cond THEN
      Out.Ln;
      Out.String("Assert Failed: ");
      Out.String(msg);
      Out.Ln;
      Out.Flush;
      INC(errorCount)
    END
  END Assert;

  PROCEDURE Completed*(): INTEGER;
  BEGIN
    Out.Ln;
    Out.Ln; Out.String("Test Completed. "); 
    Out.Ln; Out.String("Number of Test Procedures: "); Out.Int(registryCount, 0); 
    Out.Ln; Out.String("Number of Assertion made: ");  Out.Int(assertCallCount, 0); 
    IF errorCount > 0 THEN
      Out.Ln; Out.String("There is "); Out.Int(errorCount, 0); Out.String(" error(s) observed.")
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

