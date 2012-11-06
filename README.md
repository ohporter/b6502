Bone-6502 Remoteproc Tools
==========================

Overview
--------

A collection of tools to support the Bone-6502 RemoteProc system
6502 assembly code examples that will execute on the 6502 rproc.

The PRU code requires that the user install the am335x PRU SW
package from https://github.com/beagleboard/am335x_pru_package.

The 6502 examples require that the user install the cc65 toolchain
as documented at http://www.cc65.org

Only ca65/ld65 are required as there are currently no C examples.

PRUSS 65xx Bus Decoder
----------------------

b6502_pruss is a C and PRU assembly tool that launches PRU firmware
that will decode 65xx bus cycles providing access to AM335x-residen
SRAM as local memory  for the 6502 processor.

Examples
--------

* pokechar - simplest b6502rproc example. stores an ascii 'C' to sram
* bvuart - echo characters back to the virtual uart kernel driver

Build and Run
-------------

This assumes GNU make/gcc and the compiled AM335x PRU SW package are
installed on the BeagleBone rootfs.

	root@bone2:~# cp am335x_pru_package/pru_sw/utils/pasm /usr/local/bin/
	root@bone2:~# cp am335x_pru_package/pru_sw/app_loader/include/*.h /usr/local/include/
	root@bone2:~# cp am335x_pru_package/pru_sw/app_loader/lib/* /usr/local/lib/
	root@bone2:~# cd b6502/pruss/
	root@bone2:~/b6502/pruss# make
	gcc -I/usr/local/include -o b6502_pruss b6502_pruss.c -L/usr/local/lib -lprussdrv -lpthread
	pasm -b b6502_pruss.p
	PRU Assembler Version 0.80
	Copyright (C) 2005-2012 by Texas Instruments Inc.
	Pass 2 : 0 Error(s), 0 Warning(s)
	Writing Code Image of 107 word(s)

This assumes GNU make and ca65/ld65 are installed on the BeagleBone
rootfs and in the path. In addition, the b6502 pruss loader and kernel
with b6502remoteproc and uio_pruss support plus the necessary DTS data
must be present.

	root@bone2:~/b6502/examples/pokechar# make
	ca65 -l pokechar.lst pokechar.s
	ld65 -o pokechar.bin -C b6502.cfg pokechar.o
	root@bone2:~/b6502/examples/pokechar# cp pokechar.bin /lib/firmware/bone-6502-fw.bin

Now run it.

	root@bone2:~/b6502/examples/pokechar# b6502_pruss
	root@bone2:~/b6502/examples/pokechar# echo 1 > /sys/class/rproc/remoteproc0/on_off

Verify it executed as expected.

	root@bone2:~/b6502/examples/pokechar# devmem2 0x4a31fff0 w
	/dev/mem opened.
	Memory mapped at address 0xb6f92000.
	Read at address  0x4A311FF0 (0xb6f92ff0): 0x00000043
