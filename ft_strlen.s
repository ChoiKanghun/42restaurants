; 1st arg           Stack           EBX               RDI            RDI
; 2nd arg           Stack           ECX               RSI            RSI
; 3rd arg           Stack           EDX               RDX            RDX
; 4th arg           Stack           ESI               RCX            R10
; 5th arg           Stack           EDI               R8             R8
; 6th arg           Stack           EBP               R9  

segment .text
	global _ft_strlen

; ft_strlen(arg0 = rdi = char *s)
_ft_strlen:
	mov 	rax, 0	; Move 0 to rax (return value also the count) 
	jmp 	count	; jump to count function

count:
	cmp 	BYTE [rdi + rax], 0 	; if the byte at rdi(arg0 = string) start + rax (count/return value) equal 0
	je 		exit					; so exit and return rax
	inc	 	rax						; increment rax ( = rax++ )
	jmp 	count					; jump to count and redo the test with rax + 1

exit:
	ret			; return (rax)