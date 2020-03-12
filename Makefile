OC=obnc-compile
LINK=obnc

OBNC_CONFIG_C_REAL_TYPE=OBNC_CONFIG_FLOAT
OBNC_CONFIG_C_INT_TYPE=OBNC_CONFIG_INT

ODIR=.obnc
SRC=src
OUT=$(SRC)/$(ODIR)

SIMS = \
	$(OUT)/Texts.sym \
	$(OUT)/Logger.sym \
	$(OUT)/ORS.sym \
	$(OUT)/ORB.sym \
	$(OUT)/ORG.sym \
	$(OUT)/ORP.sym \
    $(OUT)/Reals.sym

$(OUT)/%.sym: $(SRC)/%.Mod
	cd $(SRC); $(OC) $(<F)

Oberon: $(SIMS) $(SRC)/Oberon.Mod
	cd $(SRC); $(LINK) Oberon.Mod
	mv $(SRC)/Oberon .

ORTool: $(SRC)/ORTool.Mod $(OUT)/ORB.sym $(OUT)/Texts.sym $(OUT)/Logger.sym
	cd $(SRC); $(LINK) ORTool.Mod
	mv $(SRC)/ORTool .

$(OUT)/Texts.sym: $(SRC)/Texts.Mod

$(OUT)/Logger.sym: $(SRC)/Logger.Mod $(OUT)/Texts.sym

$(OUT)/ORS.sym: $(SRC)/ORS.Mod $(OUT)/Texts.sym $(OUT)/Logger.sym

$(OUT)/ORB.sym: $(SRC)/ORB.Mod $(OUT)/ORS.sym

$(OUT)/ORG.sym: $(SRC)/ORG.Mod $(OUT)/ORS.sym $(OUT)/ORB.sym $(OUT)/Reals.sym

$(OUT)/ORP.sym: $(SRC)/ORP.Mod $(OUT)/ORS.sym $(OUT)/ORB.sym $(OUT)/ORG.sym $(OUT)/Texts.sym $(OUT)/Logger.sym

$(OUT)/Reals.sym: $(SRC)/Reals.c
	cd $(SRC); cp Reals.sym Reals.h $(ODIR)
	cd $(SRC); gcc -c Reals.c -o $(ODIR)/Reals.o
	cd $(SRC); touch $(ODIR)/Reals.sym

.PHONY: clean
clean:
	rm -rf $(OUT)/*
