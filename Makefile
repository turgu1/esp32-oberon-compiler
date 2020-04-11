OC=obnc-compile
LINK=obnc

OBNC_CONFIG_C_REAL_TYPE=OBNC_CONFIG_FLOAT
OBNC_CONFIG_C_INT_TYPE=OBNC_CONFIG_INT

ODIR=.obnc
SRC=src
OUT=$(SRC)/$(ODIR)

SIMS = \
	$(OUT)/Texts.sym \
	$(OUT)/ORS.sym \
	$(OUT)/ORB.sym \
	$(OUT)/ORG.sym \
	$(OUT)/ORP.sym \
    $(OUT)/SYS.sym

$(OUT)/%.sym: $(SRC)/%.Mod
	cd $(SRC); $(OC) $(<F)

OberonESP32: $(SIMS) $(SRC)/Oberon.Mod
	cd $(SRC); $(LINK) Oberon.Mod
	mv $(SRC)/Oberon ./OberonESP32

ORTool: $(SRC)/ORTool.Mod $(OUT)/ORB.sym $(OUT)/Texts.sym
	cd $(SRC); $(LINK) ORTool.Mod
	mv $(SRC)/ORTool .

$(OUT)/Texts.sym: $(SRC)/Texts.Mod

$(OUT)/ORS.sym: $(SRC)/ORS.Mod $(OUT)/Texts.sym

$(OUT)/ORB.sym: $(SRC)/ORB.Mod $(OUT)/ORS.sym

$(OUT)/ORG.sym: $(SRC)/ORG.Mod $(OUT)/ORS.sym $(OUT)/ORB.sym $(OUT)/SYS.sym

$(OUT)/ORP.sym: $(SRC)/ORP.Mod $(OUT)/ORS.sym $(OUT)/ORB.sym $(OUT)/ORG.sym $(OUT)/Texts.sym

$(OUT)/SYS.sym: $(SRC)/SYS.c
	cd $(SRC); cp SYS.sym SYS.h $(ODIR)
	cd $(SRC); gcc -c SYS.c -o $(ODIR)/SYS.o
	cd $(SRC); touch $(ODIR)/SYS.sym

.PHONY: clean
clean:
	rm -rf $(OUT)/*
