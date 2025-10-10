[BITS 16]
[GLOBAL sys_print]

sys_print:
	lodsb
	test al, al
	je done_sys_print

	mov ah, 0x0E
	int 0x10

	jmp sys_print

done_sys_print:
	ret
