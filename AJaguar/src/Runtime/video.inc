

;Objects list information
LISTSIZE    	.equ    5		; objects List length (in Phrases) must include the Stop
					; 0: 1st Branch
					; 1: 2nd Branch
					; 2: Standart Bitmap
					; 3:
					; 4: Stop
BITMAP_OFF  	.equ    (2*8)       	; two Phrases
