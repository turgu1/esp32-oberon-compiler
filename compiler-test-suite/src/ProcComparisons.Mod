MODULE ProcComparisons;
  IMPORT Out;
  VAR x: BOOLEAN;
   
  PROCEDURE P2(i : INTEGER): INTEGER;
  BEGIN 
    RETURN 2
  END P2;
  
  PROCEDURE P1(i : INTEGER): INTEGER;
  BEGIN 
    RETURN 1
  END P1;
   
BEGIN
  IF P2 = P1 THEN Out.Int(0) END;
  IF P2 = P2 THEN Out.Int(1) END;
  IF P2 # P1 THEN Out.Int(2) END;
  IF P2 # NIL THEN Out.Int(3) END;
  IF P2 = NIL THEN Out.Int(4) END;
  x := P2 = P2;
  x := P2 = NIL
END ProcComparisons.