MODULE CommutativeSwap;
  IMPORT Out;
  VAR i : INTEGER;       a : ARRAY 10 OF INTEGER;
BEGIN
  i := 5;
  a[i+3] := 5;
  Out.Int(1 - i + 3 * i); (* 11 *)
  Out.Int(2 - a[i+3]); (* -3 *)
END CommutativeSwap.