[BITS 16]
[GLOBAL menu_game]

extern sys_write
extern clear_src
extern sys_draw_c

extern x_o
extern menu_2048_mode
extern gui_game_math
extern menu_ad_game

menu_game:
	xor ax, ax
	mov ds, ax
	mov es, ax

	call clear_src
	mov si, menu_game_msg
	mov bh, 0x06
	xor di, di
	call sys_draw_c
; READ
read:
	xor ah, ah
	int 0x16

	cmp al, '1'
	je x_o_game

	cmp al, '2'
	je game_2048

	cmp al, '3'
	je game_math

	cmp al, '4'
	je menu_ad_game_play

	cmp al, '5'
	je back_to_menu


	jmp read
x_o_game:
	call clear_src
	call x_o
	jmp menu_game


game_2048:
	call clear_src
	call menu_2048_mode
	jmp menu_game
game_math:
	call clear_src
	call gui_game_math
	jmp menu_game

menu_ad_game_play:
	call clear_src
	call menu_ad_game

	jmp menu_game

back_to_menu:
	call clear_src
	ret

























; DATA
menu_game_msg db "*******************************************************************************",10
              db "*                                Welcome to Game-App                          *",10
              db "*******************************************************************************",10
;              db "*                                1. Guess_num                                 *",10
              db "*                                1. Caro_chess                                *",10
              db "*                                2. Game_2048_limited_on_OS                   *",10
 ;             db "*                                4. Survival_Game                             *",10
	      db "*                                3. Math Quiz                                 *",10
	      db "*                                4. Game adventure                            *",10
	      db "*                                5. Back_to_menu                              *",10
              db "*******************************************************************************",10
              db "Enter numbers from 1-->5 to play_game : ",0

