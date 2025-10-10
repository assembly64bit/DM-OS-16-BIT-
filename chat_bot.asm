[BITS 16]
[GLOBAL chat_bot]

extern sys_write
extern sys_read

chat_bot:
	xor ax, ax
	mov ds, ax
	mov es, ax

	mov ah, 0xE
	mov al, 'A'
	int 10h


	jmp $

; SECTION .DATA
msg_chat_bot		db "Hello ",0

