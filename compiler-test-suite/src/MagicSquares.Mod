MODULE MagicSquares;   (*for Oberon-0 NW 25.1.2013*)
  IMPORT Out;

  PROCEDURE Generate;  (*magic square of order 3, 5, 7, ... *)
    VAR i, j, x, nx, nsq, n: INTEGER;
      M: ARRAY 13 OF ARRAY 13 OF INTEGER;
  BEGIN n := 15;
      nsq := n*n; x := 0;
      i := n DIV 2; j := n-1;
      WHILE x < nsq DO
        nx := n + x; j := (j-1) MOD n; x := x+1; M[i][j] := x;
        WHILE x < nx DO
          i := (i+1) MOD n; j := (j+1) MOD n;
          x := x+1; M[i][j] := x
        END
      END ;
    i := 0;
    REPEAT j := 0;
      REPEAT Out.Int(M[i][j], 10); j := j+1 UNTIL j = n;
      Out.Ln; i := i+1
    UNTIL i = n
  END Generate;

BEGIN Generate
END MagicSquares.