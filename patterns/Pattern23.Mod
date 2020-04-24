
MODULE Pattern23;
  TYPE 
    P  = POINTER [CDECL] TO INTEGER;
    A  = ARRAY [CDECL] OF CHAR;
    RP = POINTER [CDECL] TO R;
    AP = POINTER [CDECL] TO A;
    R  = RECORD  [CDECL] i, j: INTEGER END;
  VAR 
    i: INTEGER; p: P;
    a: ARRAY [CDECL] 20 OF CHAR;
    b: ARRAY 20 OF CHAR;
    ap: AP; c: CHAR;
    r : R; rp : RP;
BEGIN
  p := i;              (* p receives the address of i  *)
  i := p^ * i;         (* i receives i * i             *)
  a := "Hello World!";
  b := a;
  ap := a;             (* ap receives the address of a *)
  c  := ap^[6];        (* c receives character 'W'     *)
  rp := r;             (* rp receives the adress of r  *)
  i  := rp.i;          (* i receives value of r.i      *)
END Pattern23.