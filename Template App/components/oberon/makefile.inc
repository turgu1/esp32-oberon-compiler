.SECONDARY:  # Keep intermediary files

#PREFIX is environment variable, but if it is not set, then set default value
ifeq ($(PREFIX),)
    PREFIX := /usr/local
endif

OBERON_LIB_DIR = $(PREFIX)/lib/OberonESP32

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

ASFLAGS += -x assembler-with-cpp -c -O0 -Wall -fmessage-length=0
ASFLAGS += $(ASFLAGS_PLATFORM)
ASFLAGS += -g

OBERON_FLAGS = -o $(BLDDIR) -p $(OBERON_PATH):$(OBERON_LIB_DIR)
# OBERON_FLAGS = -o $(BLDDIR) -p $(OBERON_LIB_DIR) -l -c

$(BLDDIR)/%.o : $(BLDDIR)/%.S
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@
	$(AR) r $(ARCHIVE) $@ 

$(BLDDIR)/%.o $(BLDDIR)/%.smb : $(SRCDIR)/%.Mod
	$(OBERON) $(OBERON_FLAGS) -s $<
	$(AR) r $(ARCHIVE) $@ 
