MODULE OpenArrays;
  IMPORT Out;
  VAR  x : ARRAY 1 OF INTEGER;
       y : ARRAY 2 OF INTEGER;

  PROCEDURE P2(a : ARRAY OF INTEGER; VAR b : ARRAY OF INTEGER);
    VAR k : INTEGER;
  BEGIN
    Out.Int(b[0], 10); (* 1 *) 
   (* a[0] := 1; read only*)
   (* a[3] := 2;  read only*)
    b[0] := 2;
   (*  b[3] := 2; TRAP *) 
    k := a[0];
   (* k := a[3];  TRAP *) 
    k := b[0];
    Out.Int(k, 10); (* 2 *) 
   (* k := b[3]; TRAP *)
  END P2;

  PROCEDURE P1(a : ARRAY OF INTEGER; VAR b : ARRAY OF INTEGER);
    VAR k : INTEGER;
  BEGIN
   (* a[0] := 1; read only*)
   (* a[3] := 2;  read only*)
    b[0] := 1;
   (* b[3] := 2; TRAP *) 
    k := a[0];
   (* k := a[3];  TRAP *) 
    k := b[0];
   (* k := b[3]; TRAP *)
    P2(a, b)  
  END P1;
BEGIN 
  P1(x, y);
  Out.Int(y[0], 10); (* 2 *) 
END OpenArrays.