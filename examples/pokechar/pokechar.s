.include "b6502_hdr.inc"

.segment  "SRAM1"	; place our code in the SRAM1 segment (0xf000)

start:
	lda #$43	; load 'C' to accumulator
	sta $fff0	; store accumulator to magic address

.segment "VECTORS"	; place the required vectors

.word start		; NMI
.word start		; RST
.word start		; IRQ
