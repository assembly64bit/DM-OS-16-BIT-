[BITS 16]
[GLOBAL sys_write]

sys_write:
; Ẩn con trỏ chuột (tùy chọn)
        mov ah, 0x01
        mov cx, 0x2000
        int 0x10

loop_write:
	lodsb
	test al, al
	jz done
	mov ah, 0xE
	int 10h
	jmp loop_write
done:
	ret
