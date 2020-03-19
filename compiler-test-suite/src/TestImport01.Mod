MODULE TestImport01;
  IMPORT Out;
IMPORT TestImport00;
VAR
   k1: INTEGER;
   a1: ARRAY TestImport00.N OF INTEGER;
   p: TestImport00.Ptr;
BEGIN
  p := NIL;
  k1 := TestImport00.k;
  Out.Int(TestImport00.N);
  Out.Int(k1, 10);
  a1 := TestImport00.a;
  Out.Int(a1[2], 10);
  k1 := TestImport00.P(TestImport00.k);
  Out.Int(k1, 10);
  k1 := TestImport00.b0[1].t.o;
  Out.Int(k1, 10);
  k1 := TestImport00.b1[1].n;
  Out.Int(k1, 10);
END TestImport01.