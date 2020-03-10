MODULE Out2;
  IMPORT Out;
  CONST con = 100;
  TYPE 
       R0 = RECORD x, y : INTEGER END; 
       R1 = RECORD u : INTEGER; 
                   v : ARRAY 4 OF R0; 
                   v2 : ARRAY 4 OF ARRAY 6 OF R0; 
                   w : INTEGER; 
                   r0 : R0 
            END; 
       R2 = RECORD  r1 : R1 END; 
  VAR           
      i, j: INTEGER;
      s : ARRAY 2 OF R1;
      a : R0;
      b : R2;

BEGIN 
  a.x := 10;
  Out.Int(a.x);
  b.r1.r0.x := 11;
  Out.Int(b.r1.r0.x);
  i := 1;
  j := 2;
  s[i].u := 12;
  Out.Int(s[i].u);
  s[1].w := 13;
  Out.Int(s[1].w);
  s[i].v[j].x := 14;
  Out.Int(s[i].v[j].x);
  s[1].v[2].x := 15;
  Out.Int(s[1].v[2].x);
  s[0].v[i].y := 16;
  Out.Int(s[0].v[i].y);
  s[0].r0.y := 17;
  Out.Int(s[0].r0.y);
  s[0].v2[i][j].y := 18;
  Out.Int(s[0].v2[i][j].y);
END Out2.