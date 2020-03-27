.SECONDARY:  # Keep intermediary files

TOOLCHAIN = xtensa-esp32-elf-

ASFLAGS_PLATFORM  = -mlongcalls -mauto-litpools -mtext-section-literals -fstrict-volatile-bitfields
LDFLAGS_PLATFORM = $(AFLAGS_PLATFORM)

###
# General project build
###
OB = ../Oberon
CC = $(TOOLCHAIN)gcc
LD = $(TOOLCHAIN)ld
OC = $(TOOLCHAIN)objcopy
OS = $(TOOLCHAIN)size

BLDDIR = ./build
SRCDIR = ./src
LIBDIR = ../lib

ESP32LIB = esp32-oberon
# Linker script location.
LDSCRIPT = $(LIBDIR)/ld/esp32.ld
LDFLAGS += -nostdlib -T$(LDSCRIPT) -Wl,-Map=$@.map -Wl,--cref -Wl,--gc-sections
LDFLAGS += $(LDFLAGS_PLATFORM)
LDFLAGS += -L$(LIBDIR) -l$(ESP32LIB)

ASFLAGS += -c -O0 -Wall -fmessage-length=0
ASFLAGS += $(ASFLAGS_PLATFORM)
ASFLAGS += -g

OBFLAGS = -o $(BLDDIR) -p $(LIBDIR) -s -c -l

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
  TestConstFunc.Mod \
  TestEqualSignature00.Mod \
  TestFor.Mod \
  TestFor1.Mod \
  TestFunction0.Mod \
  TestINC0.Mod \
  TestINC1.Mod \
  TestINCLAndEXCL.Mod \
  TestImport00.Mod \
  TestImport10.Mod \
  TestImport100.Mod \
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
  TestImport150.Mod \
  TestImport20.Mod \
  TestImport21.Mod \
  TestImport22.Mod \
  TestImport30.Mod \
  TestImport31.Mod \
  TestImport40.Mod \
  TestImport41.Mod \
  TestImport50.Mod \
  TestImport51.Mod \
  TestImport52.Mod \
  TestImport53.Mod \
  TestImport60.Mod \
  TestImport61.Mod \
  TestImport70.Mod \
  TestImport71.Mod \
  TestImport81.Mod \
  TestImport82.Mod \
  TestImport80.Mod \
  TestImport90.Mod \
  TestNestedProcs.Mod \
  TestODD.Mod \
  TestReturn0.Mod \
  TestShift.Mod \
  TestStringsMod.Mod \
  TestSystemVal.Mod \
  TestTypeConvFun.Mod \
  TestTypeTest.Mod \
  VarInit.Mod
  # VarParGuard.Mod

Others = \
	TestCyclicImport00.S \
	TestCyclicImport01.S \
	TestCyclicImport10.S

Others2 = \
	TestCyclicImport00B.Mod \
	TestCyclicImport12.Mod \
	TestCyclicImport11.Mod \
  TestImport01.Mod \
  TestImport11.Mod \
  TestImport42.Mod \
  TestImport62.Mod \
  TestImport91.Mod \
  TestTypeGuardExt.Mod \
  UniqueTypeAndProcNames.Mod \
  
#	Pattern13.Mod

SRCS = $(addprefix $(SRCDIR)/, $(SRC))
SYMS = $(addprefix $(SRCDIR)/, $(SRC:.Mod=.smb))
ASSS = $(addprefix $(BLDDIR)/, $(SRC:.Mod=.S))
OBJS = $(ASSS:.S=.o)
EXECS = $(ASSS:.S=.elf)
OTHERS = $(addprefix $(BLDDIR)/, $(Others))

$(BLDDIR)/%.S : $(SRCDIR)/%.Mod
	$(OB) $(OBFLAGS) $<

$(BLDDIR)/%.o : $(BLDDIR)/%.S
	@$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

$(BLDDIR)/%.elf : $(BLDDIR)/%.o
	$(CC) $^ $(LDFLAGS) -o $@

.PHONY: all
all: oth $(EXECS) 

$(BLDDIR)/TestCyclicImport00.S : $(SRCDIR)/TestCyclicImport00A.Mod
	$(OB) $(OBFLAGS) $<

$(BLDDIR)/TestCyclicImport01.S : $(SRCDIR)/TestCyclicImport01B.Mod
	$(OB) $(OBFLAGS) $<

$(BLDDIR)/TestCyclicImport10.S : $(SRCDIR)/TestCyclicImport10A.Mod
	$(OB) $(OBFLAGS) $<

.PHONY: oth
oth: $(OTHERS)

clean:
	rm build/*
	rm src/*.smb
