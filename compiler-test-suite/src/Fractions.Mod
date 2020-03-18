MODULE Fractions;  (*NW  10.10.07;  Tabulate fractions 1/n*)
  IMPORT Out;
  CONST Base = 10; N = 32;
  
  PROCEDURE Go;
    VAR i, j, m, n, r: INTEGER;
      d: ARRAY N OF INTEGER;  (*digits*)
      x: ARRAY N OF INTEGER;  (*index*)
  BEGIN n := 7; i := 2;
      WHILE i <= n DO j := 0;
        WHILE j < i DO x[j] := 0; j := j+1 END ;
        m := 0; r := 1;
        WHILE x[r] = 0 DO
          x[r] := m; r := Base*r; d[m] := r DIV i; r := r MOD i; m := m+1
        END ;
        Out.Int(i, 10); Out.Char(CHR(9)); Out.Char("."); j := 0;
        WHILE j < x[r] DO Out.Char(CHR(d[j] + 48)); j := j+1 END ;
        Out.Char("'");
        WHILE j < m DO Out.Char(CHR(d[j] + 48)); j := j+1 END ;
        Out.Ln; i := i+1
      END
  END Go;

BEGIN Go
END Fractions.