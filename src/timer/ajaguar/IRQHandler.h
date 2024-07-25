#ifndef _INTERRUPT_H
#define _INTERRUPT_H

#ifdef __cplusplus
extern "C" {
#endif

// Function
extern void init_interrupts(void);

// Variable
extern volatile Uint32 ajag_mstimer;

#ifdef __cplusplus
}
#endif

#endif
