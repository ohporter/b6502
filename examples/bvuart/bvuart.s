.include "b6502_hdr.inc"

.segment  "SRAM1"	; place our code in the SRAM1 segment (0xf000)

BVUART		= $fff0
BVUART_RX	= BVUART
BVUART_RXSTS	= BVUART + 1
BVUART_TX	= BVUART + 2
BVUART_TXSTS	= BVUART + 3
BVUART_STS_RDY = $40
BVUART_STS_VLD = $20

start:
	lda #BVUART_STS_RDY
	sta BVUART_RXSTS	; we're ready for a character
	lda #BVUART_STS_VLD
rxtst:	cmp BVUART_RXSTS ; character available?
	bne rxtst
	ldx BVUART_RX	; load it in X

	lda #BVUART_STS_RDY
txtst:	cmp BVUART_TXSTS ; ready for tx?
	bne txtst
	txa		; fetch character to echo
	sta BVUART_TX	; store accumulator to vuart tx register
	lda #BVUART_STS_VLD	
	sta BVUART_TXSTS ; tx content is valid

	jmp start	; do it again

.segment "VECTORS"	; place the required vectors

.word start		; NMI
.word start		; RST
.word start		; IRQ
