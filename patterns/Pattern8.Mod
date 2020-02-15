MODULE Pattern8;
VAR
  i: INTEGER;
  
  PROCEDURE P(x: INTEGER; VAR y: INTEGER);
  VAR
    z: INTEGER;
  BEGIN
    z := x;
    y := z
  END P;

BEGIN
  P(5, i)
END Pattern8.
