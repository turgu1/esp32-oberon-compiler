MODULE TestINC0;
  IMPORT Out;

  VAR xg : INTEGER;
      yg : BYTE;
      ig : ARRAY 2 OF INTEGER; 
      jg : RECORD x : INTEGER END;
   
  PROCEDURE P0(VAR i : INTEGER; VAR j : BYTE);
  BEGIN 
    INC(i);
    Out.Int(i, 10); (* 2 *)
    INC(i, 130);
    Out.Int(i, 10); (* 132 *)
    INC(i, -128);
    Out.Int(i, 10); (* 4 *)
    DEC(j);
    Out.Int(j, 10); (* 255 *)
    DEC(j, 130);
    Out.Int(j, 10); (* 125 *)
    INC(j, 4);
    Out.Int(j, 10); (* 129 *)
    DEC(j, -128);
    Out.Int(j, 10) (* 1 *)
  END P0;
  
  
  PROCEDURE P2;
    VAR i : INTEGER; 
        j : BYTE;
  BEGIN 
    i := 1; j := 0;
    INC(i);
    Out.Int(i, 10); (* 2 *)
    INC(i, 130);
    Out.Int(i, 10); (* 132 *)
    INC(i, -128);
    Out.Int(i, 10); (* 4 *)
    DEC(j);
    Out.Int(j, 10); (* 255 *)
    DEC(j, 130);
    Out.Int(j, 10); (* 125 *)
    INC(j, 4);
    Out.Int(j, 10); (* 129 *)
    DEC(j, -128);
    Out.Int(j, 10) (* 1 *)
  END P2; 
  
  PROCEDURE P3(VAR a0 : INTEGER; VAR a1 : ARRAY OF INTEGER);
    VAR i : ARRAY 2 OF INTEGER;
        j : RECORD x : INTEGER END;
        x : INTEGER;
        b : ARRAY 2 OF BYTE;
  BEGIN 
    x := 0;
    i[0] := 2; i[1] := 3;
    INC(i[0]);
    Out.Int(i[0], 10); (* 3 *)
    INC(i[x+1]);
    Out.Int(i[x+1], 10); (* 4 *)
    
    j.x := 3;
    INC(j.x);
    Out.Int(j.x, 10); (* 4 *)
        
    INC(a0);
    Out.Int(a0, 10); (* 2 *)
    
    x := 0;
    INC(a1[x+1]);
    Out.Int(a1[x+1], 10); (* 4 *)
    
    INC(ig[0]);
    Out.Int(ig[0], 10); (* 3 *)
    INC(ig[x+1]);
    Out.Int(ig[x+1], 10); (* 5 *)
    xg := 0;
    INC(ig[xg+1]);
    Out.Int(ig[xg+1], 10); (* 6 *)
    jg.x := 6;
    INC(jg.x);
    Out.Int(jg.x, 10); (* 7 *)
    
    INC(a1[xg+1]);
    Out.Int(a1[xg+1], 10); (* 7 *)
    
    b[1] := 10;
    INC(b[x+1]);
    Out.Int(b[x+1], 10); (* 11 *)
    
    (*INC(i[0], x+1); INC's second argument must be a constant or simple variable *)
    i[0] := 2; i[1] := 3;
    INC(i[0], 7);
    Out.Int(i[0], 10); (* 9 *)
    INC(i[x+1], 7);
    Out.Int(i[x+1], 10); (* 10 *)
    
    j.x := 3;
    INC(j.x, 2);
    Out.Int(j.x, 10); (* 5 *)
    x := 98;
    a0 := 1;
    INC(a0, x);
    Out.Int(a0, 10); (* 99 *)
    x := 0;
    a1[x+1] := 80;
    xg := 20;
    INC(a1[x+1], xg);
    Out.Int(a1[x+1], 10); (* 100 *)
    x := 3;
    DEC(x, -1);
    Out.Int(x, 10); (* 4 *)
  END P3; 
  
BEGIN
 xg := 1;
 yg := 0;
 P0(xg, yg);
 Out.Ln;
 P2;
 Out.Ln;
 xg := 1;
 ig[0] := 2; ig[1] := 3;
 P3(xg, ig)
END TestINC0.