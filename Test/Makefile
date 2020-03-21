# 'Bare metal' ESP32 application Makefile
# Use the xtensa-esp32-elf toolchain.
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

OS = $(shell uname -s)
ifeq ($(OS), Darwin)
  PORT = /dev/tty.SLAB_USBtoUART
else
  PORT = /dev/ttyUSB0
endif

INIT = init/init.S
INITO = $(BLDDIR)/init.o

# The first module in the list is the main program
SRC =  \
	Main.Mod \
	Byte.Mod \
	DefFunc.Mod \
	SimpleReal.Mod \
	SimpleMath.Mod \
	Assignments.Mod \
	Test.Mod

OBJS = $(addprefix $(BLDDIR)/, $(SRC:.Mod=.o))

TARGETELF = $(BLDDIR)/tests.elf
TARGETBIN = $(BLDDIR)/tests.bin

.PHONY: all
all: $(TARGETELF)

# Rules to build files.

$(BLDDIR)/Main.S $(SRCDIR)/Main.smb: $(SRCDIR)/Main.Mod $(SRCDIR)/Test.smb
$(BLDDIR)/Test.S $(SRCDIR)/Test.smb: $(SRCDIR)/Test.Mod
$(BLDDIR)/Assignments.S $(SRCDIR)/Assignments.smb: $(SRCDIR)/Assignments.Mod $(SRCDIR)/Test.smb
$(BLDDIR)/SimpleMath.S $(SRCDIR)/SimpleMath.smb: $(SRCDIR)/SimpleMath.Mod $(SRCDIR)/Test.smb
$(BLDDIR)/SimpleReal.S $(SRCDIR)/SimpleReal.smb: $(SRCDIR)/SimpleReal.Mod $(SRCDIR)/Test.smb
$(BLDDIR)/DefFunc.S $(SRCDIR)/DefFunc.smb: $(SRCDIR)/DefFunc.Mod $(SRCDIR)/Test.smb
$(BLDDIR)/Byte.S $(SRCDIR)/Byte.smb: $(SRCDIR)/Byte.Mod $(SRCDIR)/Test.smb

$(BLDDIR)/%.o : $(BLDDIR)/%.S
	@$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

$(BLDDIR)/%.S $(SRCDIR)/%.smb : $(SRCDIR)/%.Mod
	$(OB) -o $(BLDDIR) -p $(LIBDIR) -s $<

$(TARGETELF): $(OBJS)
	$(CC) $^ $(LDFLAGS) -o $@

.PHONY: flash
flash: $(TARGETELF)
	esptool.py --chip=esp32 elf2image $(TARGETELF)
	esptool.py --chip=esp32 --port $(PORT) write_flash 0x1000 $(TARGETBIN) -ff 80m -fm dout

# Target to clean build artifacts.
.PHONY: clean
clean:
	rm -f $(BLDDIR)/*
	rm -f $(SRCDIR)/*.smb
