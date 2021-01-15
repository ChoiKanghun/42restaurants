segment .text
	global _ft_strcmp

_ft_strcmp:
	mov 	rax, 0		; define rax to 0
	jmp		compa		; call compa

compa:
	mov		al, BYTE [rdi]	; get the least significant byte in rdi where is stock the value of the char
	mov		bl, BYTE [rsi]	; get the least significant byte in rsi where is stock the value of the char
	cmp		al, 0			; if we are not at the end of rdi (arg0)
	je		exit			; jump to exit_end
	cmp		bl, 0			; if we are not at the end of rdi (arg1)
	je		exit			; jump to exit
	cmp 	al, bl			; compare al and bl
	jne 	exit			; if the result of cmp is diferrent than 0 so the string are differents
	inc 	rdi				; increment the rdi pointer
	inc 	rsi				; increment the rsi pointer
	jmp 	compa			; if we are here it's because the chars of string are equals the we can continu

exit:
	movzx	rax, al			; movzx = copy a register of inferior size in a bigger and fill the other bits with 0, and this register is rax
    movzx	rbx, bl			; same that previous but set it in rbx
    sub		rax, rbx		; stock the difference of rax and rbx in rax; Finaly : do the difference beetween the char at the rdi pointer and the char at the rsi pointer 
	ret						; return (rax)