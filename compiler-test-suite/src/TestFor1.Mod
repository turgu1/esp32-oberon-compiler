MODULE TestFor1;
  IMPORT Out;
  VAR v, beg, end : INTEGER;
  
  PROCEDURE For0;
    VAR v, beg, end : INTEGER;
  BEGIN
    beg := 3;
    end := 10;
    FOR v := beg TO end BY 2 DO Out.Int(v) END;
    Out.Ln
  END For0;
  
  PROCEDURE For1;
  BEGIN
    beg := 0;
    end := 3;
    FOR v := beg TO end DO Out.Int(v) END;
    Out.Ln
  END For1;
  
  PROCEDURE For2(VAR v1, beg1, end1 : INTEGER; v0, beg0, end0 : INTEGER );
  BEGIN
    FOR v1 := beg1 TO end1 BY 2 DO Out.Int(v1) END;
    Out.Ln;
    FOR v0 := beg0 TO end0 DO Out.Int(v0) END;
    Out.Ln;
    FOR v1 := beg TO end0 DO Out.Int(v1) END;
    Out.Ln
  END For2;
  PROCEDURE For4;
  BEGIN
    beg := 10;
    end := 3;
    FOR v := beg TO end BY -1 DO Out.Int(v) END;
    Out.Ln
  END For4;
BEGIN
  For0; For1; For2(v, beg, end, 0, 3, 10); For4
END TestFor1.