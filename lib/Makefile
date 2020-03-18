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
AR = $(TOOLCHAIN)ar
RL = $(TOOLCHAIN)ranlib

# Linker script location.
LDSCRIPT = ./ld/esp32.ld
LDFLAGS += -nostdlib -T$(LDSCRIPT) -Wl,-Map=$@.map -Wl,--cref -Wl,--gc-sections
LDFLAGS += $(LDFLAGS_PLATFORM)

ASFLAGS += -c -O0 -Wall -fmessage-length=0
ASFLAGS += $(ASFLAGS_PLATFORM)
ASFLAGS += -g

SRCDIR = src
BLDDIR = build

INIT = init/init.S
INITO = $(BLDDIR)/init.o

SRC = \
  Out.Mod \
  Kernel.Mod \
  Math.Mod \
  Strings.Mod

ARCHIVE = libesp32-oberon.a

#	Pattern13.Mod

OBJS  = $(addprefix $(BLDDIR)/, $(SRC:.Mod=.o))

$(ARCHIVE) : $(OBJS) $(INITO)
	$(RL) $(ARCHIVE)

$(INITO): $(INIT)
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@
	@$(AR) r $(ARCHIVE) $@ 

$(BLDDIR)/%.S %.smb : $(SRCDIR)/%.Mod
	$(OB) -o $(BLDDIR) -p ../lib -s $<
	@mv $(SRCDIR)/$(patsubst %.Mod,%.smb,$(<F)) .

$(BLDDIR)/%.o : $(BLDDIR)/%.S
	@$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@
	@$(AR) r $(ARCHIVE) $@ 

clean:
	rm build/*
	rm src/*.smb
