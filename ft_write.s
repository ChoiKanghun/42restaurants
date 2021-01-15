segment .text
	global _ft_write

; ft_write (rdi, rsi, rdx)
_ft_write:
	mov r8, rdx				; save rdx = len in r8
	mov rax, 0x2000004		; set call to write
    syscall					; call rax (write)
		jc exit_error		; if doesn't work, write set flags carry to 1 so jmp exit error
	jmp exit				; jump exit

exit_error:
	mov rax, -1				; set return to -1
	ret						; return

exit:
	mov rax, r8				; set previous value of rdx save in r8, in return value
	ret						; return 
	
