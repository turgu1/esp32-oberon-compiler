
# Use the xtensa-esp32-elf toolchain defined in makefile.inc

include makefile.inc

# The last module in the list is the main program. Modules must
# be put in the reverse order of dependencies to insure that
# IMPORT statements wont fail.
#
# All modules listed must be identified without the extension. All module
# files must have extension .Mod

MAIN = Main
OTHERS = \
  Out
SRC = $(OTHERS) $(MAIN)

INIT = $(SRCDIR)/init.S
INITO = $(BLDDIR)/init.o

TBL = init_table
TBLO = $(BLDDIR)/$(TBL).o

MATH = $(SRCDIR)/math_support.S
MATHO = $(BLDDIR)/math_support.o

SRCS = $(addsuffix .Mod, $(addprefix $(SRCDIR)/, $(SRC)))
SYMS = $(addsuffix .smb, $(addprefix $(BLDDIR)/, $(SRC)))
OBJS = $(addsuffix .o, $(addprefix $(BLDDIR)/, $(SRC)))

ARCHIVE = liboberon.a

OBERON_PATH = $(BLDDIR)

# Rules to build files.

$(INITO): $(INIT)
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@
	$(AR) r $(ARCHIVE) $@ 

$(MATHO): $(MATH)
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@
	$(AR) r $(ARCHIVE) $@ 

$(TBLO):
	$(OIORDER) -p $(OBERON_PATH) -o $(BLDDIR) -O $(TBL) $(MAIN) $(OTHERS)
	$(AR) r $(ARCHIVE) $@ 

.PHONY: $(BLDDIR)
$(BLDDIR):
	mkdir -p $(BLDDIR)

$(ARCHIVE) : $(BLDDIR) $(OBJS) $(INITO) $(TBLO) $(MATHO)
	$(RL) $(ARCHIVE)

# Target to clean build artifacts.
.PHONY: clean
clean:
	-rm -f $(BLDDIR)/*
	-rm $(ARCHIVE)
