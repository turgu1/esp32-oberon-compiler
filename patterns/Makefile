OBERON = OberonESP32

OBERON_FLAGS = -c -l -s 

SRCS = \
	Pattern1.Mod \
	Pattern2.Mod \
	Pattern3.Mod \
	Pattern4.Mod \
	Pattern5.Mod \
	Pattern6.Mod \
	Pattern7.Mod \
	Pattern8.Mod \
	Pattern9.Mod \
	Pattern10.Mod \
	Pattern11.Mod \
	Pattern12a.Mod \
	Pattern12b.Mod \
	Pattern12c.Mod \
	Pattern13.Mod \
	Pattern14.Mod \
	Pattern15.Mod \
	Pattern16.Mod \
	Pattern17.Mod \
	Pattern18.Mod \
	Pattern19.Mod \
	Pattern20.Mod \
	Pattern21.Mod \
	Pattern22.Mod \
	Pattern23.Mod

#	Pattern13.Mod \

ASS = $(SRCS:.Mod=.S)

%.S : %.Mod
	$(OBERON) $(OBERON_FLAGS) $(<F)

.PHONY: all
all: $(ASS)

clean:
	rm *.S