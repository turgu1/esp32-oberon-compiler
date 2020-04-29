MODULE Pattern24;

TYPE
  CP = POINTER   [CDECL] TO CHAR;
  TP = POINTER   [CDECL] TO BOOLEAN;
  BP = POINTER   [CDECL] TO BYTE;
  SP = POINTER   [CDECL] TO SHORTINT;
  IP = POINTER   [CDECL] TO INTEGER;
  FP = POINTER   [CDECL] TO REAL;
  A  = ARRAY     [CDECL] 20 OF CHAR;
  AP = POINTER   [CDECL] TO A;
  R  = RECORD    [CDECL] i, j: INTEGER; ap: AP END;
  RP = POINTER   [CDECL] TO R;
  C  = PROCEDURE [CDECL] (i: INTEGER; a: A);

  CA = ARRAY [CDECL] 20 OF CHAR;
  TA = ARRAY [CDECL] 20 OF BOOLEAN;
  BA = ARRAY [CDECL] 20 OF BYTE;
  SA = ARRAY [CDECL] 20 OF SHORTINT;
  IA = ARRAY [CDECL] 20 OF INTEGER;
  FA = ARRAY [CDECL] 20 OF REAL;
  EA = ARRAY [CDECL] 20 OF SET;
  
  CA2 = ARRAY [CDECL] 20, 5 OF CHAR;
  TA2 = ARRAY [CDECL] 20, 5 OF BOOLEAN;
  BA2 = ARRAY [CDECL] 20, 5 OF BYTE;
  SA2 = ARRAY [CDECL] 20, 5 OF SHORTINT;
  IA2 = ARRAY [CDECL] 20, 5 OF INTEGER;
  FA2 = ARRAY [CDECL] 20, 5 OF REAL;
  EA2 = ARRAY [CDECL] 20, 5 OF SET;

  CAO = ARRAY 20 OF CHAR;
  TAO = ARRAY 20 OF BOOLEAN;
  BAO = ARRAY 20 OF BYTE;
  SAO = ARRAY 20 OF SHORTINT;
  IAO = ARRAY 20 OF INTEGER;
  FAO = ARRAY 20 OF REAL;
  EAO = ARRAY 20 OF SET;
  
  CA2O = ARRAY 20, 5 OF CHAR;
  TA2O = ARRAY 20, 5 OF BOOLEAN;
  BA2O = ARRAY 20, 5 OF BYTE;
  SA2O = ARRAY 20, 5 OF SHORTINT;
  IA2O = ARRAY 20, 5 OF INTEGER;
  FA2O = ARRAY 20, 5 OF REAL;
  EA2O = ARRAY 20, 5 OF SET;

VAR
  ch    : CHAR;
  bool  : BOOLEAN;
  byte  : BYTE;
  short : SHORTINT;
  int   : INTEGER;
  real  : REAL;
  arr   : ARRAY 20 OF CHAR;
  rec   : RECORD i, j: INTEGER END;

  cp    : CP;
  tp    : TP;
  bp    : BP;
  sp    : SP;
  ip    : IP;
  fp    : FP;
  a     : A;
  ap    : AP;
  r     : R;
  rp    : RP;
  c     : C;

  ca: CA; ca2: CA2; cao: CAO; ca2o: CA2O;
  ta: TA; ta2: TA2; tao: TAO; ta2o: TA2O;
  ba: BA; ba2: BA2; bao: BAO; ba2o: BA2O;
  sa: SA; sa2: SA2; sao: SAO; sa2o: SA2O;
  ia: IA; ia2: IA2; iao: IAO; ia2o: IA2O;
  fa: FA; fa2: FA2; fao: FAO; fa2o: FA2O;
  ea: EA; ea2: EA2; eao: EAO; ea2o: EA2O;

PROCEDURE [CDECL] test (i: INTEGER; a: A);

BEGIN
  cp := ch;
  tp := bool;
  bp := byte;
  sp := short;
  ip := int;
  fp := real;
  ap := a;
  rp := r;
  c  := test;

  ca := cao; ca2 := ca2o; cao := ca; ca2o := ca2;
  ta := tao; ta2 := ta2o; tao := ta; ta2o := ta2;
  ba := bao; ba2 := ba2o; bao := ba; ba2o := ba2;
  sa := sao; sa2 := sa2o; sao := sa; sa2o := sa2;
  ia := iao; ia2 := ia2o; iao := ia; ia2o := ia2;
  fa := fao; fa2 := fa2o; fao := fa; fa2o := fa2;
  ea := eao; ea2 := ea2o; eao := ea; ea2o := ea2;

END Pattern24.