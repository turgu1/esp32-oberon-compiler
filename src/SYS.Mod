MODULE SYS;

  CONST 
    OP_ADD* = 1;
    OP_SUB* = 2;
    OP_MUL* = 3;
    OP_DIV* = 4;
    OP_MOD* = 5;

  PROCEDURE IntToReal*(i: INTEGER; VAR r: REAL);
  BEGIN
  END IntToReal;

  PROCEDURE RealToInt*(r: REAL; VAR i: INTEGER);
  BEGIN
  END RealToInt;

  PROCEDURE Exit*(i : INTEGER);
  BEGIN
  END Exit;

  PROCEDURE Assembler*(fromFile, toFile: ARRAY OF CHAR) : INTEGER;
  BEGIN
  RETURN 1
  END Assembler;

  PROCEDURE Int64Op*(op: INTEGER; VAR xlow, xhigh: INTEGER; ylow, yhigh: INTEGER);
  BEGIN
  END Int64Op;

  PROCEDURE StrToInt64*(base: INTEGER; str: ARRAY OF CHAR; VAR xlow, xhigh: INTEGER): BOOLEAN;
  BEGIN
    RETURN TRUE
  END StrToInt64;

END SYS.