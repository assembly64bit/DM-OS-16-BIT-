[BITS 16]
[GLOBAL menu_ad_game]

extern sys_write
extern clear_src
extern ad_game_play
extern sys_draw_c

menu_ad_game:
	xor ax, ax
	mov ds, ax
	mov es, ax

loop_menu_ad_game:
	call clear_src

	mov si, menu_msg
	mov bh, 0x0B
	xor di, di
	call sys_draw_c

ip:
	xor ah, ah
	int 0x16

	cmp al, '1'
	je play_game_ad

	cmp al, '2'
	je guide

	cmp al, '3'
	je back_to_menu

	jmp ip

play_game_ad:
	call clear_src
	call ad_game_play

	jmp loop_menu_ad_game

guide:
back_to_menu:
	call clear_src
	ret


























; SECTION .DATA
menu_msg db "*******************************************************************************",10
         db "*                                Game adventure                               *",10
         db "*******************************************************************************",10
         db "*                                1. Play                                      *",10
         db "*                                2. Guide                                     *",10
         db "*                                3. Back_to_menu                              *",10
         db "*******************************************************************************",10
         db "Enter numbers from 1-->2 to activate : ",0
