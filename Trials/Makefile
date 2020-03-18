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

PORT = /dev/tty.SLAB_USBtoUART
#PORT = /dev/ttyUSB0

INIT = init/init.S
INITO = $(BLDDIR)/init.o

# The first module in the list is the main program
SRC = \
	Main.Mod

SYMS = $(addprefix $(SRCDIR)/, $(SRC:.Mod=.smb))
ASSS = $(addprefix $(BLDDIR)/, $(SRC:.Mod=.S))
OBJS = $(addprefix $(BLDDIR)/, $(SRC:.Mod=.o))

TARGETELF = $(BLDDIR)/tests.elf
TARGETBIN = $(BLDDIR)/tests.bin

.PHONY: all
all: $(TARGETELF)

# Rules to build files.

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
