MODULE SimpleReal;
  IMPORT T := Test, Out;

  PROCEDURE Put(ch: CHAR);
  BEGIN
    Out.Char(ch); Out.Flush
  END Put;

  PROCEDURE Run*;
    VAR i, j, k, l, m, n, o, p, q, r, s, t, u, v, w: REAL;

  BEGIN
    Out.String("SimpleReal: "); Out.Flush;

    (* Operations *)

    i := 7.0 + 3.0;
    j := 7.0 + i;
    k := j + 3.0;
    l := 7.0 - 3.0;
    m := 7.0 - l;
    n := m - 3.0;
    o := 7.0 * 3.0;
    p := 7.0 * o;
    q := p * 3.0;
    r := 100.0 / 3.0;
    s := 330.0 / r;
    t := s / 3.0;

    (* Verifications *)

    T.First("A"); 

    T.Assert(i = 10.0,      "Real k + k");
    T.Assert(j = 17.0,      "Real k + v");
    T.Assert(k = 20.0,      "Real v + k");
    T.Assert(l = 4.0,       "Real k - k");
    T.Assert(m = 3.0,       "Real k - v");
    T.Assert(n = 0.0,       "Real v - k");
    T.Assert(o = 21.0,      "Real k * k");
    T.Assert(p = 147.0,     "Real k * v");
    T.Assert(q = 441.0,     "Real v * k");
    T.Assert(FLOOR(r) = 33, "Real k / k");
    T.Assert(FLOOR(s) = 9,  "Real k / v");
    T.Assert(FLOOR(t) = 3,  "Real v / k");

    (* The End *)
    
    T.End; Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  T.Register(Run)
END SimpleReal.
