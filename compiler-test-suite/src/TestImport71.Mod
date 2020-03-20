MODULE TestImport71;
  IMPORT Out, Qs := TestImport70;
TYPE
  ActorDesc* = RECORD (Qs.ItemDesc) END;
VAR a: POINTER TO ActorDesc;
BEGIN NEW(a); a.key := 1; Out.Int(a.key, 10)
END TestImport71.