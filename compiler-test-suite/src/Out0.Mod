MODULE Out0;
  IMPORT Out;
  CONST con = 100;
 TYPE
    V = RECORD  x : ARRAY 10 OF INTEGER END;
    Hello = RECORD world : INTEGER; x : ARRAY 3 OF ARRAY 10 OF V; END;
    int = INTEGER;
    ARR = ARRAY 9 OF int;
    ARR2 = ARRAY 9 OF V;
  VAR
      a : ARRAY 4 OF INTEGER;
      b : ARRAY 3 OF ARRAY 5 OF INTEGER;
      c : ARRAY 1 OF ARRAY 2 OF ARRAY 3 OF ARRAY 4 OF INTEGER;
      d : V;
      e : Hello;
      f : int;
      g : ARR;
      h : ARR2;
      z : RECORD y : int END;
      i, j : INTEGER;
      k : BOOLEAN;

BEGIN
  a[2] := 8;
  Out.Int(a[2]);
  b[2][3] := 9;
  Out.Int(b[2][3]);
  c[0][1][2][3] := 10;
  Out.Int(c[0][1][2][3]);
  d.x[9] := 11;
  Out.Int(d.x[9]);
  e.world := 12;
  Out.Int(e.world);
  e.x[2][3].x[3] := 13;
  Out.Int(e.x[2][3].x[3]);
  f := 14;
  Out.Int(f);
  g[6] := 15;
  Out.Int(g[6]);
  h[8].x[2] := 16;
  Out.Int(h[8].x[2]);
  z.y := 17;
  Out.Int(z.y);
  i := -z.y + c[0][1][2][3] + h[8].x[2] * e.x[2][3].x[3] -1;
  Out.Int(i);
  j := 2;
  k := (i = j) OR (i >= j);
  IF k THEN Out.Int(1) END
END Out0.