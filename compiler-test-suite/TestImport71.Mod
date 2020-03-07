MODULE TestImport71;
  IMPORT Out;
IMPORT Qs := TestImport70;
TYPE
  ActorDesc* = RECORD (Qs.ItemDesc) END;
VAR a: POINTER TO ActorDesc;
BEGIN NEW(a); a.key := 1; Out.Int(a.key)
END TestImport71.