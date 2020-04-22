MODULE DefFunc;
  IMPORT T := Test, Out;

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

    i  := ABS(25);
    j  := ABS(-i);
    a  := ABS(25.0 * 4.0);
    b  := ABS(-a);
    m  := ODD(i);
    n  := ODD(20);
    k  := LEN(x);
    l  := ArrayLen(x);
    o  := LSL(8, 3);
    p  := ASR(-8, 2);
    q  := ROR(0F00300F1H, 4);
    r  := FLOOR(107.1234);
    c  := FLT(7);
    s  := ORD("a");
    t  := ORD(TRUE);
    u  := ORD({2});
    aa := CHR(97);
    v  := 4; INC(v);
    w  := 3; INC(w, 7);
    y  := 5; DEC(y);
    z  := 7; DEC(z, 3);
    ss := {3, 4}; INCL(ss, 7);
    tt := {3, 4}; EXCL(tt, 3);
    uu := {3, 4}; INCL(uu, i);
    vv := {3, 4, 25}; EXCL(vv, i);
    ii := NOT(0F5A32479H);
    jj := AND(0F5A32479H, 0FFFF0000H);
    kk := BOR(0F5A32479H, 0FFFF0000H);
    ll := XOR(0F5A32479H, 0FFFF0000H);
    mm := MIN(5, 7);
    nn := MAX(5, 7);
    d  := MIN(5.0, 7.0);
    e  := MAX(5.0, 7.0);
    f  := SQRT(25.0);

    (* Verifications *)

    T.First("A"); 

    T.Assert(i = 25,          "Integer ABS(k)");
    T.Assert(j = 25,          "Integer ABS(v)");
    T.Assert(a = 100.0,       "Real ABS(k)");
    T.Assert(b = 100.0,       "Real ABS(v)");
    T.Assert(m = TRUE,        "ODD(v)");
    T.Assert(n = FALSE,       "ODD(k)");
    T.Assert(k = 25,          "LEN(array)");
    T.Assert(l = 25,          "LEN(param array)");
    T.Assert(o = 64,          "LSL(k, k)");
    T.Assert(p = -2,          "ASR(-k, k)");
    T.Assert(q = 01F00300FH,  "ROR(k, k");
    T.Assert(r = 107,         "FLOOR(k)");
    T.Assert(c = 7.0,         "FLT(k)");
    T.Assert(s = 97,          "ORD(c)");
    T.Assert(t = 1,           "ORD(bool)");
    T.Assert(u = 4,           "ORD(set)");
    T.Assert(aa = "a",        "CHR(k)");
    T.Assert(v = 5,           "INC(v)");
    T.Assert(w = 10,          "INC(v, k)");
    T.Assert(y = 4,           "DEC(v)");
    T.Assert(z = 4,           "DEC(v, k)");
    T.Assert(ss = {3, 4, 7},  "INCL(v, k)");
    T.Assert(tt = {4},        "EXCL(v, k)");
    T.Assert(uu = {3, 4, 25}, "INCL(v, v)");
    T.Assert(vv = {3, 4},     "EXCL(v, v)");
    T.Assert(ii = 00A5CDB86H, "NOT(k)");
    T.Assert(jj = 0F5A30000H, "AND(k,k)");
    T.Assert(kk = 0FFFF2479H, "BOR(k,k)");
    T.Assert(ll = 00A5C2479H, "XOR(k,k)");
    T.Assert(mm = 5,          "MIN(k,k)");
    T.Assert(nn = 7,          "MAX(k,k)");
    T.Assert(d  = 5.0,        "MIN(r,r)");
    T.Assert(e  = 7.0,        "MAX(r,r)");
    T.Assert(f  = 5.0,        "SQRT(r)");

    (* The End *)
    
    T.End; Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  T.Register(Run)
END DefFunc.
