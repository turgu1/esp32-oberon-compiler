MODULE SimpleReal;
  IMPORT Test, Out;

  PROCEDURE Put(ch: CHAR);
  BEGIN
    Out.Char(ch); Out.Flush
  END Put;

  PROCEDURE Run*;
    VAR i, j, k, l, m, n, o, p, q, r, s, t, u, v, w: REAL;

  BEGIN
    Out.String("SimpleReal: "); Out.Flush;

    (* Operations *)

    Put("A"); i := 7.0 + 3.0;
    Put("B"); j := 7.0 + i;
    Put("C"); k := j + 3.0;
    Put("D"); l := 7.0 - 3.0;
    Put("E"); m := 7.0 - l;
    Put("F"); n := m - 3.0;
    Put("G"); o := 7.0 * 3.0;
    Put("H"); p := 7.0 * o;
    Put("I"); q := p * 3.0;
    Put("J"); r := 100.0 / 3.0;
    Put("K"); s := 330.0 / r;
    Put("L"); t := s / 3.0;

    Put(".");

    (* Verifications *)

    Put("a"); Test.Assert(i = 10.0,        "Real k + k");
    Put("b"); Test.Assert(j = 17.0,        "Real k + v");
    Put("c"); Test.Assert(k = 20.0,        "Real v + k");
    Put("d"); Test.Assert(l = 4.0,         "Real k - k");
    Put("e"); Test.Assert(m = 3.0,         "Real k - v");
    Put("f"); Test.Assert(n = 0.0,         "Real v - k");
    Put("g"); Test.Assert(o = 21.0,        "Real k * k");
    Put("h"); Test.Assert(p = 147.0,       "Real k * v");
    Put("i"); Test.Assert(q = 441.0,       "Real v * k");
    Put("j"); Test.Assert(FLOOR(r) = 33,   "Real k / k");
    Put("k"); Test.Assert(FLOOR(s) = 9,    "Real k / v");
    Put("l"); Test.Assert(FLOOR(t) = 3,    "Real v / k");

    (* The End *)
    
    Put("."); Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  Test.Register(Run)
END SimpleReal.
