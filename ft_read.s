segment .text
	global _ft_read

; ft_read (rdi, rsi, rdx)
_ft_read:
	mov 	rax, 0x2000003	; set call to read
	syscall					; call rax (read)
		jc exit_error		; if doesn't work, read set flags carry to 1 so jmp exit error
	jmp exit				; jump exit

exit_error:
	mov 	rax, -1			; set return to -1s
	ret						; return
	
exit:
	ret						; return 