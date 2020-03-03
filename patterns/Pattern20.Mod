MODULE Pattern20;
VAR
  b: BOOLEAN;
  i, j: INTEGER;
  p: PROCEDURE (a, b: INTEGER);
  s: SET;

  PROCEDURE q(a, b: INTEGER);
    VAR bb: BOOLEAN;
    PROCEDURE qa(a, b: BOOLEAN): BOOLEAN;
    BEGIN
      RETURN a & b
    END qa;

    PROCEDURE qb(a, b: BOOLEAN): BOOLEAN;
    BEGIN
      RETURN a OR b
    END qb;

  BEGIN
    i := 1;
    bb := qa(TRUE, FALSE);
    bb := qb(TRUE, FALSE);
  END q;

BEGIN
  INCL(s, 3);
  INCL(s, i);
  EXCL(s, 3);
  EXCL(s, i);
  b := i < j;
  b := TRUE;
  p := q;
  p(1, 2);
END Pattern20.
