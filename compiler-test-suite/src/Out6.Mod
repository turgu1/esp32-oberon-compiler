MODULE Out6;
  IMPORT Out;
  TYPE 
    R0 = RECORD x : INTEGER END; 
    R1 = RECORD
           r0 : RECORD x : INTEGER END 
         END; 
    R2 = RECORD
           r0 : RECORD 
                  x : RECORD 
                        y : R0 
                      END 
                END 
         END; 
  VAR           
    a : R0;
    b : R1;
    c : R2;
BEGIN 
  a.x := 10;
  Out.Int(a.x + a.x);
  b.r0.x := 11;
  Out.Int(b.r0.x + b.r0.x);
  c.r0.x.y.x := 12;
  Out.Int(c.r0.x.y.x + c.r0.x.y.x);
END Out6.