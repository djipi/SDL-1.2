
.ifndef LIB_GCC
	.globl	environ
.endif
	.globl	environ_VMA	;, environ_LMA
;
	.local	environ1a, environ2a

	.data
	
	.even
.ifndef LIB_GCC
environ:	.long	environ_VMA
.endif
environ_VMA:
	.long	environ1a
	.long	environ2a
	.long	0

	.even
environ1a:	.string	"SDL_AUDIODRIVER=AJaguar_AUDIO"
	.even
environ2a:	.string	"SDL_VIDEODRIVER=AJaguar_VIDEO"

;	.bss
;	
;	.even
;.ifdef LIB_GCC
;environ_LMA:
;	.size	environ_LMA, 3 * 4
;.endif
