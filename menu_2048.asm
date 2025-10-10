[BITS 16]
[GLOBAL menu_2048_mode]

extern clear_src
extern sys_write
extern easy_mode
extern sys_draw_c

menu_2048_mode:

	xor ax, ax
	mov es, ax
	mov ds, ax

start_game:

	call clear_src

	mov si, menu_2048_mode_msg
	mov bh, 0x09
	xor di, di
	call sys_draw_c

	xor ah, ah
	int 0x16

	cmp al, '1'
	je easy_mode_game

	cmp al, '2'
	je medium_mode

	cmp al, '3'
	je hard_mode

	cmp al, '4'
	je print_gi

	cmp al, '5'
	je back_to_menu_game

	jmp start_game

easy_mode_game:
	call clear_src
	call easy_mode

	jmp menu_2048_mode

medium_mode:
	ret
	cli
	hlt

hard_mode:
	ret
	cli
	hlt





print_gi:
	call clear_src

	mov si, gi_msg
	call sys_write

	xor ah, ah
	int 0x16

	cmp al, 'q'
	je start_game

	jmp print_gi





back_to_menu_game:
	call clear_src
	ret

























menu_2048_mode_msg db "*******************************************************************************",10
     	           db "*                                Menu_game_mode_2048                          *",10
                   db "*******************************************************************************",10
                   db "*                                1. Easy Mode                                 *",10
                   db "*                                2. Medium Mode                               *",10
                   db "*                                3. Hard Mode                                 *",10
                   db "*                                4. Game instruction                          *",10
	           db "*                                5. Back_to_menu_game                         *",10
                   db "*******************************************************************************",10
                   db "Enter numbers from 1-->4 to activate : ",0

gi_msg	           db "|========================[ BIOS 2048 OF LUCK & LOGIC ]========================|",13,10
  	           db "| Board sizes:                                                                |",13,10
	           db "| - Easy   : 3x3                                                              |",13,10
	           db "| - Medium : 2x3                                                              |",13,10
	           db "| - Hard   : 1x3                                                              |",13,10
	           db "|                                                                             |",13,10
	           db "| Each turn, 3 numbers appear. Choose 1 to place.                             |",13,10
	           db "| Manual merge only  Example:                                                 |",13,10
	           db "| Before:   100   0   100                                                     |",13,10
	           db "| You get:  100                                                               |",13,10
	           db "| Place on column 1 -> Now: 200   0   100                                     |",13,10
	           db "| No auto-merge even if same values are side-by-side                          |",13,10
	           db "|                                                                             |",13,10
	           db "| Every 5 turns: You automatically gain a 500 block.                          |",13,10
	           db "| Every 10 turns:                                                             |",13,10
	           db "| - Lucky?  You get a number >1000.                                           |",13,10
	           db "| - Unlucky? Number 13 appears ->your highest block is deleted.               |",13,10
	           db "|                                                                             |",13,10
	           db "| * Target: Reach a number >= 10000 to win the game                           |",13,10
	           db "| * No takebacks. One wrong move, and it may be over                          |",13,10
	           db "| * Enter 'q' to quit game instruction                                        |",13,10
	           db "|=============================================================================|",13,10,0

