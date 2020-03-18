MODULE Out5;
  IMPORT Out;
  TYPE A = RECORD x : INTEGER END;
  VAR i: INTEGER;
      v : ARRAY 20 OF INTEGER;
      a : A;
BEGIN 
  i := 1;
  v[i] := 10;
  Out.Int(v[i], 10);
  i := v[i] + 1; 
  Out.Int(i, 10);
  v[i] := i + 1; 
  Out.Int(v[i], 10);
  i := v[i] + v[i] - 4; 
  Out.Int(i, 10);
  a.x := 21;
  Out.Int(a.x, 10);
  i := a.x + 1; 
  Out.Int(i, 10);
  a.x := i + 1; 
  Out.Int(a.x, 10);
  i := a.x + a.x - 22; 
  Out.Int(i, 10);
END Out5.