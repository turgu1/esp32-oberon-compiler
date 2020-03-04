# 'Bare metal' ESP32 application Makefile
# Use the xtensa-esp32-elf toolchain.
TOOLCHAIN = xtensa-esp32-elf-

ASFLAGS_PLATFORM  = -mlongcalls -mauto-litpools -mtext-section-literals -fstrict-volatile-bitfields
LDFLAGS_PLATFORM = $(AFLAGS_PLATFORM)

###
# General project build
###
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

#PORT = /dev/tty.SLAB_USBtoUART
PORT = /dev/ttyUSB0

BLDDIR = ./build/
SRCDIR = ./src/

SRC =  \
	init.S \
	Test1.S \
	Test2.S

OBJS = $(addprefix $(BLDDIR), $(SRC:.S=.o))

TARGETELF = $(BLDDIR)main.elf
TARGETBIN = $(BLDDIR)main.bin

# Set the first rule in the file to 'make all'
.PHONY: all
all: $(TARGETELF)

.PHONY: test
test:
	echo $(OBJS)

# Rules to build files.
$(BLDDIR)%.o: $(SRCDIR)%.S
	$(CC) -x assembler-with-cpp $(ASFLAGS) $< -o $@

$(TARGETELF): $(OBJS)
	$(CC) $^ $(LDFLAGS) -o $@

.PHONY: flash
flash: $(TARGETELF)
	esptool.py --chip=esp32 elf2image $(TARGETELF)
	esptool.py --chip=esp32 --port $(PORT) write_flash 0x1000 $(TARGETBIN) -ff 80m -fm dout

# Target to clean build artifacts.
.PHONY: clean
clean:
	rm -f $(OBJS)
	rm -f ./main.bin
	rm -f ./main.elf ./main.elf.map
