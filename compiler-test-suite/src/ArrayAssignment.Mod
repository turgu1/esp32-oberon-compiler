MODULE ArrayAssignment;
  IMPORT Out;
  TYPE
    arr2 = ARRAY 2 OF INTEGER;
    multy = ARRAY 2, 4 OF INTEGER;
    R = RECORD
          x : arr2;
          y : ARRAY 2, 2 OF INTEGER
        END;
  VAR
    a : arr2;
    m : multy;
    b : ARRAY 2 OF INTEGER;
    d0, d1 : ARRAY 2 OF R;
    e0, e1 : ARRAY 2, 9 OF R;
  PROCEDURE localAssignment(VAR c2 : arr2; VAR z2 : multy);
    VAR
      a2 : arr2;
      m2 : multy;
      b2 : ARRAY 2 OF INTEGER;
      d2, d3 : ARRAY 2 OF R;
      e2, e3 : ARRAY 2, 9 OF R;
  BEGIN
    b2[0] := 5; 
    a2 := b2;
    Out.Int(a2[0], 0); (* 5 *)
    a2[0] := 6;
    Out.Int(b2[0], 0); (* 5 *)
    a2 := c2;
    Out.Int(a2[0], 0); (* 7 *)  
    a2[0] := 6;
    Out.Int(c2[0], 0); (* 7 *) 
    c2 := a2;
    a2[0] := 8;
    Out.Int(c2[0], 0); (* 6 *) 
    Out.Int(a2[0], 0); (* 8 *) 
    d2[1].x := b2;
    Out.Int(d2[1].x[0], 0); (* 5 *)
    d2[1].x[0] := 10;
    Out.Int(b2[0], 0); (* 5 *)
    a2 := d2[1].x;
    Out.Int(a2[0], 0); (* 10 *)
    d2[0].y[1][0] := 11;
    d2[0].y[0] := d2[0].y[1];
    Out.Int(d2[0].y[0][0], 0); (* 11 *)
    d2[0].y[0][0] := 12;
    Out.Int(d2[0].y[1][0], 0); (* 11 *)
    Out.Int(d2[0].y[0][0], 0); (* 12 *)
    d3[0].x[1] := 15;
    d2 := d3;
    Out.Int(d2[0].x[1], 0); (* 15 *)
    d2[0].x[1] := 16;
    Out.Int(d3[0].x[1], 0); (* 15 *)
    Out.Int(d2[0].x[1], 0); (* 16 *)
    e3[0][8].x[1] := 25;
    e2 := e3;
    Out.Int(e2[0][8].x[1], 0); (* 25 *)
    e2[0][8].x[1] := 26;
    Out.Int(e3[0][8].x[1], 0); (* 25 *)
    Out.Int(e2[0][8].x[1], 0); (* 26 *)
    m2 := z2;
    Out.Int(m2[0][1], 0); (* 77 *)  
    m2[0][1] := 66;
    Out.Int(z2[0][1], 0); (* 77 *) 
    z2 := m2;
    m2[0][1] := 88;
    Out.Int(z2[0][1], 0); (* 66 *) 
    Out.Int(m2[0][1], 0); (* 88 *)
  END localAssignment;
BEGIN 
  a[0] := 7;
  m[0][1] := 77;
  localAssignment(a, m);
  a := b;
  d0[1].x := b;
  a := d0[1].x;
  d0[0].y[0] := d0[0].y[1];
  d0 := d1;
  e0[0][1].x := b;
  a := e0[0][1].x;
  e0[0][0].y[0] := e0[0][0].y[1];
  e0[0][0].y := e0[0][0].y;
  e0[0][0].y := e1[0][0].y;
  e0 := e1;
END ArrayAssignment.
