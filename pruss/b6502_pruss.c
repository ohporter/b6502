#include <stdio.h>

#include <prussdrv.h>
#include <pruss_intc_mapping.h>

#define PRU_NUM 0

int main (void)
{
    unsigned int ret;
    tpruss_intc_initdata pruss_intc_initdata = PRUSS_INTC_INITDATA;
    
    /* Initialize the PRU */
    prussdrv_init ();		
    
    /* Open PRU Interrupt */
    ret = prussdrv_open(PRU_EVTOUT_0);
    if (ret)
    {
        printf("prussdrv_open open failed\n");
        return (ret);
    }
    
    prussdrv_pruintc_init(&pruss_intc_initdata);

    printf("Enabled 65xx bus decoder on PRU %d\n", PRU_NUM);
    prussdrv_exec_program (PRU_NUM, "./b6502_pruss.bin");
    
    prussdrv_exit ();

    return(0);
}

