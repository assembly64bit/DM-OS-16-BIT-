[BITS 16]
[GLOBAL cmd]
extern sys_read
extern sys_write
extern clear_src
extern sys_draw_c

extern x_o
extern menu_2048_mode
extern gui_game_math
extern menu_ad_game

extern menu_calculator
extern menu_learn_app

cmd:
; RESET SEGMENT
	xor ax, ax
	mov ds, ax
	mov es, ax

	call clear_src
ip:
	lea si, [msg_cmd]
	call sys_write

	lea si, command_ip
	mov di, 99
	call sys_read

	mov ax, [command_ip]
;============GAME==============
	cmp ax, 'g1'
	je g1

	cmp ax, 'g2'
	je g2

	cmp ax, 'g3'
	je g3

        cmp ax, 'g4'
        je g4
;============APP============
	cmp ax, 'ca'
	je caculator_app

	cmp ax, 'cs'
	je learn_app

;============MODULE=========
	cmp ax, 'cr'
	je clear_src_cmd

	cmp al, 'q'
	je back_to_main

	cmp al, 'h'
	je help

	cmp ax, 'e1'
	je print

;============BACK TO MAIN=====

	lea si, [newline]
	call sys_write

	jmp ip

g1:
	call clear_src
	call x_o

	jmp ip
g2:
	call clear_src
	call menu_2048_mode

	jmp ip
g3:
	call clear_src
	call gui_game_math

	jmp ip
g4:
	call clear_src
	call menu_ad_game

	jmp ip

caculator_app:
	call clear_src
	call menu_calculator

	jmp ip
learn_app:
        call clear_src
        call menu_learn_app

        jmp ip

clear_src_cmd:
	call clear_src
	jmp ip

help:
	call print_msg_help
	jmp ip

back_to_main:
        call clear_src
	ret


;==============================
print:
; NEWLINE
	mov si, newline
	call sys_write

	mov si, command_ip
	mov al, [dau]
; FIND '
loop:
	mov bl, [si]

	inc si

	cmp al, bl
	je next

	jmp loop
;======================
next:
	mov di, buf_print
	mov cx, 100
; COPY BUF
loop_copy:
	mov bl, [si]

	cmp al, bl
	je done_loop

	mov [di], bl

	inc di
	inc si

	dec cx
	test cx, cx
	jle not_found

	jmp loop_copy
done_loop:

	mov byte [di], 13
	mov byte [di+1], 10
	mov byte [di+2], 0

	mov si, buf_print
	call sys_write

	jmp ip
not_found:
	mov si, newline
	call sys_write

	mov si, msg_not_found
	call sys_write

	jmp ip

;===========
print_msg_help:
	call clear_src

	lea si, [msg_help]
	call sys_write
ip_q:
	xor ax, ax
	int 16h

	cmp al, 'q'
	jne ip_q

        call clear_src
	ret






; SECTION .DATA
msg_cmd 			db "Enter command ( Type h to help ) : ",0
newline				db 13,10,0

msg_help 			db "Type g1 to access game app 1",13,10
         			db "Type g2 to access game app 2",13,10
         			db "Type g3 to access game app 3",13,10
         			db "Type g4 to access game app 4",13,10
         			db "Type ca to access calculator",13,10
         			db "Type cs to access cheat sheet for 64-bit asm",13,10
				db "Type e1 'str' to print string ",13,10
         			db "Type q to quit",13,10,0


command_ip:			times 100 db 0
msg_e				db "e1",0
dau				db "'",0

buf_print:			times 100 db 0

msg_db				db "found !!",0
msg_not_found			db "Not found command !!!",13,10,0
