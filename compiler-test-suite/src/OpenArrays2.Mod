MODULE OpenArrays2;
  IMPORT Out;
  TYPE ARR = ARRAY 3 OF INTEGER;
  VAR
    x : ARR;
    i : INTEGER;
  
  PROCEDURE P1(VAR b : ARRAY OF INTEGER; c : ARR; VAR d : ARR; e : ARRAY OF INTEGER);
  BEGIN
    Out.Int(b[i]);
    Out.Int(c[i]);
    Out.Int(d[i]);
    Out.Int(e[i])
  END P1; 

BEGIN
  i := 1;
  x[i] := 8;
  P1(x, x, x, x)
END OpenArrays2.
