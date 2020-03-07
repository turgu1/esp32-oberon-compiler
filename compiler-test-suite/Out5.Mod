MODULE Out5;
  IMPORT Out;
  TYPE A = RECORD x : INTEGER END;
  VAR i: INTEGER;
      v : ARRAY 20 OF INTEGER;
      a : A;
BEGIN 
  i := 1;
  v[i] := 10;
  Out.Int(v[i]);
  i := v[i] + 1; 
  Out.Int(i);
  v[i] := i + 1; 
  Out.Int(v[i]);
  i := v[i] + v[i] - 4; 
  Out.Int(i);
  a.x := 21;
  Out.Int(a.x);
  i := a.x + 1; 
  Out.Int(i);
  a.x := i + 1; 
  Out.Int(a.x);
  i := a.x + a.x - 22; 
  Out.Int(i);
END Out5.