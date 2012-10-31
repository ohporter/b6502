# B6502 firmware Makefile

SHELL = /bin/sh

.SUFFIXES:
.SUFFIXES: .s .o .bin .lst

AS = ca65
LD = ld65
LDSCRIPT = b6502.cfg
FW = pokechar.bin

all: $(FW)

$(FW): $(basename $(FW)).o
	$(LD) -o $@ -C $(LDSCRIPT) $<

%.o: %.s
	$(AS) -l $(basename $<).lst $<

clean:
	rm -f *.bin *.lst *.o
