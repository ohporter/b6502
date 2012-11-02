;
; B6502 compliant remoteproc header
;
; Header is prepended to the 8KiB SRAM image contents
;

.segment "B6502HDR"

.word $beef	; magic
.word $dead
.word $0028	; image offset
.word $0000
.word $2000	; image size
.word $0000
.word $0014	; resource table offset
.word $0000
.word $0014	; resource table size
.word $0000
.word $0001	; resource table - version
.word $0000
.word $0000	; resource table - num entries
.word $0000
.word $0000	; resource table - reserved 0
.word $0000
.word $0000	; resource table - reserved 1
.word $0000
.word $0000	; resource table - offset 0
.word $0000
