MODULE Out1;
  IMPORT Out;
  CONST con = 100;
  VAR           
      a : ARRAY 4 OF INTEGER;
      b : ARRAY 3 OF ARRAY 5 OF INTEGER;
      c : ARRAY 4 OF INTEGER;
      i, j : INTEGER;

BEGIN 
  i := 1;
  j := 2;
  a[j] := 1;
  Out.Int(a[j], 10);
  a[2] := 2;
  Out.Int(a[2], 10);
  a[i+j] := 3;
  Out.Int(a[i+j], 10);
  b[i][j] := 4;
  Out.Int(b[i][j], 10);
  b[2][4] := 5;
  Out.Int(b[2][4], 10);
  a[a[i]] := 6;
  Out.Int(a[a[i]], 10);
  a[c[i]] := 7;
  Out.Int(a[c[i]], 10);
END Out1.