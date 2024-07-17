
; ASM Conditional
;
	.equ	BSS_RAZ, 1			; 0: No BSS initialisation but requires to have all variables set to 0 individually
;
.ifndef RELEASE
.ifndef RETAIL
	.equ	FRAMEPOINTER, 1			; 0: No frame pointer at the begining of a function
.endif
.endif

; variables & arrays declarations
;
.ifdef BSS_RAZ
	.extern	__bss_start__, __bss_size__
.endif
	.extern __Stack, main
.ifdef LIB_GCC
	.extern	environ, environ_VMA	;, environ_LMA
	.extern	__HeapBase
.endif
.ifdef PROFILE
	.extern	__text_end__, __text_start__
.endif
.ifdef ARGS
	.extern NXArgc, NXArgv
.endif

; functions declarations
;
.ifdef PROFILE
	.extern	monstartup, _mcleanup
.endif
	.globl	_start, _text_start, _reset
.ifdef LIB_GCC
	.globl	_end
.else
	.globl	_exit
.endif


; Program Entry Point
;
	.text
;
_start:
_reset:	
_text_start:
;
; Stack initilisations
;
	move.l	#__Stack, a7								; Setup stack
.ifdef FRAMEPOINTER
	pea.l	_start										; _start is the return address, set in order to have an unknown return value
	link.w	a6, #0
.endif
;
; Clear BSS section
;
.ifdef BSS_RAZ
	move.l	#__bss_start__,a0
	move.l	#__bss_size__,d0
	beq.s	.bzerof
.bzero:
	clr.l	(a0)+
	subq.l	#4,d0
	bne.s	.bzero
.bzerof:
.endif
;
; Gcc's library initialisations
;
.ifdef LIB_GCC
	move.l	#__HeapBase, heap_ptr
.endif
;
; Set the environement's variables
;
.ifdef LIB_GCC
	move.l	environ, a1
	move.l	#environ_VMA,a0
.env:
	move.l	(a0)+, (a1)+
	bne.s	.env
.endif
;
; Pass information to monstartup
;
.ifdef PROFILE
	pea.l	__text_end__		; text end
	pea.l	__text_start__		; text start
	jsr	monstartup
	addq.l	#8, sp
.endif
;
; Pass argc and argv[] in stack and call main
;
.ifdef ARGS
	move.l	#NXArgv, d0			; argv
	move.l	d0, -(a7)
	move.l	NXArgc, d0			; argc
	move.l	d0, -(a7)
.endif
	jsr	main
.ifdef ARGS
	addq.l	#8, sp
.endif
;
; Gmon cleanup
;
.ifdef PROFILE
	jsr	_mcleanup
.endif
;
; Exit
;
.ifdef FRAMEPOINTER
	unlk	a6
.endif
.ifndef LIB_GCC
_exit:
.else
_end:
.endif
;	trap	#0
_exit_loop:
	bra.s	_exit_loop
