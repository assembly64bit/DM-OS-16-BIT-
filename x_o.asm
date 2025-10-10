[BITS 16]
[GLOBAL x_o]
extern sys_read
extern sys_write
extern clear_src
x_o:
	xor ax, ax
	mov ds, ax
	mov es, ax


	mov di, table_save
	mov si, table_game
	mov cx, 25
	rep movsb
x_o_game:
        xor ax, ax
        mov ds, ax
        mov es, ax

	mov di, table_game
	mov si, table_save
	mov cx, 25
	rep movsb

	mov di, log
	mov cx, 11
	xor ax, ax
	rep stosb

	mov word [index_log], 0

	mov di, who_win
	mov cx, 2
	xor ax, ax
	rep stosb

	call clear_src

	mov si, gn_1
	call sys_write

	mov si, ip_choose_1
	call sys_read

	mov al, [ip_choose_1]

	cmp al, 'p'
	je start_x_o

	cmp al, 'q'
	je back_to_menu_game_1

	mov ax, [ip_choose_1]

	cmp ax, 0x4947
	je GI_xo

	jmp x_o_game
;-----------------------------------------------------------------------------
start_x_o:
	mov word [ip_choose_1], 0x00

	call clear_src
start_game:

	mov si, p_said
	call sys_write

	mov si, ip_index
	call sys_read

	mov al, [ip_index]

	cmp al, '1'
	jl start_x_o

	cmp al, '9'
	jg start_x_o

; CHECK
	xor cx, cx
	mov di, log
loop_check_p:

	mov al, [ip_index]
	mov bl, [di]

	cmp al, bl
	jne skip
; JE
	jmp start_game
skip:
	inc di
	test bl, bl
	jnz loop_check_p

; SAVE
	mov al, [ip_index]

	mov cx, [index_log]			; get index log now

	cmp cx, 9
	je print_draw

	mov di, log

	add di, cx
	mov [di], al

	inc word [index_log]
; FIND
	xor cx, cx
	mov di, table_game

loop_find:

	mov al, [ip_index]
	mov bl, [di]

	cmp al, bl
	jne skip_find
; JE
	mov byte [di], 0
	mov byte [di], 'X'

	jmp loop_print

skip_find:
	inc di

	jmp loop_find

loop_print:

	mov si, newline
	call sys_write

	mov si, table_game
	call sys_write

	mov si, newline
	call sys_write

;------------------------------------------------------------------------------
; BOT TURN
; GET RANDOM
	mov si, b_1
	call sys_write

	mov si, newline
	call sys_write

get_random:
	rdtsc
	mov ax, dx
	xor dx, dx
	mov cx, 10
	div cx

	cmp dx, 0
	je get_random

	cmp dx, 10
	je get_random

	add dl, '0'
	mov al, dl
; CHECK LOG
	mov di, log

loop_check_b:
	mov bl, [di]

	cmp al, bl
	jne skip_b
; JE
	jmp get_random

skip_b:

	inc di
	test bl, bl
	jnz loop_check_b
; SAVE
	mov [b_index], al

	mov di, log
	mov cx, [index_log]

	add di, cx
	mov [di], al

	inc word [index_log]

; FIND
	xor cx, cx
	mov di, table_game
loop_find_b:
	mov al, [b_index]
	mov bl, [di]

	cmp al, bl
	jne skip_find_b
;JE
	mov byte [di], 0
	mov byte [di], 'O'
	jmp loop_print_1

skip_find_b:
	inc di

	jmp loop_find_b

loop_print_1:
	mov si, table_game
	call sys_write

	mov si, setr
	call sys_write

        mov cx, [index_log]
        cmp cx, 5
        jl start_game

;-----------------------------------------------------
; CHECK WIN
; CHECK LINE

	xor ax, ax
	xor bx, bx
	xor dx, dx

	mov cx, 3
	mov si, table_game

loop_check_line:
	mov al, [si]
	mov bl, [si+2]

	cmp al, bl
	jne next_line

	mov dl, [si+4]

	mov [who_win], al

	cmp al, dl
	je check_who_win
next_line:
	add si, 8

	loop loop_check_line
;------------------------------------------------------------
; CHECK COLS
        xor ax, ax
        xor bx, bx
        xor dx, dx

	mov cx, 3
        mov si, table_game

