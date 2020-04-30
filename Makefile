
#PREFIX is environment variable, but if it is not set, then set default value
ifeq ($(PREFIX),)
    PREFIX := /usr/local
endif

INSTALL_DIR=$(PREFIX)/bin

OC=obnc-compile
LINK=obnc

OBNC_CONFIG_C_REAL_TYPE=OBNC_CONFIG_FLOAT
OBNC_CONFIG_C_INT_TYPE=OBNC_CONFIG_INT

ODIR=.obnc
SRC=src
OUT=$(SRC)/$(ODIR)

SIMS = \
  $(OUT)/Config.sym \
	$(OUT)/Texts.sym \
	$(OUT)/ORS.sym \
	$(OUT)/ORB.sym \
	$(OUT)/ORG.sym \
	$(OUT)/ORP.sym \
	$(OUT)/SYS.sym

$(OUT)/%.sym: $(SRC)/%.Mod
	cd $(SRC); $(OC) $(<F)

.PHONY: all
all: OberonESP32 ORToolESP32 OIOrderESP32

OberonESP32: $(SIMS) $(SRC)/Oberon.Mod
	cd $(SRC); $(LINK) Oberon.Mod
	mv $(SRC)/Oberon ./OberonESP32

ORToolESP32: $(SRC)/ORTool.Mod $(OUT)/ORB.sym $(OUT)/Texts.sym $(OUT)/Config.sym
	cd $(SRC); $(LINK) ORTool.Mod
	mv $(SRC)/ORTool ./ORToolESP32

OIOrderESP32: $(SRC)/ORTool.Mod $(OUT)/Texts.sym $(OUT)/Config.sym
	cd $(SRC); $(LINK) OIOrder.Mod
	mv $(SRC)/OIOrder ./OIOrderESP32

$(OUT)/Texts.sym: $(SRC)/Texts.Mod

$(OUT)/ORS.sym: $(SRC)/ORS.Mod $(OUT)/Texts.sym $(OUT)/SYS.sym

$(OUT)/ORB.sym: $(SRC)/ORB.Mod $(OUT)/ORS.sym

$(OUT)/ORG.sym: $(SRC)/ORG.Mod $(OUT)/ORS.sym $(OUT)/ORB.sym $(OUT)/SYS.sym

$(OUT)/ORP.sym: $(SRC)/ORP.Mod $(OUT)/ORS.sym $(OUT)/ORB.sym $(OUT)/ORG.sym $(OUT)/Texts.sym

$(OUT)/Config.sym: $(SRC)/Config.Mod

$(OUT)/SYS.sym: $(SRC)/SYS.c
	cd $(SRC); cp SYS.sym SYS.h $(ODIR)
	cd $(SRC); gcc -c SYS.c -o $(ODIR)/SYS.o
	cd $(SRC); touch $(ODIR)/SYS.sym

.PHONY: clean
clean:
	rm -rf $(OUT)/*

.PHONY: install
install: OberonESP32 OIOrderESP32 ORToolESP32
	sudo install -m 755 ./OberonESP32  $(INSTALL_DIR)
	sudo install -m 755 ./OIOrderESP32 $(INSTALL_DIR)
	sudo install -m 755 ./ORToolESP32  $(INSTALL_DIR)
