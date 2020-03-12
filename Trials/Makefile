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

# Linker script location.
LDSCRIPT = ./ld/esp32.ld
LDFLAGS += -nostdlib -T$(LDSCRIPT) -Wl,-Map=$@.map -Wl,--cref -Wl,--gc-sections
LDFLAGS += $(LDFLAGS_PLATFORM)

ASFLAGS += -c -O0 -Wall -fmessage-length=0
ASFLAGS += $(ASFLAGS_PLATFORM)
ASFLAGS += -g

PORT = /dev/tty.SLAB_USBtoUART
#PORT = /dev/ttyUSB0

BLDDIR = ./build/
SRCDIR = ./src/

TEST=init/test.S
TESTO= $(BLDDIR)/test.o

INIT = init/init.S
INITO = $(BLDDIR)/init.o

# The first module in the list is the main program
SRC =  \
	Main.Mod \
	Kernel.Mod \
	Math.Mod \
	Out.Mod

SYMS = $(addprefix $(SRCDIR), $(SRC:.Mod=.smb))
ASSS = $(addprefix $(BLDDIR), $(SRC:.Mod=.S))
OBJS = $(addprefix $(BLDDIR), $(SRC:.Mod=.o))

TARGETELF = $(BLDDIR)tests.elf
TARGETBIN = $(BLDDIR)tests.bin

.PHONY: all
all: $(TARGETELF)
#all: $(TESTO)

.PHONY: test
test:
	@echo "OBJS = $(OBJS)"
	@echo "ASSS = $(ASSS)"

# Rules to build files.

$(BLDDIR)Main.S   $(SRCDIR)Main.smb:   $(SRCDIR)Main.Mod  $(SRCDIR)Out.smb $(SRCDIR)Math.smb $(SRCDIR)Kernel.smb
$(BLDDIR)Out.S    $(SRCDIR)Out.smb:    $(SRCDIR)Out.Mod
$(BLDDIR)Math.S   $(SRCDIR)Math.smb:   $(SRCDIR)Math.Mod
$(BLDDIR)Kernel.S $(SRCDIR)Kernel.smb: $(SRCDIR)Kernel.Mod

$(BLDDIR)%.S $(SRCDIR)%.smb : $(SRCDIR)%.Mod
	cd $(SRCDIR) ; ../$(OB) -s $(<F)
	@mv $(SRCDIR)$(patsubst %.smb,%.S,$(@F)) $(BLDDIR)

$(OBJS): %.o: %.S
	@$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

$(TESTO): $(TEST)
	@$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

$(INITO): $(INIT)
	@$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

$(TARGETELF): $(INITO) $(OBJS)
	$(CC) $^ $(LDFLAGS) -o $@

.PHONY: flash
flash: $(TARGETELF)
	esptool.py --chip=esp32 elf2image $(TARGETELF)
	esptool.py --chip=esp32 --port $(PORT) write_flash 0x1000 $(TARGETBIN) -ff 80m -fm dout

# Target to clean build artifacts.
.PHONY: clean
clean:
	rm -f $(BLDDIR)*
	rm -f $(SRCDIR)*.smb
