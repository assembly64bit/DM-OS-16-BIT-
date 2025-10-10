[BITS 16]
[GLOBAL learn_app]

extern sys_write
extern clear_src

learn_app:
	xor ax, ax
	mov es, ax
	mov ds, ax
ip:
	mov si, msg
	call sys_write

	jmp $



; section .data
	msg	db "Hello",0

