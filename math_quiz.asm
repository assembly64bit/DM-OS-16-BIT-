[BITS 16]
[GLOBAL math_quiz]

extern sys_read
extern sys_write
extern clear_src
extern sys_read_specail_for_math
extern sys_draw_c

math_quiz:
	xor ax, ax
	mov es, ax
	mov ds, ax
	mov word [point], 0
loop_input:
        call clear_src

	mov si, msg
	call sys_write


	rdtsc
	xor ax, dx
	xor cx, cx
	xor cx, 111
	xor dx, dx
	div cx
	xchg bx, ax
continue_1:
	add bx, 500
	xor ax, ax
	xor ax, bx
	xchg [num_1], bx		; save num_1


	mov ax, [num_1]
	lea di, [num1+6]
	call int_to_str

	lea si, [di+1]
	call sys_write

; RANDOM PHEP TINH
random:
	nop
	nop
	nop
	rdtsc
	xor dx, dx
	xor cx, cx
	xor cx, 4
	div cx
	mov di, msg_ran
	add di, dx
	xor ax, ax
	mov ah, 0xE
	mov al, [di]
	int 10h

; CHECK PHEP TINH
	cmp al, '+'
	je add

	cmp al, '-'
	je sub

	cmp al, '*'
	je imul

	cmp al, '/'
	je div

	jmp random
add:
	rdtsc
        xor cx, cx
        xor cx, 111
        xor dx, dx
        div cx
	xchg bx, ax
continue_2:
        xor ax, ax
        xor ax, bx
	xchg [num_2], bx                ; save num_2

        lea di, [num2+6]
        call int_to_str
        lea si, [di+1]
        call sys_write
; ADD
	movsx ax, [num_1]
	movsx bx, [num_2]
	add ax, bx
	mov [result_check], ax

	jmp input_res
sub:
        rdtsc
        xor cx, cx
        xor cx, 111
        xor dx, dx
        div cx
        xchg bx, ax
        xor ax, ax
        xor ax, bx
        xchg [num_2], bx                ; save num_2

        lea di, [num2+6]
        call int_to_str
        lea si, [di+1]
        call sys_write
; SUB
        movsx ax, [num_1]
        movsx bx, [num_2]
       	sub ax, bx
        mov [result_check], ax
	jmp input_res
imul:
        rdtsc
        xor cx, cx
        xor cx, 1111
        xor dx, dx
        div cx
        xchg bx, ax
        xor ax, ax
        xor ax, bx
        xchg [num_2], bx                ; save num_1

        lea di, [num2+6]
        call int_to_str
        lea si, [di+1]
        call sys_write
; IMUL
        movsx ax, [num_1]
        movsx bx, [num_2]
       	imul ax, bx
        mov [result_check], ax
	jmp input_res
div:
        rdtsc
        xor cx, cx
        xor cx, 111
        xor dx, dx
        div cx
        xchg bx, ax
        xor ax, ax
        xor ax, bx
        xchg [num_2], bx                ; save num_1

        lea di, [num2+6]
        call int_to_str
        lea si, [di+1]
        call sys_write
; DIV
        mov ax, [num_1]
        mov bx, [num_2]
        xor dx, dx
	div bx
	mov [result_check], ax
input_res:
; PRINT '='
	mov ah, 0xE
	mov al, '='
	int 10h
; INPUT
	mov si, result_input
	mov di, 6
	call sys_read_specail_for_math

	mov al, [result_input]
	cmp al, 'q'
	je back_to_menu

	call str_to_int
; CHECK RES
	movsx ax, [result_check]
	movsx bx, [result_input_check]

	cmp ax, bx
	jnz wrong
; TRUE
	mov si, newline
	call sys_write

	mov si, msg_1
	call sys_write

	mov si, msg_point
	call sys_write

	inc word [point]
	mov ax, [point]

	lea di, [point_print+6]
	call int_to_str

	lea si, [di+1]
	call sys_write

	call delay

	jmp loop_input
wrong:
        mov si, newline
        call sys_write

        mov si, msg_2
        call sys_write

	call delay

	jmp loop_input
;====================================================
; MODDUN
int_to_str:
	mov byte [di], 0
	dec di
loop:
	xor cx, cx
	xor dx, dx
	xor cx, 10
	div cx
	add dl, '0'
	mov [di], dl
	dec di
	test ax, ax
	jnz loop
	ret
;=======================================================
str_to_int:
	lea di, [result_input]
	xor ax, ax
	xor cx, cx
loop_str_to_int:
	movzx cx, byte [di]

	test cx, cx
	jz done
	cmp cx, 10
	je done

	sub cx, '0'
	imul ax, ax, 10
	add ax, cx
	inc di
	jmp loop_str_to_int
done:
; SAVE RES
	mov [result_input_check], ax
	ret
;=======================================================
delay:
        mov bx, 2000
delay_1:
        mov cx, 0xFFFF
loop_delay_1:
        xor ax, ax
        add ax, ax
        add ax, dx
        add ax, ax
        add ax, dx
        xor ax, ax
        xor dx, dx
        mul ax
        mul ax
        mul ax
        mul ax
        mul ax
        mul ax

        loop loop_delay_1
        dec bx

        test bx, bx
        jnz delay_1
        ret
;===========================================================
back_to_menu:
	call clear_src
	ret








; SECTION .DATA
msg			db "Input result to complete",13,10,0
msg_point		db "Point you have now : ",0

msg_1			db "TRUE",13,10,0
msg_2			db "WRONG",13,10,0

msg_ran			db "+-*/",0

num1: 			times 7 db 0
num2: 			times 7 db 0

num_1:			times 1 dw 0
num_2:			times 1 dw 0

result_input:		times 7 db 0
result_input_check:	times 2 dw 0
result_check:		times 2	 dw 0
point:			times 1 dw 0
point_print:		times 7 db 0

newline	db 13,10,0
