MODULE SimpleMath;
  IMPORT Test, Out;

  PROCEDURE Put(ch: CHAR);
  BEGIN
    Out.Char(ch); Out.Flush
  END Put;

  PROCEDURE Run*;
    VAR i, j, k, l, m, n, o, p, q, r, s, t, u, v, w: INTEGER;

  BEGIN
    Out.String("SimpleMath: "); Out.Flush;

    (* Operations *)

    Put("A"); i := 7 + 3;
    Put("B"); j := 7 + i;
    Put("C"); k := j + 3;
    Put("D"); l := 7 - 3;
    Put("E"); m := 7 - l;
    Put("F"); n := m - 3;
    Put("G"); o := 7 * 3;
    Put("H"); p := 7 * o;
    Put("I"); q := p * 3;
    Put("J"); r := 100 DIV 3;
    Put("K"); s := 330 DIV r;
    Put("L"); t := s DIV 3;
    Put("M"); u := 115 MOD 9;
    Put("N"); v := 330 MOD u;
    Put("O"); w := u MOD 3;

    Put(".");

    (* Verifications *)

    Put("a"); Test.Assert(i = 10,        "Integer k + k");
    Put("b"); Test.Assert(j = 17,        "Integer k + v");
    Put("c"); Test.Assert(k = 20,        "Integer v + k");
    Put("d"); Test.Assert(l = 4,         "Integer k - k");
    Put("e"); Test.Assert(m = 3,         "Integer k - v");
    Put("f"); Test.Assert(n = 0,         "Integer v - k");
    Put("g"); Test.Assert(o = 21,        "Integer k * k");
    Put("h"); Test.Assert(p = 147,       "Integer k * v");
    Put("i"); Test.Assert(q = 441,       "Integer v * k");
    Put("j"); Test.Assert(r = 33,        "Integer k DIV k");
    Put("k"); Test.Assert(s = 10,        "Integer k DIV v");
    Put("l"); Test.Assert(t = 3,         "Integer v DIV k");
    Put("m"); Test.Assert(u = 7,         "Integer k MOD k");
    Put("n"); Test.Assert(v = 1,         "Integer k MOD v");
    Put("o"); Test.Assert(w = 1,         "Integer v MO k");

    (* The End *)
    
    Put("."); Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  Test.Register(Run)
END SimpleMath.
