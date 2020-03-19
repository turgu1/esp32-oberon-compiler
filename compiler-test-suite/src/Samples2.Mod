MODULE Samples2;
  IMPORT Out;
  VAR n: INTEGER;
  PROCEDURE Multiply;
    VAR x, y, z: INTEGER;
  BEGIN x := 7; y := 11; z := 0;
      WHILE x > 0 DO
        IF x MOD 2 = 1 THEN z := z + y END ;
        y := 2*y; x := x DIV 2
      END ;
      Out.Int(x, 10); Out.Int(y, 10); Out.Int(z, 10); Out.Ln
  END Multiply;
  
  PROCEDURE Divide;
    VAR x, y, r, q, w: INTEGER;
  BEGIN x := 7; y := 11; r := x; q := 0; w := y;
    WHILE w <= r DO w := 2*w END ;
      WHILE w > y DO
        q := 2*q; w := w DIV 2;
        IF w <= r THEN r := r - w; q := q + 1 END
      END ;
    Out.Int(x, 10); Out.Int(y, 10); Out.Int(q, 10); Out.Int(r, 10); Out.Ln
  END Divide;
  
  PROCEDURE BinSearch;
    VAR i, j, k, n, x: INTEGER;
        a: ARRAY 32 OF INTEGER;
  BEGIN x := 7; k := 0;
    WHILE k < 32 DO a[k] := 11; k := k + 1 END ;
    i := 0; j := n;
      WHILE i < j DO
      k := (i+j) DIV 2;
      IF x < a[k] THEN j := k ELSE i := k+1 END
    END ;
    Out.Int(i, 10); Out.Int(j, 10); Out.Int(a[j], 10); Out.Ln
  END BinSearch;
  
BEGIN n := 1;
  IF n = 0 THEN Multiply ELSIF n = 1 THEN Divide ELSE BinSearch END
END Samples2.