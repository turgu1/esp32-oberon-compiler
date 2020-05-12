# 'Bare metal' ESP32 application Makefile
# Use the xtensa-esp32-elf toolchain.

.SECONDARY:  # Keep intermediary files

#PREFIX is environment variable, but if it is not set, then set default value
ifeq ($(PREFIX),)
    PREFIX := /usr/local
endif

LIB_INSTALL_DIR = $(PREFIX)/lib/OberonESP32

TOOLCHAIN = xtensa-esp32-elf-

ASFLAGS_PLATFORM  = -mlongcalls -mauto-litpools -mtext-section-literals -fstrict-volatile-bitfields
LDFLAGS_PLATFORM = $(AFLAGS_PLATFORM)

###
# General project build
###
OBERON = OberonESP32
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
LIBDIR = ../lib

OBERON_FLAGS = -o $(BLDDIR) -p $(BLDDIR) -s -c -x

INIT = init/init.S
INITO = $(BLDDIR)/init.o

MATH = $(SRCDIR)/math_support.S
MATHO = $(BLDDIR)/math_support.o

SRC = \
  Out.Mod \
  Kernel.Mod \
  In.Mod \
  Math.Mod \
  Strings.Mod \
  ESP_Support.Mod \
  ESP_Error.Mod \
  ESP_System.Mod \
  ESP_Timer.Mod

ARCHIVE = liboberonesp32.a

#	Pattern13.Mod

OBJS  = $(addprefix $(BLDDIR)/, $(SRC:.Mod=.o))
SMBS  = $(addprefix $(BLDDIR)/, $(SRC:.Mod=.smb))

all: $(BLDDIR) $(ARCHIVE)

$(BLDDIR):
	mkdir -p $(BLDDIR)

# $(ARCHIVE) : $(OBJS) $(INITO) $(MATHO)

$(ARCHIVE) : $(OBJS) $(MATHO)
	$(RL) $(ARCHIVE)

$(INITO): $(INIT)
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@
	@$(AR) r $(ARCHIVE) $@ 

$(MATHO): $(MATH)
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@
	@$(AR) r $(ARCHIVE) $@ 

$(BLDDIR)/%.o ./%.smb : $(SRCDIR)/%.Mod
	$(OBERON) $(OBERON_FLAGS) $<
	@$(AR) r $(ARCHIVE) $@ 

install: all
	sudo install -d $(LIB_INSTALL_DIR)
	sudo install -m 644 $(ARCHIVE) $(LIB_INSTALL_DIR)
	$(foreach file, $(SMBS), sudo install -m 644 $(file) $(LIB_INSTALL_DIR) ; )

clean:
	-rm build/*
	-rm $(ARCHIVE)
