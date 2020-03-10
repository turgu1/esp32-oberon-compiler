MODULE DefFunc;
  IMPORT Test, Out;

  PROCEDURE Put(ch: CHAR);
  BEGIN
    Out.Char(ch); Out.Flush
  END Put;

  PROCEDURE Run*;
    VAR 
      i, j, k, l, o, p, q, r, s, t, u, v, w, y, z: INTEGER;
      ii, jj, kk, ll, mm, nn: INTEGER;
      a, b, c, d, e, f: REAL;
      m, n: BOOLEAN;
      x : ARRAY 25 OF CHAR;
      aa : CHAR;
      ss, tt, uu, vv: SET;

    PROCEDURE ArrayLen(a: ARRAY OF CHAR): INTEGER;
    BEGIN RETURN LEN(a) END ArrayLen;

  BEGIN
    Out.String("Defined Functions: "); Out.Flush;

    (* Operations *)

    Put("A"); i  := ABS(25);
    Put("B"); j  := ABS(-i);
    Put("C"); a  := ABS(25.0 * 4.0);
    Put("D"); b  := ABS(-a);
    Put("E"); m  := ODD(i);
    Put("F"); n  := ODD(20);
    Put("G"); k  := LEN(x);
    Put("H"); l  := ArrayLen(x);
    Put("I"); o  := LSL(8, 3);
    Put("J"); p  := ASR(-8, 2);
    Put("K"); q  := ROR(0F00300F1H, 4);
    Put("L"); r  := FLOOR(107.1234);
    Put("M"); c  := FLT(7);
    Put("N"); s  := ORD("a");
    Put("O"); t  := ORD(TRUE);
    Put("P"); u  := ORD({2});
    Put("Q"); aa := CHR(97);
    Put("R"); v  := 4; INC(v);
    Put("S"); w  := 3; INC(w, 7);
    Put("T"); y  := 5; DEC(y);
    Put("U"); z  := 7; DEC(z, 3);
    Put("V"); ss := {3, 4}; INCL(ss, 7);
    Put("W"); tt := {3, 4}; EXCL(tt, 3);
    Put("X"); uu := {3, 4}; INCL(uu, i);
    Put("Y"); vv := {3, 4, 25}; EXCL(vv, i);
    Put("Z"); ii := NOT(0F5A32479H);
    Put("A"); jj := AND(0F5A32479H, 0FFFF0000H);
    Put("B"); kk := BOR(0F5A32479H, 0FFFF0000H);
    Put("C"); ll := XOR(0F5A32479H, 0FFFF0000H);
    Put("D"); mm := MIN(5, 7);
    Put("E"); nn := MAX(5, 7);
    Put("F"); d  := MIN(5.0, 7.0);
    Put("G"); e  := MAX(5.0, 7.0);
    Put("H"); f  := SQRT(25.0);
    
    Put("."); 

    (* Verifications *)

    Put("a"); Test.Assert(i = 25,          "Integer ABS(k)");
    Put("b"); Test.Assert(j = 25,          "Integer ABS(v)");
    Put("c"); Test.Assert(a = 100.0,       "Real ABS(k)");
    Put("d"); Test.Assert(b = 100.0,       "Real ABS(v)");
    Put("e"); Test.Assert(m = TRUE,        "ODD(v)");
    Put("f"); Test.Assert(n = FALSE,       "ODD(k)");
    Put("g"); Test.Assert(k = 25,          "LEN(array)");
    Put("h"); Test.Assert(l = 25,          "LEN(param array)");
    Put("i"); Test.Assert(o = 64,          "LSL(k, k)");
    Put("j"); Test.Assert(p = -2,          "ASR(-k, k)");
    Put("k"); Test.Assert(q = 01F00300FH,  "ROR(k, k");
    Put("l"); Test.Assert(r = 107,         "FLOOR(k)");
    Put("m"); Test.Assert(c = 7.0,         "FLT(k)");
    Put("n"); Test.Assert(s = 97,          "ORD(c)");
    Put("o"); Test.Assert(t = 1,           "ORD(bool)");
    Put("p"); Test.Assert(u = 4,           "ORD(set)");
    Put("q"); Test.Assert(aa = "a",        "CHR(k)");
    Put("r"); Test.Assert(v = 5,           "INC(v)");
    Put("s"); Test.Assert(w = 10,          "INC(v, k)");
    Put("t"); Test.Assert(y = 4,           "DEC(v)");
    Put("u"); Test.Assert(z = 4,           "DEC(v, k)");
    Put("v"); Test.Assert(ss = {3, 4, 7},  "INCL(v, k)");
    Put("w"); Test.Assert(tt = {4},        "EXCL(v, k)");
    Put("x"); Test.Assert(uu = {3, 4, 25}, "INCL(v, v)");
    Put("y"); Test.Assert(vv = {3, 4},     "EXCL(v, v)");
    Put("z"); Test.Assert(ii = 00A5CDB86H, "NOT(k)");
    Put("a"); Test.Assert(jj = 0F5A30000H, "AND(k,k)");
    Put("b"); Test.Assert(kk = 0FFFF2479H, "BOR(k,k)");
    Put("c"); Test.Assert(ll = 00A5C2479H, "XOR(k,k)");
    Put("d"); Test.Assert(mm = 5,          "MIN(k,k)");
    Put("e"); Test.Assert(nn = 7,          "MAX(k,k)");
    Put("f"); Test.Assert(d  = 5.0,        "MIN(r,r)");
    Put("g"); Test.Assert(e  = 7.0,        "MAX(r,r)");
    Put("h"); Test.Assert(f  = 5.0,        "SQRT(r)");

    (* The End *)
    
    Put("."); Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  Test.Register(Run)
END DefFunc.
