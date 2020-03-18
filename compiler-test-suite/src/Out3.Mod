MODULE Out3;
  IMPORT Out;
  CONST con = 100;
  VAR           
    i, j, k : INTEGER;
    o, x : BOOLEAN;
  PROCEDURE gdc(m, n : INTEGER) : INTEGER;
  BEGIN
    WHILE m > n DO m := m - n
    ELSIF n > m DO n := n - m
    END;
    RETURN m
  END gdc;
BEGIN 
  i := 5;
  j := 5;
  IF i > j THEN 
    k := 1;
    Out.Int(k, 10)
  ELSIF i = j THEN
    k := 2;
    Out.Int(k, 10);
    o := TRUE;
    IF k >= 1 THEN
      WHILE (i # j) OR o & (k < 4) DO 
        k := k + 1;
        Out.Int(k, 10)
      END
    END
  ELSE
    k := 3;
    Out.Int(k, 10)
  END;
  WHILE (i # j) OR o & (k <= 4) DO 
    k := k + 1;
    Out.Int(k, 10)
  END;
  REPEAT 
    i := i + 1;
    Out.Int(i, 10)
  UNTIL (( i = 6) & o) OR ((j = 6) OR ~o);
  IF i > 0 THEN Out.Int(7, 10) END;
  i := +12; x := TRUE;
  o := (8 > 3) & x & (i IN  {0..13});
  IF o THEN Out.Int(8, 10) END;
  i := 8;
  Out.Ln;
  REPEAT 
    i := i + 1;
    Out.Int(i, 10)
  UNTIL ( (i = 15) OR (j = 10) & ~o) & ((j # 6) OR ~o);
  Out.Int(gdc(8, 12), 10)
END Out3.