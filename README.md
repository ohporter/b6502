Bone-6502 Remoteproc Examples
=============================

Overview
--------

A collection of 6502 code examples that will execute on the 
Bone-6502 Remoteproc system.

These examples require that the user install the cc65 toolchain
as documented at http://www.cc65.org

Only ca65/ld65 are required as there are currently no C examples.

Examples
--------

* pokechar - simplest b6502rproc example. stores an ascii 'C' to sram

Build and Run
-------------

This assumes GNU make and ca65/ld65 are installed and in the path. In
addition, the b6502 pruss executable and kernel with b6502remoteproc
and uio_pruss support plus the necessary DTS data must be present.

	root@bone2:~/b6502/pokechar# make
	ca65 -l pokechar.lst pokechar.s
	ld65 -o pokechar.bin -C b6502.cfg pokechar.o
	root@bone2:~/b6502/pokechar# cp pokechar.bin /lib/firmware/bone-6502-fw.bin

Now run it.

	root@bone2:~/b6502/pokechar# b6502_pruss
	root@bone2:~/b6502/pokechar# echo 1 > /sys/class/rproc/remoteproc0/on_off

Verify it executed as expected.

	root@bone2:~/b6502/pokechar# devmem2 0x4a31fff0 w
	/dev/mem opened.
	Memory mapped at address 0xb6f92000.
	Read at address  0x4A311FF0 (0xb6f92ff0): 0x00000043
