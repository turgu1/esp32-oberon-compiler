OC=obnc-compile
LINK=obnc

ODIR=.obnc

SIMS = \
	$(ODIR)/Texts.sym\
	$(ODIR)/Logger.sym\
	$(ODIR)/ORS.sym\
	$(ODIR)/ORB.sym\
	$(ODIR)/ORG.sym\
	$(ODIR)/ORP.sym

$(ODIR)/%.sym: %.Mod
	$(OC) $<

Oberon: $(SIMS) Oberon.Mod
	$(LINK) Oberon.Mod

ORTool: ORTool.Mod $(ODIR)/ORB.sym $(ODIR)/Texts.sym $(ODIR)/Logger.sym
	$(LINK) ORTool.Mod

$(ODIR)/Texts.sym: Texts.Mod

$(ODIR)/Logger.sym: Logger.Mod $(ODIR)/Texts.sym

$(ODIR)/ORS.sym: ORS.Mod $(ODIR)/Texts.sym $(ODIR)/Logger.sym

$(ODIR)/ORB.sym: ORB.Mod $(ODIR)/ORS.sym

$(ODIR)/ORG.sym: ORG.Mod $(ODIR)/ORS.sym $(ODIR)/ORB.sym

$(ODIR)/ORP.sym: ORP.Mod $(ODIR)/ORS.sym $(ODIR)/ORB.sym $(ODIR)/ORG.sym $(ODIR)/Texts.sym $(ODIR)/Logger.sym
