;----------------------------------------------------------------------------
; Jaguar Development System Source Code
; Copyright (c)1995 Atari Corp.
; ALL RIGHTS RESERVED
;
; Module: startup.s - Hardware initialization/License screen display
;
; Revision History:
;  1/12/95 - SDS: Modified from MOU.COF sources.
;  2/28/95 - SDS: Optimized some code from MOU.COF.
;  3/14/95 - SDS: Old code preserved old value from INT1 and OR'ed the
;                 video interrupt enable bit. Trouble is that could cause
;                 pending interrupts to persist. Now it just stuffs the value.
;  4/17/95 - MF:  Moved definitions relating to startup picture's size and
;                 filename to top of file, separate from everything else (so
;                 it's easier to swap in different pictures).
;----------------------------------------------------------------------------
; Program Description:
; Jaguar Startup Code
;
; Steps are as follows:
; 1. Set GPU/DSP to Big-Endian mode
; 2. Set VI to $FFFF to disable video-refresh.
; 4. Initialize video registers.
; 5. Create an object list as follows:
;            BRANCH Object (Branches to stop object if past display area)
;            BRANCH Object (Branches to stop object if prior to display area)
;            BITMAP Object (Jaguar License Acknowledgement - see below)
;            STOP Object
; 6. Install interrupt handler, configure VI, enable video interrupts,
;    lower 68k IPL to allow interrupts.
; 7. Use GPU routine to stuff OLP with pointer to object list.
; 8. Turn on video.
;
; Notes:
; All video variables are exposed for program use. 'ticks' is exposed to allow
; a flicker-free transition from license screen to next. gSetOLP and olp2set
; are exposed so they don't need to be included by exterior code again.
;-----------------------------------------------------------------------------

	.include	"JAGUAR.INC"

;*****************
;* ASM Conditional
;*****************
;
IRQ					=	1				; 0: No interrupt

;*********
;* Globals
;*********
;
;Functions
;
	.globl	ajag_setvideo
;
; variables
;
	.globl	ajag_mstimer
	.globl	ajag_screen
	.globl	_video_height
	.globl	_a_vdb
	.globl	_a_vde
	.globl	_video_width
	.globl	_a_hdb
	.globl	_a_hde
	.globl	_vblPerSec

;**********************
;* Constant definitions
;**********************
;
PPP     		.equ    8      				; Pixels per Phrase (1-bit)
BMP_WIDTH   	.equ    320     			; Width in Pixels
BMP_HEIGHT  	.equ    240     			; Height in Pixels
;
;Objects list information
;
LISTSIZE    	.equ    5					; Objects List length (in Phrases) must include the Stop
											; 0: 1st Branch
											; 1: 2nd Branch
											; 2: Standart Bitmap
											; 3:
											; 4: Stop
BMP_PHRASES 	.equ    (BMP_WIDTH/PPP)		; Width in Phrases
BMP_LINES   	.equ    (BMP_HEIGHT*2)  	; Height in Half Scanlines
BITMAP_OFF  	.equ    (2*8)       		; Two Phrases


;*********************
;* Setup video
;*********************
;
	.text
;
ajag_setvideo:
;
; Jaguar registers initialisations
;
	move.l  #$70007,G_END								; Set Data Organisation Register (F0210C) in BigEndian 
	move.l  #$70007,D_END								; Set DSP Data Organisation Register (F1A10C) in BigEndian
	move.w  #$FFFF,VI									; Set the Vertical Interrupt (F0004E) very high to disable video interrupts
;
; Video initialisations
;
	jsr		InitVideo									; Setup video registers
	jsr		InitLister     								; Initialize Object Display List
.if IRQ = 1
	jsr		InitIRQ      								; Initialize the VBLANK routine
.endif
;
; Sneaky trick to cause display to popup at first VB
; d0.l comes from InitLister function
;
	move.l	#$0,listbuf+BITMAP_OFF						; ?
	move.l	#$C,listbuf+BITMAP_OFF+4					; ?
;
	move.l	d0,OLP
;
	move.w  #(VIDEN|RGB16|CSYNC|BGEN|PWIDTH4),VMODE     ; Configure video (F00028) to $6C7
;
; start the timer by writing a non-zero value to register PIT:
; (Don't do this in IntInit, because it will start immediately
; the timer, and perhaps not everything is setup at that time!)
; 1 second      = 26593900 = $195CA6C  (the frequenzy of the  system)
; 1/1200 second =    22162 = $0005692
;
	move.l  #(((26593900 / 1000) << 16) | ((26593900 / 1000) >> 16)), PIT0
;
	rts


;**********************************************************
;* Install our vertical blank handler and enable interrupts
;*
;* Inputs: None
;*
;* Ouputs: None
;**********************************************************
;
	.text
;
.if IRQ = 1
InitIRQ:
	move.l  d0, -(sp)
;
;setup CPU and vertical interruptions
;
	move.l  #UpdateList, LEVEL0				; Install the 68000 Level 0 Autovector Interrupt ($100)
	move.w  _a_vde, d0        				; Get vertical display end
	ori.w   #1, d0							; Must be ODD
	move.w  d0, VI							; Set the Vertical Interrupt ($F0004E) based on the end of the vertical display
	move.w  #(C_VIDENA | C_PITENA), INT1    ; Set the CPU Interrupt Control Register ($F000E0) to enable Video time-base interrupts & CPU
	move.w  sr, d0
	and.w   #$F8FF, d0       				; Lower 68000 IPL to allow
	move.w  d0, sr           				; Interrupts
;
;end of function
;
	move.l  (sp)+, d0
	rts
.endif


;***********************
;* Video initialisations
;*
;* Inputs: None
;*
;* Outputs: None
;*
;* Registers: TBD
;***********************
;
	.text
;	
InitVideo:
;
	movem.l	d0-d6,-(sp)			; Save registers
;
; PAL/NTSC detection
;
	move.w	CONFIG,d0			; Read the Button register (F14002) also a joystick register
	andi.w	#VIDTYPE,d0			; 0=PAL,1=NTSC
	beq.s	.palvals
;
; Get values for NTSC (60Hz) [525 lines]
;
	move.w	#60,_vblPerSec
	move.w	#NTSC_HMID,d2
	move.w	#NTSC_WIDTH,d0
	move.w	#NTSC_VMID,d6
	move.w	#NTSC_HEIGHT,d4
	bra.s	.calc_vals
;
; Get values for PAL (50Hz) [625 lines]
;
.palvals:
	move.w	#50,_vblPerSec
	move.w	#PAL_HMID,d2
	move.w	#PAL_WIDTH,d0
	move.w	#PAL_VMID,d6
	move.w	#PAL_HEIGHT,d4
;
; Setup values depend PAL/NTSC
;
.calc_vals:
	move.w	d0,_video_width
	move.w	d4,_video_height
;
; Horizontal Display calculus
;
	move.w	d0,d1
	asr		#1,d1				; (Width/2) ~ NTSC = 1409/2 = 704 ~ PAL = 1381/2 = 690
	sub.w	d1,d2				; (HMid-(Width/2)) ~ NTSC = 823-704 = 119 ~ PAL = 843-690 = 153
	add.w	#4,d2				; (HMid-(Width/2))+4 ~ NTSC = 119+4 = 123 ~ PAL = 153+4 = 157
	sub.w	#1,d1				; (Width/2)-1 ~ NTSC = 704-1 = 703 ~ PAL = 690-1 = 689
	ori.w	#$400,d1			; (((Width/2)-1) | $400 or 1024) ~ NTSC = 703|$400 = 1727 ~ PAL = 689|$400 = 1713
	move.w	d1,_a_hde			
	move.w	d1,HDE				; Set the Horizontal Display End (F0003C) to 1727 (NTSC) or 1713 (PAL)
	move.w	d2,_a_hdb
	move.w	d2,HDB1				; Set the Horizontal Display Begin 1 (F00038) to 123 (NTSC) or 157 (PAL)
	move.w	d2,HDB2				; Set the Horizontal Display Begin 2 (F0003A) to 123 (NTSC) or 157 (PAL)
;
; Vertical Display calculus
;
	move.w	d6,d5
	sub.w	d4,d5				; (VMID-HEIGHT) ~ NTSC = 266-241 = 15 ~ PAL = 322-287 = 35
	move.w	d5,_a_vdb
	add.w	d4,d6				; (VMID+HEIGHT) ~ NTSC = 266+241 = 507 ~ PAL = 322+287 = 609
	move.w	d6,_a_vde
	move.w	d5,VDB				; Set the Vertical Display Begin (F00046) to 15 (NTSC) or 35 (PAL)
	move.w  #$FFFF,VDE			; Force the Vertical Display End (F00048)
;
; Set "basic" colors
;
	move.l	#0,BORD1			; Set the Border Colour (Red & Green - Blue) [F0002A] to 0
	move.l	#0,BG				; Set the Background Colour (F00058) to 0
;
; End of function
;
	movem.l	(sp)+,d0-d6			; Load saved registers
	rts


;******************************************************************
;* Initialize Object List Processor List
;*
;* Registers: d0.l/d1.l - Phrase being built
;*            d2.l/d3.l - Link address overlays
;*            d4.l      - Work register
;*            a0.l      - Roving object list pointer
;*
;* Outputs: Pre-word-swapped address of current object list in d0.l
;******************************************************************
;
	.text
;	
InitLister:
;
	movem.l d1-d4/a0,-(sp)									; Save registers
;
; Get Object List pointers
;			
	lea     listbuf,a0										; Get the Object List start address
	move.l  a0,d2
	add.l   #(LISTSIZE-1)*8,d2  							; Calcul the Object List STOP address
	move.l	d2,d3											; Copy for low half
	lsr.l	#8,d2											; Shift high half into place
	lsr.l	#3,d2
	swap	d3												; Place low half correctly
	clr.w	d3
	lsl.l	#5,d3
;
; Write first BRANCH object (branch if YPOS > a_vde )
;
	clr.l   d0
	move.l  #(BRANCHOBJ|O_BRLT),d1							; $4000 = VC < YPOS
	or.l	d2,d0											; Do LINK overlay
	or.l	d3,d1
	move.w  _a_vde,d4										; for YPOS
	lsl.w   #3,d4											; Make it bits 13-3
	or.w    d4,d1
	move.l	d0,(a0)+
	move.l	d1,(a0)+
;
; Write second branch object (branch if YPOS < a_vdb)
; Note: LINK address is the same so preserve it
;
	andi.l  #$FF000007,d1									; Mask off CC and YPOS
	ori.l   #O_BRGT,d1										; $8000 = VC > YPOS
	move.w  _a_vdb,d4										; for YPOS
	lsl.w   #3,d4											; Make it bits 13-3
	or.w    d4,d1
	move.l	d0,(a0)+
	move.l	d1,(a0)+
;
; Write a standard BITMAP object
;
	move.l	d2,d0
	move.l	d3,d1
	ori.l	#BMP_HEIGHT<<14,d1								; Height of image
	move.w  _video_height,d4								; Center bitmap vertically
	sub.w   #BMP_HEIGHT,d4
	add.w   _a_vdb,d4
	andi.w  #$FFFE,d4										; Must be even
	lsl.w   #3,d4
	or.w    d4,d1											; Stuff YPOS in low phrase
	move.l	#ajag_screen,d4
	lsl.l	#8,d4
	or.l	d4,d0
	move.l	d0,(a0)+
	move.l	d1,(a0)+
	movem.l	d0-d1,bmpupdate
;
; Second Phrase of Bitmap
;
	move.l	#BMP_PHRASES>>4,d0								; Only part of top LONG is IWIDTH
.if PPP = 4
	move.l  #O_DEPTH16|O_NOGAP,d1							; Bit Depth = 16-bit, Contiguous data
.else
	move.l  #O_DEPTH8|O_NOGAP,d1							; Bit Depth = 8-bit, Contiguous data
.endif
	move.w  _video_width,d4									; Get width in clocks
	lsr.w   #2,d4											; /4 Pixel Divisor
	sub.w   #BMP_WIDTH,d4
	lsr.w   #1,d4
	or.w    d4,d1
	ori.l	#(BMP_PHRASES<<18)|(BMP_PHRASES<<28),d1			; DWIDTH|IWIDTH
	move.l	d0,(a0)+
	move.l	d1,(a0)+
;
; Write a STOP object at end of the list
;
	clr.l   (a0)+
	move.l  #(STOPOBJ|O_STOPINTS),(a0)+
;
; Return swapped Objects list pointer in D0
;
	move.l  #listbuf,d0
	swap    d0
;
; End of function
;
	movem.l (sp)+,d1-d4/a0									;load saved registers
	rts


;****************************************************************************************
;* Handle Video Interrupt and update object list fields destroyed by the object processor
;*
;* Inputs: None
;*
;* Ouputs: None
;****************************************************************************************
;
	.text
;	
.if IRQ = 1
UpdateList:
;
	movem.l  d0-d1/a0, -(sp)
;
    move.w  INT1, d0						; CPU Interrupt Control Register (F000E0)
    move.w  d0, d1
    lsl.w   #8, d1
    or.w    #(C_VIDENA | C_PITENA), d1		; VBL (video) + PIT (Timer)
    move.w  d1, INT1						; mark interrupts as serviced, and re-enable them
    btst    #3,d0							; bit3 = Timer-IRQ?
    beq.s   no_timer
	add.l	#1, ajag_mstimer				; increment the number of ms
;
;restore the BITMAP pointer in his dedicated Objects List
;
no_timer:
	btst    #0,d0							; bit0 = a VBL?
    beq.s   no_blank
	move.l  #(listbuf + BITMAP_OFF), a0
	move.l  bmpupdate, (a0)      			; Phrase = d1.l/d0.l
	move.l  bmpupdate+4, 4(a0)
	add.l	#1, ticks						; Increment the vertical blank counter - number of interuptions encountered
;
;end of function
;
no_blank:
	move.w  #$0, INT2						; Set the CPU Interrupt resume register (F000E2) - Bus priorities are restored
	movem.l  (sp)+, d0-d1/a0
	rte
.endif


	.bss
	.dphrase
ajag_screen:	.ds.b	BMP_WIDTH*BMP_HEIGHT
	.dphrase
listbuf:		.ds.l	LISTSIZE*2  		; Objects List
	.even
bmpupdate:		.ds.l	2       			; One Phrase of Bitmap for Refresh
ticks:			.ds.l	1					; Incrementing # of ticks	
_a_hdb:			.ds.w	1
_a_hde:			.ds.w	1					; Horizontal display end
_a_vdb:			.ds.w	1
_a_vde:			.ds.w	1					; Vertical display end
_video_width:	.ds.w	1
_video_height:	.ds.w	1
_vblPerSec:		.ds.w	1
ajag_mstimer:	.ds.l	1
