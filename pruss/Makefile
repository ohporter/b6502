CC=gcc
CFLAGS=-I/usr/local/include
LDFLAGS=-L/usr/local/lib -lprussdrv -lpthread
PASM=pasm

FW=b6502_pruss.bin
LDR=b6502_pruss

all: $(LDR) $(FW)

$(LDR): $(basename $(LDR)).c
	$(CC) $(CFLAGS) -o $@ $^ $(LDFLAGS)

$(FW): $(basename $(FW)).p
	$(PASM) -b $^

.PHONY: clean

clean:
	rm -f *~ *.o $(FW) $(LDR)
