; Files structures for the OSJag support
;

; Files specific support
;
; TBD


	.globl OSJAG_Directory
	.globl OSJAG_SeekPosition
	.globl OSJAG_PtrBuffer


	.data


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
	.string "CONERR$"
	.even
OSJAG_Directory_File2_File:
OSJAG_Directory_File2_Deb:
;	.incbin	""
OSJAG_Directory_File2_End:
;
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
OSJAG_Directory_End:
	.long	0


	.bss

; Seek positions
	.even
OSJAG_SeekPosition:	.space	(OSJAG_Directory_End-OSJAG_Directory_Deb)
; Buffer pointers
	.even
OSJAG_PtrBuffer:	.space	(OSJAG_Directory_End-OSJAG_Directory_Deb)