loop_check_cols:
	mov al, [si]		; cols 1

        mov bl, [si+8]		; cols 2

        cmp al, bl
        jne next_cols

        mov dl, [si+16]		; cols 3

        mov [who_win], al

        cmp al, dl
        je check_who_win

next_cols:
	add si, 2

        loop loop_check_cols

;------------------------------------------------------------------
; CHECK DIAGONAL
        xor ax, ax
        xor bx, bx
        xor dx, dx

        xor cx, cx              ; index
        mov si, table_game
check_diagonal_1:
	mov al, [si]

	mov bl, [si+10]

	cmp al, bl
	jne check_diagonal_2

	mov dl, [si+20]

	mov [who_win], al

	cmp al, dl
	je check_who_win

check_diagonal_2:

        xor ax, ax
        xor bx, bx
        xor dx, dx

        xor cx, cx              ; index
        mov si, table_game

check_diagonal_2_1:
	mov al, [si+4]

	mov bl, [si+10]

	cmp al, bl
	jne check_game

	mov dl, [si+16]

	cmp al, dl
	je check_who_win

check_game:
        jmp start_game

;--------------------------------------------------------------------------------
check_who_win:
	xor ax, ax
	mov al, [who_win]

	cmp al, 'X'
	je print_win

	cmp al, 'O'
	je print_lose
;--------------------------------------------------------------------------------

print_win:
	mov si, msg_win
	call sys_write

	jmp continue
;--------------------------------------------------------------------------------
print_lose:
        mov si, msg_lose
        call sys_write

        jmp continue
;------------------------------------------------------------------------------
print_draw:

        mov si, msg_draw
        call sys_write

        jmp continue
;------------------------------------------------------------------------------
continue:
	mov si, msg_con
	call sys_write

	xor ah, ah
	int 0x16

	cmp al, 'c'
	je x_o_game

	cmp al, 'q'
	je back_to_menu_game_1

	jmp continue















;--------------------------
GI_xo:
	call clear_src

	mov si, r1
	call sys_write

	xor ah, ah
	int 0x16

	cmp al, 'q'
	je x_o_game

	jmp GI_xo
;---------------------------
back_to_menu_game_1:
	call clear_src
	ret










; SECTION .DATA
gn_1                db "The game was developed by me and my companion (Chat Gpt), thanks OpenAI    ", 13,10
                    db "You play X_O with bot                              ", 13,10
                    db "If you want to start the game, enter 'p'           ", 13,10
                    db "You can enter 'q' to back main menu game           ", 13,10
                    db "Good luck and have fun!                            ", 13,10
                    db "Please enter 'p' to get started or enter 'GI' for playing instructions : ", 0

p_said		    db"Player play X, choose index : ", 0

b_1		    db"Bot: Now it's my turn ",13, 10
		    db"Bot: I play ", 13,10, 0


r1                  db "=== X_O GAME RULES ===", 13,10
                    db "- Two players: X and O", 13,10
                    db "- Players take turns", 13,10
                    db "- On each turn, choose a number from 1 to 9",13,10
                    db "- The board layout:",13,10
                    db "    1 | 2 | 3 | ",13,10
                    db "    4 | 5 | 6 | ",13,10
                    db "    7 | 8 | 9 | ",13,10
            	    db "- The first player to align 3 symbols", 13,10
            	    db "  horizontally, vertically, or diagonally wins",13, 10
            	    db "- If all spots are filled and no winner,",13, 10
                    db "  the game ends in a draw",13, 10

            	    db "- You can enter 'q' to quit game instrution",13,10
		    db "- Good luck and have fun ",13,10,0

table_game          db '1', '|', '2', '|', '3', '|' ,13, 10

                    db '4', '|', '5', '|', '6', '|' ,13, 10

                    db '7', '|', '8', '|', '9', '|',13, 10 ,0

msg_win 	    db "                                    <<<<YOU WIN>>>>",13, 10, 0
msg_lose	    db "                                   <<<<YOU LOSE>>>>",13, 10, 0
msg_draw	    db "                                  <<<<GAME DRAW>>>>",13, 10, 0

msg_con             db "If you want to continue playing, type 'c' ",13, 10
		    db "If you want to return to the game menu, type 'q'",13 10, 0
newline db 13,10

setr                db "================================================================================",13, 10, 0

ip_choose_1: times 3 db 0

ip_index: times 2 db 0

b_index: times 2 db 0

who_win: times 2 db 0

log: times 11 db 0

index_log: times 1 dw 0

table_save: times 25 db 0
