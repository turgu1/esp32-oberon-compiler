MODULE Test;
VAR 
  i, j, k, l, m, n, o: BOOLEAN;
  a: INTEGER;
BEGIN
  DBGON
  IF i & (j & (k OR o)) & (l & m) THEN a := 7 END
  DBGOFF
END Test.
