MODULE TestCyclicImport11;
  IMPORT Out;
  IMPORT TestCyclicImport12;
  VAR
     i*: INTEGER;
BEGIN
  i := TestCyclicImport12.w
END TestCyclicImport11.
