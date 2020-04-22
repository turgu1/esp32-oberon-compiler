
# Uses the xtensa-esp32-elf toolchain defined in makefile.inc

include makefile.inc

# The last module in the list is the main program. 
#
# All modules listed must be identified without the extension. All module
# files must have extension .Mod

MAIN = Main
OTHERS =      \
	Test        \
	Case        \
	Pointer     \
	BitFunc     \
	ArrayAssignments \
	ShortInt    \
	Byte        \
	DefFunc     \
	SimpleReal  \
	SimpleMath  \
	Assignments

SRC = $(OTHERS) $(MAIN)

INIT = $(SRCDIR)/init.S
INITO = $(BLDDIR)/init.o

TBL = init_table
TBLO = $(BLDDIR)/$(TBL).o

OBJS = $(addsuffix .o, $(addprefix $(BLDDIR)/, $(SRC)))

ARCHIVE = liboberon.a

# OBERON_PATH MUST be defined to properly initialise the search path
# used both with the OberonESP32 compiler and the OIOrderESP32 apps.

OBERON_PATH = $(BLDDIR)

# Rules to build files.

$(INITO): $(INIT)
	$(CC) $(ASFLAGS) $< -o $@
	@$(AR) r $(ARCHIVE) $@ 

$(TBLO):
	$(OIORDER) -p $(OBERON_PATH):$(OBERON_LIB_DIR) -o $(BLDDIR) -O $(TBL) $(MAIN) $(OTHERS)
	$(AR) r $(ARCHIVE) $@ 

.PHONY: $(BLDDIR)
$(BLDDIR):
	mkdir -p $(BLDDIR)

$(ARCHIVE) : $(BLDDIR) $(OBJS) $(INITO) $(TBLO)
	$(RL) $(ARCHIVE)

# Target to clean build artifacts.
.PHONY: clean
clean:
	-rm -f $(BLDDIR)/*
	-rm $(ARCHIVE)
