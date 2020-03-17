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

    T.First("A"); i := 7.0 + 3.0;
    T.Next;       j := 7.0 + i;
    T.Next;       k := j + 3.0;
    T.Next;       l := 7.0 - 3.0;
    T.Next;       m := 7.0 - l;
    T.Next;       n := m - 3.0;
    T.Next;       o := 7.0 * 3.0;
    T.Next;       p := 7.0 * o;
    T.Next;       q := p * 3.0;
    T.Next;       r := 100.0 / 3.0;
    T.Next;       s := 330.0 / r;
    T.Next;       t := s / 3.0;

    Put(".");

    (* Verifications *)

    T.First("a"); T.Assert(i = 10.0,      "Real k + k");
    T.Next;       T.Assert(j = 17.0,      "Real k + v");
    T.Next;       T.Assert(k = 20.0,      "Real v + k");
    T.Next;       T.Assert(l = 4.0,       "Real k - k");
    T.Next;       T.Assert(m = 3.0,       "Real k - v");
    T.Next;       T.Assert(n = 0.0,       "Real v - k");
    T.Next;       T.Assert(o = 21.0,      "Real k * k");
    T.Next;       T.Assert(p = 147.0,     "Real k * v");
    T.Next;       T.Assert(q = 441.0,     "Real v * k");
    T.Next;       T.Assert(FLOOR(r) = 33, "Real k / k");
    T.Next;       T.Assert(FLOOR(s) = 9,  "Real k / v");
    T.Next;       T.Assert(FLOOR(t) = 3,  "Real v / k");

    (* The End *)
    
    T.End; Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  T.Register(Run)
END SimpleReal.
