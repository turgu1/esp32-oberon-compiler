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

    T.First("A"); i  := ABS(25);
    T.Next;       j  := ABS(-i);
    T.Next;       a  := ABS(25.0 * 4.0);
    T.Next;       b  := ABS(-a);
    T.Next;       m  := ODD(i);
    T.Next;       n  := ODD(20);
    T.Next;       k  := LEN(x);
    T.Next;       l  := ArrayLen(x);
    T.Next;       o  := LSL(8, 3);
    T.Next;       p  := ASR(-8, 2);
    T.Next;       q  := ROR(0F00300F1H, 4);
    T.Next;       r  := FLOOR(107.1234);
    T.Next;       c  := FLT(7);
    T.Next;       s  := ORD("a");
    T.Next;       t  := ORD(TRUE);
    T.Next;       u  := ORD({2});
    T.Next;       aa := CHR(97);
    T.Next;       v  := 4; INC(v);
    T.Next;       w  := 3; INC(w, 7);
    T.Next;       y  := 5; DEC(y);
    T.Next;       z  := 7; DEC(z, 3);
    T.Next;       ss := {3, 4}; INCL(ss, 7);
    T.Next;       tt := {3, 4}; EXCL(tt, 3);
    T.Next;       uu := {3, 4}; INCL(uu, i);
    T.Next;       vv := {3, 4, 25}; EXCL(vv, i);
    T.Next;       ii := NOT(0F5A32479H);
    T.Next;       jj := AND(0F5A32479H, 0FFFF0000H);
    T.Next;       kk := BOR(0F5A32479H, 0FFFF0000H);
    T.Next;       ll := XOR(0F5A32479H, 0FFFF0000H);
    T.Next;       mm := MIN(5, 7);
    T.Next;       nn := MAX(5, 7);
    T.Next;       d  := MIN(5.0, 7.0);
    T.Next;       e  := MAX(5.0, 7.0);
    T.Next;       f  := SQRT(25.0);
    
    T.End; 

    (* Verifications *)

    T.First("a"); T.Assert(i = 25,          "Integer ABS(k)");
    T.Next;       T.Assert(j = 25,          "Integer ABS(v)");
    T.Next;       T.Assert(a = 100.0,       "Real ABS(k)");
    T.Next;       T.Assert(b = 100.0,       "Real ABS(v)");
    T.Next;       T.Assert(m = TRUE,        "ODD(v)");
    T.Next;       T.Assert(n = FALSE,       "ODD(k)");
    T.Next;       T.Assert(k = 25,          "LEN(array)");
    T.Next;       T.Assert(l = 25,          "LEN(param array)");
    T.Next;       T.Assert(o = 64,          "LSL(k, k)");
    T.Next;       T.Assert(p = -2,          "ASR(-k, k)");
    T.Next;       T.Assert(q = 01F00300FH,  "ROR(k, k");
    T.Next;       T.Assert(r = 107,         "FLOOR(k)");
    T.Next;       T.Assert(c = 7.0,         "FLT(k)");
    T.Next;       T.Assert(s = 97,          "ORD(c)");
    T.Next;       T.Assert(t = 1,           "ORD(bool)");
    T.Next;       T.Assert(u = 4,           "ORD(set)");
    T.Next;       T.Assert(aa = "a",        "CHR(k)");
    T.Next;       T.Assert(v = 5,           "INC(v)");
    T.Next;       T.Assert(w = 10,          "INC(v, k)");
    T.Next;       T.Assert(y = 4,           "DEC(v)");
    T.Next;       T.Assert(z = 4,           "DEC(v, k)");
    T.Next;       T.Assert(ss = {3, 4, 7},  "INCL(v, k)");
    T.Next;       T.Assert(tt = {4},        "EXCL(v, k)");
    T.Next;       T.Assert(uu = {3, 4, 25}, "INCL(v, v)");
    T.Next;       T.Assert(vv = {3, 4},     "EXCL(v, v)");
    T.Next;       T.Assert(ii = 00A5CDB86H, "NOT(k)");
    T.Next;       T.Assert(jj = 0F5A30000H, "AND(k,k)");
    T.Next;       T.Assert(kk = 0FFFF2479H, "BOR(k,k)");
    T.Next;       T.Assert(ll = 00A5C2479H, "XOR(k,k)");
    T.Next;       T.Assert(mm = 5,          "MIN(k,k)");
    T.Next;       T.Assert(nn = 7,          "MAX(k,k)");
    T.Next;       T.Assert(d  = 5.0,        "MIN(r,r)");
    T.Next;       T.Assert(e  = 7.0,        "MAX(r,r)");
    T.Next;       T.Assert(f  = 5.0,        "SQRT(r)");

    (* The End *)
    
    T.End; Out.String(" End"); Out.Ln;
  END Run;

BEGIN
  T.Register(Run)
END DefFunc.
