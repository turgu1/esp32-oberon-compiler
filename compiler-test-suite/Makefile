OB = ../Oberon

SRCS = \
  ArrayAssignment.Mod

#	Pattern13.Mod \

ASS = $(SRCS:.Mod=.S)

%.S : %.Mod
	$(OB)  -s $(<F)

.PHONY: all
all: $(ASS)

clean:
	rm *.S