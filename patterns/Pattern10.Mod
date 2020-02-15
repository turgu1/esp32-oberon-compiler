MODULE Pattern10;
VAR
  a: ARRAY 12 OF INTEGER;
  
  (* VAR must be there to allow edition of the array, the opposite 
     of the description in the PO.Application.pdf document *)
     
  PROCEDURE P(VAR x: ARRAY OF INTEGER);
  VAR
    i, n: INTEGER;
  BEGIN
    n := x[i];
    x[i + 1] := n + 5
  END P;
  
BEGIN
  P(a);
END Pattern10.
