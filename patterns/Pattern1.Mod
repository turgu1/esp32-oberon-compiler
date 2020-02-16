MODULE Pattern1;
VAR
  ch: CHAR;
  k:  INTEGER;
  x:  REAL;
  s:  SET;
BEGIN 
  ch := "0";
  k  :=  10;
  x  := 1.0;
  s  := {0, 4, 8}
END Pattern1.

(* 
  Module data:
     offset  value
       0      ch
       4      k
       8      x
      12      s
  Code:
      ENTRY a1, 0
      RETW
*)