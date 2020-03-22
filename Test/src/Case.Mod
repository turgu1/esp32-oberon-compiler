MODULE Case;
  IMPORT Out, T := Test;
  CONST C = "C";
  TYPE 
    ARR =  ARRAY 3 OF RECORD c: CHAR END;
    R = RECORD a: INTEGER END ;
    R0 = RECORD (R) b: REAL END ;
    R1 = RECORD (R) b: INTEGER END ;
    R2 = RECORD (R) b: SET END ;
    P = POINTER TO R;
    P0 = POINTER TO R0;
    P1 = POINTER TO R1;
    P2 = POINTER TO R2;
    
  VAR 
    i, a : CHAR;
    ii, aa : INTEGER;
    b: ARR;
    p: P; p1 : P1;

  PROCEDURE Proc1(i : INTEGER) : INTEGER;
     VAR a : INTEGER;
  BEGIN
    CASE i OF
        8..10, 14:        a :=  1
      | 2..4, 15..20, 25: a :=  2 
      | 5..6:             a :=  3 
      ELSE                a := -1
    END;
    RETURN a
  END Proc1;

  PROCEDURE Proc2() : INTEGER;
   VAR i, j: INTEGER;
  BEGIN
      i := 1;
      CASE i OF
         0: j := 0
       | 1: j := 1
       | 2: j := 2
    END;
    RETURN j
  END Proc2;

  PROCEDURE Proc3(i: INTEGER) : INTEGER;
    VAR a: INTEGER;
  BEGIN
    CASE i OF
        8..10, 14:         a := 1
      | 2..4, 15..20, 25:
          CASE i OF
              3, 15..19:   a := 2
            | 25:          a := 3
          END
      | 5..6:              a := 4
    END;
    RETURN a
  END Proc3;

  PROCEDURE NoLocals(i: INTEGER);
  BEGIN
    CASE i OF
       5: aa := 5
    END
  END NoLocals;

  PROCEDURE Proc4(i: ARR): INTEGER;
  VAR j : INTEGER;
  BEGIN
    CASE i[2].c OF
      "P": j := ORD(i[2].c)
    END
    RETURN j
  END Proc4;

  PROCEDURE Proc5(i: ARR): INTEGER;
    VAR k: INTEGER;
  BEGIN
    CASE ORD(i[2].c) OF
      80: k := 1
    END
    RETURN k
  END Proc5;

  PROCEDURE Run;
  BEGIN
    Out.String("CASE statement: "); Out.Flush;

    T.First("A"); 

    i := "B";
    CASE i OF
        "A".."C", "Z":   a := "1"
        | "I".. "K":     a := "2" 
        | "W":           a := "3" 
    END;
    T.Assert(a = "1", "CaseChar 1");

    CASE C OF
        22X:             i := "4" 
        | "A".."C", "Z": i := "5" 
    END;
    T.Assert(i = "5", "CaseChar 2");

    ii := 2;
    CASE ii OF
        8..10, 14:        aa := 1 
      | 2..4, 15..20, 25: aa := 2 
      | 5..6:             aa := 3 
    END;
 
    T.Assert(aa = 2,      "CaseNum  1");
    T.Assert(Proc1(9)  =  1, "CaseNum  2");
    T.Assert(Proc1(4)  =  2, "CaseNum  3");
    T.Assert(Proc1(6)  =  3, "CaseNum  4");
    T.Assert(Proc1(30) = -1, "CaseNum  5");
    T.Assert(Proc1(1)  = -1, "CaseNum  6");
    T.Assert(Proc2()   =  1, "CaseNum  7");

    T.Assert(Proc3( 9) =  1, "CaseNum  8");
    T.Assert(Proc3(18) =  2, "CaseNum  9");
    T.Assert(Proc3(25) =  3, "CaseNum 10");
    T.Assert(Proc3( 6) =  4, "CaseNum 11");
    NoLocals(5); 
    T.Assert(aa = 5,      "CaseNum 12");

    b[2].c := "P";
    T.Assert(Proc4(b) = 80,  "CaseNum 13");
    T.Assert(Proc5(b) =  1,  "CaseNum 14");

    NEW(p1); p := p1; p.a := 1;
    CASE p OF
        P0: p.b := 2.5; ii := 0
      | P1: p.b := p.a + p.b + p.b DIV 3; ii := p.a
      | P2: p.b := {0, 2}; ii := 2
    END;
    T.Assert(ii = 1, "CaseNum15");
    IF ii # 1 THEN 
      Out.String("Expected: "); Out.Int(1,  0); 
      Out.String(" Got: "    ); Out.Int(ii, 0); 
      Out.Ln 
    END;

    T.End; Out.String(" End"); Out.Ln
  END Run;

BEGIN
  T.Register(Run)
END Case.