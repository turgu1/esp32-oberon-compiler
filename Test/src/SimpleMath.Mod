MODULE SimpleMath;
  IMPORT T := Test, Out;

  PROCEDURE Run*;
    VAR i, j, k, l, m, n, o, p, q, r, s, t, u, v, w: INTEGER;

  BEGIN
    Out.String("SimpleMath: "); Out.Flush;

    (* Operations *)

    T.First("A"); i := 7 + 3;
    T.Next;       j := 7 + i;
    T.Next;       k := j + 3;
    T.Next;       l := 7 - 3;
    T.Next;       m := 7 - l;
    T.Next;       n := m - 3;
    T.Next;       o := 7 * 3;
    T.Next;       p := 7 * o;
    T.Next;       q := p * 3;
    T.Next;       r := 100 DIV 3;
    T.Next;       s := 330 DIV r;
    T.Next;       t := s DIV 3;
    T.Next;       u := 115 MOD 9;
    T.Next;       v := 330 MOD u;
    T.Next;       w := u MOD 3;

    T.End;

    (* Verifications *)

    T.First("a"); T.Assert(i = 10,  "Integer k + k");
    T.Next;       T.Assert(j = 17,  "Integer k + v");
    T.Next;       T.Assert(k = 20,  "Integer v + k");
    T.Next;       T.Assert(l = 4,   "Integer k - k");
    T.Next;       T.Assert(m = 3,   "Integer k - v");
    T.Next;       T.Assert(n = 0,   "Integer v - k");
    T.Next;       T.Assert(o = 21,  "Integer k * k");
    T.Next;       T.Assert(p = 147, "Integer k * v");
    T.Next;       T.Assert(q = 441, "Integer v * k");
    T.Next;       T.Assert(r = 33,  "Integer k DIV k");
    T.Next;       T.Assert(s = 10,  "Integer k DIV v");
    T.Next;       T.Assert(t = 3,   "Integer v DIV k");
    T.Next;       T.Assert(u = 7,   "Integer k MOD k");
    T.Next;       T.Assert(v = 1,   "Integer k MOD v");
    T.Next;       T.Assert(w = 1,   "Integer v MO k");

    (* The End *)
    
    T.End; Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  T.Register(Run)
END SimpleMath.
