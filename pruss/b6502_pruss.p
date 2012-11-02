.origin 0
.entrypoint start

#define CONST_PRUCFG C4
#define PRU0_ARM_INTERRUPT 19
#define shared_mem_ram r24
#define shared_mem_io r25
#define pru1_r30 r27
#define pru1_r31 r28
#define ALO_EN 0b1110
#define AHI_EN 0b1101
#define DATAOUT_EN 0b1011
#define DATAIN_EN 0b0111
#define RW_BIT 14
#define PHI2_BIT 15

.macro NOP
        mov r16, r16
.endm

.macro EN_DELAY
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
        NOP
.endm
.macro DELAY
.mparam count
    mov r0, 0
    mov r1, count
loop:
    add r0, r0, 1
    qbne loop, r0, r1
.endm
.macro MEM_MACRO
.mparam membase
        and r1.b1, r1.b1, 0x1f
        qbbs read, r31, RW_BIT // RW
write:
        EN_DELAY
        lbbo r1.b0, pru1_r31, 0, 1 // ALO
        ldi r30, DATAIN_EN
        EN_DELAY
        lbbo r3, pru1_r31, 0, 4 // DATAIN
        sbbo r3, membase, r1.w0, 1
        jmp mem
read:
        EN_DELAY
        lbbo r1.b0, pru1_r31, 0, 1 // ALO
        ldi r30, DATAOUT_EN
        lbbo r3.b1, membase, r1.w0, 1
        sbbo r3, pru1_r30, 0, 2 // DATAOUT
        mov r30.b1, r3.b1 // DATAOUT
        jmp mem
.endm

start:
        // Clear syscfg[standby_init] to enable ocp master port
        lbco r0, CONST_PRUCFG, 4, 4
        clr r0, r0, 4
        sbco r0, CONST_PRUCFG, 4, 4
        // Address of PRU1 R30 debug register
        mov pru1_r30, 0x24478
        // Address of PRU1 R31 debug register
        mov pru1_r31, 0x2447c

        // Disable everything
        mov r30, 0xffffffff
        sbbo r30, pru1_r30, 0, 4

        // Initialized shared memory registers
        mov shared_mem_ram, 0x10000
        mov shared_mem_io, 0x10000+0x2000

mem:
        //qbbc quit, r31, RESET_BIT // FIXME exit signal is nice
        wbc r31, PHI2_BIT // PHI2 falling edge
        ldi r30, AHI_EN
        wbs r31, PHI2_BIT // PHI2 rising edge
        lbbo r1.b1, pru1_r31, 0, 1 // AHI
        ldi r30, ALO_EN

        // Address decoding
        // we have 8KiB RAM aliased throughout address space
        // except 0xc000-0xcfff where a 4KiB virtio buffer area is placed
        //and r2.b1, r1.b1, 0xe0
        //qbeq memio, r2.b1, 0xc0

memram:
        MEM_MACRO shared_mem_ram
memio:
        MEM_MACRO shared_mem_io

quit:
        // Send notification to Host for program completion
        mov r31.b0, PRU0_ARM_INTERRUPT+16

        halt
