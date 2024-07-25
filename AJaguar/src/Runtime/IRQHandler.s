
	.include	"JAGUAR.INC"
	.include	"video.inc"


	; functions
	.globl	init_interrupts
	.globl	init_video
	; variables
	.globl	ajag_mstimer
	.globl	ajag_VBL
	.globl	bmpupdate
	.globl	_video_width
	.globl	_video_height
	.globl	_a_vdb
	.globl	_a_vde
	; array
	.globl	listbuf


	.text

init_interrupts:
	; install the 68000 Level 0 Autovector Interrupt ($100)
	move.l  #UpdateIRQs, LEVEL0				
	; set the CPU Interrupt Control Register ($F000E0) to enable CPU
	move.w  #(C_PITENA), INT1
	; lower 68000 IPL to allow interrupts
	move.w  sr, d0
	and.w   #$F8FF, d0       				
	move.w  d0, sr
	; init milliseconds
	move.l	#0, ajag_mstimer           				
	; start the timer by writing a non-zero value to register PIT:
	; (Don't do this in IntInit, because it will start immediately the timer, and perhaps not everything is setup at that time!)
	; 1 second = 26593900 = $195CA6C  (the frequenzy of the  system)
	; 1/1200 second = 22162 = $0005692
	move.l  #(((26593900 / 1000) << 16) | ((26593900 / 1000) >> 16)), PIT0
	;
	rts


init_video:
	; set the Vertical Interrupt (F0004E) very high to disable video interrupts
	move.w  #$FFFF, VI
;
	movem.l	d0-d6, -(sp)
	; PAL/NTSC detection
	move.w	CONFIG, d0			; Read the Button register (F14002) also a joystick register
	andi.w	#VIDTYPE, d0			; 0=PAL,1=NTSC
	beq.s	.palvals
	; get values for NTSC (60Hz) [525 lines]
;	move.w	#60, _vblPerSec
	move.w	#NTSC_HMID, d2
	move.w	#NTSC_WIDTH, d0
	move.w	#NTSC_VMID, d6
	move.w	#NTSC_HEIGHT, d4
	bra.s	.calc_vals
	; get values for PAL (50Hz) [625 lines]
.palvals:
;	move.w	#50, _vblPerSec
	move.w	#PAL_HMID, d2
	move.w	#PAL_WIDTH, d0
	move.w	#PAL_VMID, d6
	move.w	#PAL_HEIGHT, d4
	; setup values depend PAL/NTSC
.calc_vals:
	move.w	d0, _video_width
	move.w	d4, _video_height
	; horizontal Display calculus
	move.w	d0, d1
	asr	#1, d1				; (Width/2) ~ NTSC = 1409/2 = 704 ~ PAL = 1381/2 = 690
	sub.w	d1, d2				; (HMid-(Width/2)) ~ NTSC = 823-704 = 119 ~ PAL = 843-690 = 153
	add.w	#4, d2				; (HMid-(Width/2))+4 ~ NTSC = 119+4 = 123 ~ PAL = 153+4 = 157
	sub.w	#1, d1				; (Width/2)-1 ~ NTSC = 704-1 = 703 ~ PAL = 690-1 = 689
	ori.w	#$400, d1			; (((Width/2)-1) | $400 or 1024) ~ NTSC = 703|$400 = 1727 ~ PAL = 689|$400 = 1713
;	move.w	d1, _a_hde			
	move.w	d1, HDE				; Set the Horizontal Display End (F0003C) to 1727 (NTSC) or 1713 (PAL)
;	move.w	d2, _a_hdb
	move.w	d2, HDB1			; Set the Horizontal Display Begin 1 (F00038) to 123 (NTSC) or 157 (PAL)
	move.w	d2, HDB2			; Set the Horizontal Display Begin 2 (F0003A) to 123 (NTSC) or 157 (PAL)
	; vertical Display calculus
	move.w	d6, d5
	sub.w	d4, d5				; (VMID-HEIGHT) ~ NTSC = 266-241 = 15 ~ PAL = 322-287 = 35
	move.w	d5, _a_vdb
	add.w	d4, d6				; (VMID+HEIGHT) ~ NTSC = 266+241 = 507 ~ PAL = 322+287 = 609
	move.w	d6, _a_vde
	move.w	d5, VDB				; Set the Vertical Display Begin (F00046) to 15 (NTSC) or 35 (PAL)
	move.w  #$FFFF, VDE			; Force the Vertical Display End (F00048)
	; set "basic" colors
	move.l	#0, BORD1			; Set the Border Colour (Red & Green - Blue) [F0002A] to 0
	move.l	#0, BG				; Set the Background Colour (F00058) to 0
	; init VBL counter
	move.l	#0, ajag_VBL
	;setup CPU and vertical interruptions
	move.w  _a_vde, d0        		; Get vertical display end
	ori.w   #1, d0				; Must be ODD
	move.w  d0, VI				; Set the Vertical Interrupt ($F0004E) based on the end of the vertical display
	move.w  _a_vde, d0        		; Get vertical display end
	ori.w   #1, d0				; Must be ODD
	move.w  d0, VI				; Set the Vertical Interrupt ($F0004E) based on the end of the vertical display
	move.w  #(C_VIDENA | C_PITENA), INT1    ; Set the CPU Interrupt Control Register ($F000E0) to enable Video time-base interrupts & CPU
;
; End of function
;
	movem.l	(sp)+, d0-d6
	rts


UpdateIRQs:
	;
	movem.l  d0-d1/a0, -(sp)
	; CPU Interrupt Control Register (F000E0)
	move.w  INT1, d0
	move.w  d0, d1
	lsl.w   #8, d1
	; VBL (video) & PIT (Timer)
	or.w    #(C_VIDENA | C_PITENA), d1
	; mark interrupts as serviced, and re-enable them
	move.w  d1, INT1
	; bit3 = Timer-IRQ?
	btst    #3,d0							
	beq.s   no_timer
	; increment the number of ms
	add.l	#1, ajag_mstimer
no_timer:
	; bit0 = a VBL?
	btst    #0,d0
	beq.s   no_blank
	; increment the vertical blank counter - number of interuptions encountered
	move.l  #(listbuf + BITMAP_OFF), a0
	move.l  bmpupdate, (a0)      			; Phrase = d1.l/d0.l
	move.l  (bmpupdate + 4), 4(a0)
	add.l	#1, ajag_VBL
no_blank:
	; set the CPU Interrupt resume register (F000E2) - Bus priorities are restored
	move.w  #$0, INT2
	;						
	movem.l  (sp)+, d0-d1/a0
	rte


	.bss

	.even
ajag_mstimer:	.ds.l	1			; number of ms
ajag_VBL:	.ds.l	1			; number of VBL	
;_vblPerSec:	.ds.w	1			; 50/60 Hz
_video_width:	.ds.w	1			; video width
_video_height:	.ds.w	1			; video height
;_a_hdb:		.ds.w	1
;_a_hde:		.ds.w	1			; horizontal display end
_a_vdb:		.ds.w	1
_a_vde:		.ds.w	1			; vertical display end
bmpupdate:	.ds.l	2			; one Phrase of Bitmap for Refresh

	.dphrase
listbuf:	.ds.l	(LISTSIZE * 2)  	; objects List
