.SECONDARY:  # Keep intermediary files

TOOLCHAIN = xtensa-esp32-elf-

ASFLAGS_PLATFORM  = -mlongcalls -mauto-litpools -mtext-section-literals -fstrict-volatile-bitfields

###
# General project build
###
OBERON = OberonESP32
OIORDER = OIOrderESP32
CC = $(TOOLCHAIN)gcc
AR = $(TOOLCHAIN)ar
RL = $(TOOLCHAIN)ranlib

BLDDIR = ./build
SRCDIR = ./src
LIBDIR = ./lib

ESP32LIB = esp32-oberon

ASFLAGS += -c -O0 -Wall -fmessage-length=0
ASFLAGS += $(ASFLAGS_PLATFORM)
ASFLAGS += -g

OBFLAGS = -o $(BLDDIR) -p $(OBERON_PATH)
# OBFLAGS = -o $(BLDDIR) -p $(OBERON_PATH) -l -c

$(BLDDIR)/%.o : $(BLDDIR)/%.S
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@
	$(AR) r $(ARCHIVE) $@ 

$(BLDDIR)/%.o $(BLDDIR)/%.smb : $(SRCDIR)/%.Mod
	$(OBERON) $(OBFLAGS) -s $<
	$(AR) r $(ARCHIVE) $@ 
