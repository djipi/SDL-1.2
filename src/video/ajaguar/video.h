#ifndef _INTERRUPT_H
#define _INTERRUPT_H

#ifdef __cplusplus
extern "C" {
#endif

// Functions
extern void init_video(void);
extern void setvideo_320x240x8(void);

// Datas
extern volatile Uint32 ajag_VBL;
extern char* ajag_screen;

#ifdef __cplusplus
}
#endif

#endif
