[BITS 16]
[GLOBAL gui_game_math]
extern sys_write
extern clear_src
extern sys_draw_c
extern math_quiz
gui_game_math:
; SET UP REG SEGMENT
	xor ax, ax
	mov es, ax
	mov ds, ax
start_game:
	call clear_src
	lea si, [rel menu_math]
	xor di, di
	mov bh, 0x0A
	call sys_draw_c

iput_choose:
	xor ah, ah
	int 16h

	cmp al, '1'
	je play

	cmp al, '2'
	je guide

	cmp al, '3'
	je back_to_menu

	jmp iput_choose
play:
	call clear_src
	call math_quiz
	jmp start_game
guide:
back_to_menu:
        call clear_src
        ret













; SECTION .DATA
menu_math	db "*******************************************************************************",10
         	db "*                                GAME MATH QUIZ                               *",10
         	db "*******************************************************************************",10
         	db "*                                1. Play                                      *",10
         	db "*                                2. Guide                                     *",10
         	db "*                                3. Back to menu                              *",10
         	db "*******************************************************************************",10
         	db "Enter numbers from 1-->3 to activate : ",0
