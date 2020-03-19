MODULE TestCyclicImport12;
  IMPORT Out, TestCyclicImport10;
  VAR
     r0: TestCyclicImport10.R0;
     w*: INTEGER;
BEGIN
  r0.k := 2;
  w := 8
END TestCyclicImport12.
