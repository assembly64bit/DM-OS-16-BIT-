[BITS 16]
[GLOBAL basic_calculations]

extern clear_src
extern sys_read
extern sys_write
extern sys_draw_c

basic_calculations:
	xor ax, ax
	mov ds, ax
	mov es, ax

	call clear_src

	mov si, menu_msg
	mov bh, 0x0C
	xor di, di
	call sys_draw_c

ip:
	xor ax, ax
	int 0x16

	cmp al, '1'
	je add

	cmp al, '2'
	je sub

	cmp al, '3'
	je mul

	cmp al, '4'
	je div

	cmp al, '5'
	je back_to_menu


add:
	call clear_src

	mov si, msg_not
	call sys_write

	mov si, msg_ip_1
	call sys_write

	mov si, number_1
	call sys_read

	mov si, number_1
	call str_to_int

	mov [save_num_1], ax

	mov si, newline
	call sys_write

;--------------------------------------------

	mov si, msg_ip_2
	call sys_write

	mov si, number_2
	call sys_read

	mov si, number_2
	call str_to_int

	mov [save_num_2], ax

	mov si, newline
	call sys_write

;-------------------------------------------
	xor ax, ax
	xor bx, bx

	mov ax, [save_num_1]
	mov bx, [save_num_2]

	add ax, bx
	mov [save_result], ax

	mov si, result_msg
	call sys_write

	lea di, [result+4]
	mov byte [di], 0
	call int_to_str

	mov si, di
	call sys_write

	mov si, newline
	call sys_write

	mov si, msg_ip_3
	call sys_write

	xor ax, ax
	int 0x16

	jmp basic_calculations
;-------------------------------------------
sub:
        call clear_src

        mov si, msg_not
        call sys_write

        mov si, msg_ip_1
        call sys_write

        mov si, number_1
        call sys_read

        mov si, number_1
        call str_to_int

        mov [save_num_1], ax

        mov si, newline
        call sys_write

;--------------------------------------------

        mov si, msg_ip_2
        call sys_write

        mov si, number_2
        call sys_read

        mov si, number_2
        call str_to_int

        mov [save_num_2], ax

        mov si, newline
        call sys_write

;-------------------------------------------
        xor ax, ax
        xor bx, bx

        mov ax, [save_num_1]
        mov bx, [save_num_2]

	sub ax, bx

	test ax, ax
	jg skip

	neg ax
skip:
	mov [save_result], ax

        mov si, result_msg
        call sys_write

        lea di, [result+4]
        mov byte [di], 0
        call int_to_str

        mov si, di
        call sys_write

        mov si, newline
        call sys_write

        mov si, msg_ip_3
        call sys_write

        xor ax, ax
        int 0x16

        jmp basic_calculations
;----------------------------------------------------------------------------------------
mul:
        call clear_src

        mov si, msg_not
        call sys_write

        mov si, msg_ip_1
        call sys_write

        mov si, number_1
        call sys_read

        mov si, number_1
        call str_to_int

        mov [save_num_1], ax

        mov si, newline
        call sys_write

;--------------------------------------------

        mov si, msg_ip_2
        call sys_write

        mov si, number_2
        call sys_read

        mov si, number_2
        call str_to_int

        mov [save_num_2], ax

        mov si, newline
        call sys_write

;-------------------------------------------
        xor ax, ax
        xor bx, bx

        mov ax, [save_num_1]
        mov bx, [save_num_2]

        mul bx
        mov [save_result], ax

        mov si, result_msg
        call sys_write

        lea di, [result+4]
        mov byte [di], 0
        call int_to_str

        mov si, di
        call sys_write

        mov si, newline
        call sys_write

        mov si, msg_ip_3
        call sys_write

        xor ax, ax
        int 0x16

        jmp basic_calculations






;----------------------------------------------------------------------
div:
        call clear_src

        mov si, msg_not
        call sys_write

        mov si, msg_ip_1
        call sys_write

        mov si, number_1
        call sys_read

        mov si, number_1
        call str_to_int

        mov [save_num_1], ax

        mov si, newline
        call sys_write

;--------------------------------------------

        mov si, msg_ip_2
        call sys_write

        mov si, number_2
        call sys_read

        mov si, number_2
        call str_to_int

        mov [save_num_2], ax

        mov si, newline
        call sys_write

;-------------------------------------------
        xor ax, ax
        xor bx, bx

        mov ax, [save_num_1]
        mov bx, [save_num_2]

	xor dx, dx
	cmp ax, bx
	jg skip_div

; NUM_2 > NUM_1

	mov ax, [save_num_2]
	mov bx, [save_num_1]
skip_div:
	div bx

	mov [save_result], ax

        mov si, result_msg
        call sys_write

        lea di, [result+4]
        mov byte [di], 0
        call int_to_str

        mov si, di
        call sys_write

        mov si, newline
        call sys_write

        mov si, msg_ip_3
        call sys_write

        xor ax, ax
        int 0x16

        jmp basic_calculations

















































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













back_to_menu:

	call clear_src
	ret




































; SECTION .DATA
menu_msg	 db "*******************************************************************************",10
        	 db "*                                Welcome to basic calculations                *",10
        	 db "*******************************************************************************",10
       		 db "*                                1. Addition                                  *",10
        	 db "*                                2. Subtraction                               *",10
        	 db "*                                3. Multiplication                            *",10
        	 db "*                                4. Division                                  *",10
		 db "*                                5. Back to menu                              *",10
        	 db "*******************************************************************************",10
        	 db "Enter numbers from 1-->5 to activate : ",0

msg_ip_1 	 db "Input number one : ", 0
msg_ip_2	 db "Input number two : ", 0
result_msg	 db "Result is : ", 0

msg_ip_3	 db "Press any key to continue ",0

msg_not		 db "Note: Do not enter or multiply numbers greater than 65535",13,10,0
newline		 db 13,10,0

number_1: times 5 db 0
number_2: times 5 db 0
result: times 5 db 0

save_num_1: times 1 dw 0
save_num_2: times 1 dw 0
save_result: times 1 dw 0
