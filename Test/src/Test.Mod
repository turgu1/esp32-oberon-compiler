MODULE Test;
IMPORT Out;

VAR
  errorCount: INTEGER;

PROCEDURE Assert*(cond: BOOLEAN; msg: ARRAY OF CHAR);
BEGIN
  IF ~cond THEN
    Out.String(msg);
    Out.Ln;
  END
END Assert;

PROCEDURE Completed* : INTEGER;
BEGIN
  Out.String("Test Completed. ") 
  IF errorCount > 0 THEN
    Out.String("There is ");
    Out.Int(errorCount);
    Out.String(" observed.")
  ELSE
    Out.String("No Error!");
  END;
  Out.Ln;
  RETURN errorCount
END Completed;

BEGIN
  errorCount := 0;
END Test.

