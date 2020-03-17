OB = ../Oberon

SRCDIR = src
BLDDIR = build

SRC = \
  ArrayAssignment.Mod \
  Arrays2.Mod \
  Arrays3.Mod \
  BitFunc.Mod \
  CaseChar0.Mod \
  CaseNum0.Mod \
  CaseNum1.Mod \
  CaseRecord0.Mod \
  CaseRecord1.Mod \
  CaseRecord2.Mod \
  CaseRecord3.Mod \
  CommutativeSwap.Mod \
  ConstantFoldingAndLoadOp.Mod \
  DivMul.Mod \
  EmptyArrayAndRecord.Mod \
  ExtTypes.Mod \
  Fractions.Mod \
  FragileBaseClass.Mod \
  MagicSquares.Mod \
  OpenArrays.Mod \
  OpenArrays2.Mod \
  OpenArrays3.Mod \
  Out0.Mod \
  Out1.Mod \
  Out2.Mod \
  Out3.Mod \
  Out4.Mod \
  Out5.Mod \
  Out6.Mod \
  OutTest.Mod \
  Pattern1.Mod \
  Pattern2a.Mod \
  Pattern2b.Mod \
  Pattern2c.Mod \
  Permutations.Mod \
  Powers.Mod \
  PrimeNumbers.Mod \
  ProcComparisons.Mod \
  ProcType.Mod \
  ProcVariables0.Mod \
  ProcVariables1.Mod \
  ProcVariables2.Mod \
  ProcVariables3.Mod \
  ProcVariables4.Mod \
  ProcVariables5.Mod \
  ProcVariables6.Mod \
  ProcVariables7.Mod \
  RealExpressions.Mod \
  RecordAndTypeExtension.Mod \
  RecordAssignment.Mod \
  RecordAssignment2.Mod \
  RecordParam.Mod \
  Samples0.Mod \
  Samples1.Mod \
  Samples2.Mod \
  SetTest.Mod \
  Strings.Mod \
  Strings0.Mod \
  Strings1.Mod \
  Strings2.Mod \
  TestABS.Mod \
  TestAnonymousName.Mod \
  TestAssert.Mod \
  TestAssignmentMix.Mod \
  TestByteType.Mod \
  TestCPS.Mod \
  TestCmdLineArgs.Mod \
  TestConstFunc.Mod \
  TestCyclicImport00A.Mod \
  TestCyclicImport00B.Mod \
  TestCyclicImport01A.Mod \
  TestCyclicImport01B.Mod \
  TestCyclicImport10A.Mod \
  TestCyclicImport10B.Mod \
  TestCyclicImport11.Mod \
  TestCyclicImport12.Mod \
  TestEqualSignature00.Mod \
  TestExprVarPar.Mod \
  TestFor.Mod \
  TestFor1.Mod \
  TestFunction0.Mod \
  TestINC0.Mod \
  TestINC1.Mod \
  TestINCLAndEXCL.Mod \
  TestImport00.Mod \
  TestImport01.Mod \
  TestImport10.Mod \
  TestImport100.Mod \
  TestImport11.Mod \
  TestImport110.Mod \
  TestImport111.Mod \
  TestImport112.Mod \
  TestImport120.Mod \
  TestImport121.Mod \
  TestImport122.Mod \
  TestImport130.Mod \
  TestImport131.Mod \
  TestImport140.Mod \
  TestImport141.Mod \
  TestImport142.Mod \
  TestImport150.Mod \
  TestImport151.Mod \
  TestImport20.Mod \
  TestImport21.Mod \
  TestImport22.Mod \
  TestImport30.Mod \
  TestImport31.Mod \
  TestImport40.Mod \
  TestImport41.Mod \
  TestImport42.Mod \
  TestImport50.Mod \
  TestImport51.Mod \
  TestImport52.Mod \
  TestImport53.Mod \
  TestImport60.Mod \
  TestImport61.Mod \
  TestImport62.Mod \
  TestImport70.Mod \
  TestImport71.Mod \
  TestImport80.Mod \
  TestImport81.Mod \
  TestImport82.Mod \
  TestImport90.Mod \
  TestImport91.Mod \
  TestNestedProcs.Mod \
  TestODD.Mod \
  TestOOP.Mod \
  TestReadOnlyPar.Mod \
  TestReturn0.Mod \
  TestShift.Mod \
  TestStringsMod.Mod \
  TestSystemVal.Mod \
  TestTypeConvFun.Mod \
  TestTypeGuardExt.Mod \
  TestTypeTest.Mod \
  UniqueTypeAndProcNames.Mod \
  VarInit.Mod \
  VarParGuard.Mod

#	Pattern13.Mod

SRCS = $(addprefix $(SRCDIR)/, $(SRC))
SYMS = $(addprefix $(SRCDIR)/, $(SRC:.Mod=.smb))
ASSS = $(addprefix $(BLDDIR)/, $(SRC:.Mod=.S))

$(BLDDIR)/%.S : $(SRCDIR)/%.Mod
	$(OB) -o $(BLDDIR) -p ../lib -s $<

.PHONY: all
all: $(ASSS)

clean:
	rm build/*
	rm src/*.smb
