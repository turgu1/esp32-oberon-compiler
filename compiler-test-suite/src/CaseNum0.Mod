MODULE CaseNum0;
  IMPORT Out;
  VAR i, a : INTEGER;
  
  PROCEDURE P(i : INTEGER);
     VAR a : INTEGER;
  BEGIN
    CASE i OF
      8..10, 14:
        a := 1; 
      |2..4, 15..20, 25:
        a := 2; 
      |5..6:
        a := 3; 
    END;
    Out.Int(a, 0)
  END P;

  PROCEDURE P2;
   VAR i: INTEGER;
  BEGIN
      i := 1;
      CASE i OF
       0: Out.Int(0, 0)
       | 1: Out.Int(1, 0)
       | 2: Out.Int(2, 0)
    END
  END P2;

BEGIN
  i := 2;
  CASE i OF
    8..10, 14:
      a := 1; 
    |2..4, 15..20, 25:
      a := 2; 
    |5..6:
      a := 3; 
  END;
  Out.Int(a, 0); (* 2 *)
  P(9); (* 1 *)
  P(4); (* 2 *)
  P(6); (* 3 *)
  P2 (* -1 *)
END CaseNum0.