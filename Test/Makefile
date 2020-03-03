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

PORT = /dev/tty.SLAB_USBtoUART

BLDDIR = ./build/
SRCDIR = ./src/

INIT = init/init.S
INITO = $(BLDDIR)/init.o

# The first module in the list is the main program
SRC =  \
    Main.Mod \
    Test.Mod \
	Test2.Mod \
	Test3.Mod \
	Out.Mod

SYMS = $(addprefix $(SRCDIR), $(SRC:.Mod=.smb))
ASSS = $(addprefix $(BLDDIR), $(SRC:.Mod=.S))
OBJS = $(addprefix $(BLDDIR), $(SRC:.Mod=.o))

TARGETELF = $(BLDDIR)main.elf
TARGETBIN = $(BLDDIR)main.bin


.PHONY: all
all: $(TARGETELF)

.PHONY: test
test:
	@echo "OBJS = $(OBJS)"
	@echo "ASSS = $(ASSS)"

# Rules to build files.

$(BLDDIR)Main.S $(SRCDIR)Main.smb: $(SRCDIR)Main.Mod $(SRCDIR)Test.smb $(SRCDIR)Out.smb
$(BLDDIR)Test.S $(SRCDIR)Test.smb: $(SRCDIR)Test.Mod $(SRCDIR)Out.smb
$(BLDDIR)Test2.S $(SRCDIR)Test2.smb: $(SRCDIR)Test2.Mod 
$(BLDDIR)Test3.S $(SRCDIR)Test3.smb: $(SRCDIR)Test3.Mod
$(BLDDIR)Out.S $(SRCDIR)Out.smb: $(SRCDIR)Out.Mod

$(BLDDIR)%.S $(SRCDIR)%.smb : $(SRCDIR)%.Mod
	cd $(SRCDIR) ; ../$(OB) -s $(<F)
	mv $(SRCDIR)$(patsubst %.smb,%.S,$(@F)) $(BLDDIR)

$(OBJS): %.o: %.S
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

$(INITO): $(INIT)
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

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
