[BITS 16]
[GLOBAL LCM_GCD]

extern sys_read
extern sys_write
extern clear_src

LCM_GCD:
	xor ax, ax
	mov ds, ax
	mov es, ax

	mov si, msg_not
	call sys_write

	mov si, msg
	call sys_write

	mov si, ip_num
	call sys_read

	mov si, ip_num
	call str_to_int

	mov [save_num_1], ax


	mov si, newline
	call sys_write

;----------------------------------------

	mov si, msg
	call sys_write

	mov si, ip_num
	call sys_read

	mov si, ip_num
	call str_to_int

	mov [save_num_2], ax

	mov si, newline
	call sys_write

;------------------------------------------
	mov si, result_2
	call sys_write

; GCD
	xor ax, ax
	xor bx, bx

	mov ax, [save_num_1]
	mov bx, [save_num_2]
loop_2:
	xor dx, dx

	div bx
	mov [save_result], bx

	test dx, dx
	jz done_2

	mov ax, bx
	mov bx, dx

	jmp loop_2

done_2:
	lea di, [result+4]
	mov byte [di], 0

	call int_to_str

	mov si, di
	call sys_write


	mov si, newline
	call sys_write

	mov si, result_1
	call sys_write

	xor ax, ax
	xor bx, bx
	xor cx, cx
; LCM
	mov ax, [save_num_1]
	mov bx, [save_num_2]
	mov cx, [save_result]

	imul bx
	xor dx, dx
	div cx
	mov [save_result], ax

	lea di, [result+4]
	mov byte [di], 0

	call int_to_str
	mov si, di
	call sys_write

	mov si, newline
	call sys_write

	mov si, con_msg
	call sys_write

	xor ax, ax
	int 0x16

	ret

























;---------------------------------------------
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
int_to_str:
        mov ax, [save_result]
loop_1:
        mov cx, 10
        xor dx, dx
        div cx
        add dl, '0'
        dec di
        mov [di], dl
        test ax, ax
        jnz loop_1
        ret





























; SECTION .DATA
msg             db "Enter your number  : ", 0

result_1        db "Result LCM is : ", 0
result_2	db "Result GCD is : ", 0
con_msg         db "Press any key to continue",0
newline         db 13,10,0
msg_not          db "Note: Do not enter or multiply numbers greater than 65535",13,10,0

ip_num: times 5 db 0
save_num_1: times 1 dw 0
save_num_2: times 1 dw 0
save_result:times 1 dw 0
result: times 5 db 0
