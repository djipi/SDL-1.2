; Files structures for the OSJag support
;

; Files specific support
;
; TBD


	.globl OSJAG_Directory			; Pointers list
	.type OSJAG_Directory, 1
	.globl OSJAG_SeekPosition		; Seek position
	.type OSJAG_SeekPosition, 1
	.globl OSJAG_PtrBuffer			; Buffer pointers
	.type OSJAG_PtrBuffer, 1


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


	.bss

; Seek positions
	.even
OSJAG_SeekPosition:
	.size	OSJAG_SeekPosition, (OSJAG_Directory_End-OSJAG_Directory_Deb)
; Buffer pointers
	.even
OSJAG_PtrBuffer:
	.size	OSJAG_PtrBuffer, (OSJAG_Directory_End-OSJAG_Directory_Deb)
