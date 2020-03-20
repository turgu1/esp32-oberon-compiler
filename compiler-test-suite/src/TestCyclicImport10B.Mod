MODULE TestCyclicImport10;
  IMPORT Out, TestCyclicImport11;

  TYPE R0* = RECORD k*: INTEGER END;
  VAR
     j: INTEGER;
BEGIN
  j := TestCyclicImport11.i
END TestCyclicImport10.
