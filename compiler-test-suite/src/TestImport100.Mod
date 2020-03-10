MODULE TestImport100;
  IMPORT S := SYSTEM, Out;
  VAR
    s: SET;
BEGIN
  s := {1};
  Out.Int(S.VAL(INTEGER, s));
END TestImport100.