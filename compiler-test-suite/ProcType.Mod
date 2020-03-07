MODULE ProcType;
  IMPORT Out;
  TYPE
    P = PROCEDURE(x: INTEGER);
  VAR p : P;
  
  PROCEDURE I(x: INTEGER);
  BEGIN Out.Int(x)
  END I;

  PROCEDURE callP(p: P);
  BEGIN p(9)
  END callP;

BEGIN
  (* p := P; illegal assignment *)
  (* callP(P); illegal value parameter *)
  p := I;
  p(8); (* 8 *)
  callP(I); (* 9 *)
END ProcType.