[BITS 16]
[GLOBAL dec_to_bin]

extern clear_src
extern sys_read
extern sys_write

dec_to_bin:
	xor ax, ax
	mov ds, ax
	mov es, ax

	call clear_src
ip:
	mov si, msg_not
	call sys_write

	mov si, msg
	call sys_write

	mov si, ip_num
	call sys_read

        mov si, newline
        call sys_write

	mov si, result
	call sys_write

	mov si, ip_num
	call str_to_int

	mov [save_num], ax
	mov ax, [save_num]
	lea di, [save_result+99]
	mov byte [di], 0

loop_change:
	xor dx, dx
	mov cx, 2
	div cx
	add dl, '0'
	dec di
	mov [di], dl
	test ax, ax
	jnz loop_change
; PRINT
	mov si, di
	call sys_write

	mov si, newline
	call sys_write

	mov si, con_msg
	call sys_write

	xor ax, ax
	int 0x16

	ret



















; MODUN
str_to_int:
        xor cx, cx
        xor ax, ax
loop:
        movzx cx, byte [si]

        cmp cx, 0
        je done

        cmp cx, 10
        je done

        sub cx, '0'
        imul ax, ax, 10
        add ax, cx

        inc si

        jmp loop
done:
        ret

;----------------------------------------------------------------------------------------------











; SECTION .DATA
msg		db "Enter number to change : ", 0
result		db "Result is : ", 0
con_msg		db "Press any key to continue",0
newline		db 13,10,0
msg_not          db "Note: Do not enter or multiply numbers greater than 65535",13,10,0
ip_num: times 5 db 0
save_num: times 1 dw 0
save_result: times 100 db 0
