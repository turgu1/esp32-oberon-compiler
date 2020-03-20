MODULE TestImport142;
  IMPORT Out, I0 := TestImport140, I1 := TestImport141;

TYPE PtrRec1 = POINTER TO I1.Rec1;

VAR
  r0: POINTER TO I0.Rec0;
  r1: PtrRec1;

BEGIN
  NEW(r1);
  r0 := r1;
  IF r0 IS PtrRec1 THEN Out.Int(1, 10) END;
  r1.a := 2;
  r1.b := "3";
  r1.c := 4.0;
  r1.d[1] := 5;
  r1.e := TRUE;
  r1.f := 6;
  Out.Int(r1.a, 10);
  Out.Char(r1.b);
  Out.Real(r1.c, 10);
  Out.Int(r1.d[1], 10);
  Out.Int(ORD(r1.e), 10);
  Out.Int(r1.f, 10)
END TestImport142.
