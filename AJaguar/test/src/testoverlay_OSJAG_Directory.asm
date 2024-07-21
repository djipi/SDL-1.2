; Files structures for the OSJag support
;

; Files specific support
;
; TBD


	.globl OSJAG_Directory			; Pointers list
	.globl OSJAG_SeekPosition		; Seek position
	.globl OSJAG_PtrBuffer			; Buffer pointers


	.data


;***********************
;* Game files directory
;***********************
;
	.even
OSJAG_Directory:
OSJAG_Directory_Deb:
	.long	OSJAG_Directory_File0_Info
	.long	OSJAG_Directory_File1_Info
	.long	OSJAG_Directory_File2_Info
	.long	OSJAG_Directory_File3_Info
	.long	OSJAG_Directory_File4_Info
OSJAG_Directory_End:
	.long	0
;
;**************************
;* Game files descriptions
;**************************
;
	.even
OSJAG_Directory_File0_Info:
	.long	OSJAG_Directory_File0_File
	.long	OSJAG_Directory_File0_End-OSJAG_Directory_File0_Deb
	.string	"CONIN$"
	.even
OSJAG_Directory_File0_File:
OSJAG_Directory_File0_Deb:
;	.incbin	""
OSJAG_Directory_File0_End:
;
	.even
OSJAG_Directory_File1_Info:
	.long	OSJAG_Directory_File1_File
	.long	OSJAG_Directory_File1_End-OSJAG_Directory_File1_Deb
	.string	"CONOUT$"
	.even
OSJAG_Directory_File1_File:
OSJAG_Directory_File1_Deb:
;	.incbin	""
OSJAG_Directory_File1_End:
;
	.even
OSJAG_Directory_File2_Info:
	.long	OSJAG_Directory_File2_File
	.long	OSJAG_Directory_File2_End-OSJAG_Directory_File2_Deb
	.string	"CONERR$"
	.even
OSJAG_Directory_File2_File:
OSJAG_Directory_File2_Deb:
;	.incbin	""
OSJAG_Directory_File2_End:
;
	.even
OSJAG_Directory_File3_Info:
	.long	OSJAG_Directory_File3_File
	.long	OSJAG_Directory_File3_End-OSJAG_Directory_File3_Deb
	.string	"../../test/sample.bmp"
	.even
OSJAG_Directory_File3_File:
OSJAG_Directory_File3_Deb:
;	.incbin	""
OSJAG_Directory_File3_End:
;
	.even
OSJAG_Directory_File4_Info:
	.long	OSJAG_Directory_File4_File
	.long	OSJAG_Directory_File4_End-OSJAG_Directory_File4_Deb
	.string	"../../test/moose.dat"
	.even
OSJAG_Directory_File4_File:
OSJAG_Directory_File4_Deb:
;	.incbin	""
OSJAG_Directory_File4_End:


	.bss

; Seek positions
	.even
;OSJAG_SeekPosition:
	.comm	OSJAG_SeekPosition, 20	;(OSJAG_Directory_End-OSJAG_Directory_Deb)
; Buffer pointers
	.even
;OSJAG_PtrBuffer:
	.comm	OSJAG_PtrBuffer, 20	;(OSJAG_Directory_End-OSJAG_Directory_Deb)
