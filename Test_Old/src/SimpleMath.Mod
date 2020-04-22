MODULE SimpleMath;
  IMPORT T := Test, Out;

  PROCEDURE Run*;
    VAR i, j, k, l, m, n, o, p, q, r, s, t, u, v, w: INTEGER;

  BEGIN
    Out.String("SimpleMath: "); Out.Flush;

    (* Operations *)

    i := 7 + 3;
    j := 7 + i;
    k := j + 3;
    l := 7 - 3;
    m := 7 - l;
    n := m - 3;
    o := 7 * 3;
    p := 7 * o;
    q := p * 3;
    r := 100 DIV 3;
    s := 330 DIV r;
    t := s DIV 3;
    u := 115 MOD 9;
    v := 330 MOD u;
    w := u MOD 3;

    (* Verifications *)

    T.First("A"); 
    
    T.Assert(i = 10,  "Integer k + k");
    T.Assert(j = 17,  "Integer k + v");
    T.Assert(k = 20,  "Integer v + k");
    T.Assert(l = 4,   "Integer k - k");
    T.Assert(m = 3,   "Integer k - v");
    T.Assert(n = 0,   "Integer v - k");
    T.Assert(o = 21,  "Integer k * k");
    T.Assert(p = 147, "Integer k * v");
    T.Assert(q = 441, "Integer v * k");
    T.Assert(r = 33,  "Integer k DIV k");
    T.Assert(s = 10,  "Integer k DIV v");
    T.Assert(t = 3,   "Integer v DIV k");
    T.Assert(u = 7,   "Integer k MOD k");
    T.Assert(v = 1,   "Integer k MOD v");
    T.Assert(w = 1,   "Integer v MO k");

    (* The End *)
    
    T.End; Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  T.Register(Run)
END SimpleMath.
