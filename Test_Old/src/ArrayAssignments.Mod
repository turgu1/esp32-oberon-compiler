MODULE ArrayAssignments;
  IMPORT Out, T := Test;
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
    Out.String("Array Ops on local variables: "); Out.Flush;

    T.First("A"); 

    b2[0] := 5; a2 := b2;     T.Assert((b2[0] = 5) & (a2[0] = b2[0]) & (a2[1] = b2[1]), "b2[0] := 5; a2 := b2;");
    a2[0] := 6;               T.Assert((b2[0] = 5) & (a2[0] = 6), "a2[0] := 6;");
    a2 := c2;                 T.Assert((b2[0] = 5) & (a2[0] = 7), "a2 := c2;");
    a2[0] := 6;               T.Assert((b2[0] = 5) & (a2[0] = 6) & (c2[0] = 7), "a2 := 6;");
    c2 := a2; a2[0] := 8;     T.Assert((b2[0] = 5) & (a2[0] = 8) & (c2[0] = 6), "c2 := a2; a2[0] := 8;");
    d2[1].x := b2;            T.Assert(d2[1].x[0] = 5,  "d2[1].x := b2;");
    d2[1].x[0] := 10;         T.Assert(d2[1].x[0] = 10, "d2[1].x := 10;");
    a2 := d2[1].x;            T.Assert(a2[0] = 10,      "a2 := d2[1].x;");
    d2[0].y[1][0] := 11;
    d2[0].y[0] := d2[0].y[1]; T.Assert((d2[0].y[0][0] = 11) & (d2[0].y[0][0] = d2[0].y[1][0]) & (d2[0].y[0][1] = d2[0].y[1][1]), "d2[0].y[1][0] := 11; d2[0].y[0] := d2[0].y[1];");
    d2[0].y[0][0] := 12;      T.Assert((d2[0].y[1][0] = 11) & (d2[0].y[0][0] = 12),      "d2[0].y[0][0] := 12;");
    d3[0].x[1] := 15;
    d2 := d3;                 T.Assert(d2[0].x[1] = 15, "d3[0].x[1] := 15; d2 := d3;");
    d2[0].x[1] := 16;         T.Assert((d3[0].x[1] = 15) & (d2[0].x[1] = 16), "d2[0].x[1] := 16;");
    e3[0][8].x[1] := 25;
    e2 := e3;                 T.Assert((e3[0][8].x[1] = 25) & (e2[0][8].x[1] = 25), "e3[0][8].x[1] := 25; e2 := e3;");
    e2[0][8].x[1] := 26;      T.Assert((e3[0][8].x[1] = 25) & (e2[0][8].x[1] = 26), "e2[0][8].x[1] := 26;");
    m2 := z2;                 T.Assert(m2[0][1] = 77, "m2 := z2;");
    m2[0][1] := 66;           T.Assert((z2[0][1] = 77) & (m2[0][1] = 66), "m2[0][1] := 66;");
    z2 := m2; 
    m2[0][1] := 88;           T.Assert((m2[0][1] = 88) & (z2[0][1] = 66), "z2 := m2; m2[0][1] := 88;");
    
    T.End;
  END localAssignment;

  PROCEDURE Run;
  BEGIN 
    a[0] := 7;
    m[0][1] := 77;
    localAssignment(a, m);

    Out.String(" Array Ops on module variables: "); Out.Flush;

    T.First("a"); 

    b[0] := 5; a := b;        T.Assert((b[0] = 5) & (a[0] = b[0]) & (a[1] = b[1]), "b[0] := 5; a := b;");
    a[0] := 6;                T.Assert((b[0] = 5) & (a[0] = 6), "a[0] := 6;");
    d0[1].x := b;             T.Assert(d0[1].x[0] = 5,  "d0[1].x := b;");
    d0[1].x[0] := 10;         T.Assert(d0[1].x[0] = 10, "d0[1].x := 10;");
    a := d0[1].x;             T.Assert(a[0] = 10,       "a := d0[1].x;");
    d0[0].y[1][0] := 11;
    d0[0].y[0] := d0[0].y[1]; T.Assert((d0[0].y[0][0] = 11) & (d0[0].y[0][0] = d0[0].y[1][0]) & (d0[0].y[0][1] = d0[0].y[1][1]), "d0[0].y[1][0] := 11; d0[0].y[0] := d0[0].y[1];");
    d0[0].y[0][0] := 12;      T.Assert((d0[0].y[1][0] = 11) & (d0[0].y[0][0] = 12),      "d0[0].y[0][0] := 12;");
    d1[0].x[1] := 15;
    d0 := d1;                 T.Assert(d0[0].x[1] = 15, "d1[0].x[1] := 15; d0 := d1;");
    d0[0].x[1] := 16;         T.Assert((d1[0].x[1] = 15) & (d0[0].x[1] = 16), "d0[0].x[1] := 16;");
    e1[0][8].x[1] := 25;
    e0 := e1;                 T.Assert((e1[0][8].x[1] = 25) & (e0[0][8].x[1] = 25), "e1[0][8].x[1] := 25; e0 := e1;");
    e0[0][8].x[1] := 26;      T.Assert((e1[0][8].x[1] = 25) & (e0[0][8].x[1] = 26), "e0[0][8].x[1] := 26;");
    
    T.End; Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  T.Register(Run)
END ArrayAssignments.
