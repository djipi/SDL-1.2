
	.include "JAGUAR.inc"
	.include "video.inc"

	; Screens dimension
	BMP_WIDTH   	.equ    320			; width in Pixels
	BMP_HEIGHT  	.equ    240			; height in Pixels
	BMP_PHRASES 	.equ    (BMP_WIDTH / 8)		; width in Phrases

	; function
	.globl	setvideo_320x240x8
	; data
	.globl	ajag_screen

	.extern	_a_vdb
	.extern	_a_vde
	.extern	listbuf
	.extern	bmpupdate
	.extern	_video_width
	.extern	_video_height


	.text

setvideo_320x240x8:
	;
	movem.l d1-d4/a0, -(sp)
	;
	; get Object List pointers		
	lea     listbuf, a0					; get the Object List start address
	move.l  a0, d2
	add.l   #((LISTSIZE - 1) * 8), d2			; calcul the Object List STOP address
	move.l	d2, d3						; copy for low half
	lsr.l	#8, d2						; shift high half into place
	lsr.l	#3, d2
	swap	d3						; place low half correctly
	clr.w	d3
	lsl.l	#5, d3
	;
	; write first BRANCH object (branch if YPOS > a_vde )
	clr.l   d0
	move.l  #(BRANCHOBJ|O_BRLT), d1				; $4000 = VC < YPOS
	or.l	d2, d0						; do LINK overlay
	or.l	d3, d1
	move.w  _a_vde, d4					; for YPOS
	lsl.w   #3, d4						; make it bits 13-3
	or.w    d4, d1
	move.l	d0, (a0)+
	move.l	d1, (a0)+
	;
	; write second branch object (branch if YPOS < a_vdb)
	; note: LINK address is the same so preserve it
	andi.l  #$FF000007, d1					; mask off CC and YPOS
	ori.l   #O_BRGT, d1					; $8000 = VC > YPOS
	move.w  _a_vdb, d4					; for YPOS
	lsl.w   #3, d4						; make it bits 13-3
	or.w    d4, d1
	move.l	d0, (a0)+
	move.l	d1, (a0)+
	;
	; write a standard BITMAP object
	move.l	d2, d0
	move.l	d3, d1
	ori.l	#(BMP_HEIGHT << 14), d1				; height of image
	move.w  _video_height, d4				; center bitmap vertically
	sub.w   #BMP_HEIGHT, d4
	add.w   _a_vdb, d4
	andi.w  #$FFFE, d4					; must be even
	lsl.w   #3, d4
	or.w    d4, d1						; stuff YPOS in low phrase
	move.l	#ajag_screen, d4
	lsl.l	#8, d4
	or.l	d4, d0
	move.l	d0, (a0)+
	move.l	d1, (a0)+
	movem.l	d0-d1, bmpupdate
	;
	; second Phrase of Bitmap
	move.l	#(BMP_PHRASES >> 4), d0				; only part of top LONG is IWIDTH
	move.l  #(O_DEPTH8|O_NOGAP), d1				; Bit Depth = 8-bit, Contiguous data
	move.w  _video_width, d4				; get width in clocks
	lsr.w   #2, d4						; /4 Pixel Divisor
	sub.w   #BMP_WIDTH, d4
	lsr.w   #1, d4
	or.w    d4, d1
	ori.l	#((BMP_PHRASES << 18)|(BMP_PHRASES << 28)), d1	; DWIDTH|IWIDTH
	move.l	d0, (a0)+
	move.l	d1, (a0)+
	;
	; write a STOP object at end of the list
	clr.l   (a0)+
	move.l  #(STOPOBJ|O_STOPINTS), (a0)+
	;
	; return swapped Objects list pointer in D0
	move.l  #listbuf, d0
	swap    d0
	;
	; Sneaky trick to cause display to popup at first VB
	move.l	#$0, listbuf + BITMAP_OFF			; ?
	move.l	#$C, (listbuf + BITMAP_OFF + 4)			; ?
	;
	move.l	d0,OLP
	; configure video (F00028) to $6C7
	move.w  #(VIDEN|RGB16|CSYNC|BGEN|PWIDTH4), VMODE
	;
	movem.l (sp)+, d1-d4/a0
	rts


	.bss

	.dphrase
ajag_screen:	.ds.b	(BMP_WIDTH * BMP_HEIGHT)
