[BITS 16]
[GLOBAL ad_game_play]

extern sys_draw_a
extern sys_write
extern clear_src

ad_game_play:
	xor ax, ax
	mov ds, ax
	mov es, ax

	mov word [index_emeny_offset_table], 0
	mov word [index_table_emeny_char_in_map], 0

	lea di, [emeny_offset_table]
	mov cx, 10
	call delete_word

	lea di, [emeny_offset_table_info_monster]
	mov cx, 10
	call delete_word

	lea di, [table_emeny_char_in_map]
        mov cx, 10
        call delete_byte

	mov word [line], 0
	mov word [cols], 0

	lea di, [map_data]
	mov cx, 80*25
	mov al, 0x20          ; space character
	rep stosb

; SAVE ADDR STRUCT INFO
	mov si, emeny_offset_table_info_monster

	mov di, m1
	mov [si], di

	mov di, m2
	mov [si+2], di

	mov di, m3
	mov [si+4], di

	mov di, m4
	mov [si+6], di

	mov di, m5
	mov [si+8], di

	mov di, m6
	mov [si+10], di

	mov di, m7
	mov [si+12], di

	mov di, m8
	mov [si+14], di

	mov di, m9
	mov [si+16], di

ad_game_play_1:

	mov si, map_data
	mov byte [si], '@'

        mov si, map_data
        call sys_draw_a
ip:
        mov ax, [index_emeny_offset_table]

        cmp ax, 10
        je ip_next

	call spawn_emeny
ip_next:
	xor ah, ah
	int 0x16
; BACK TO MAIN
        cmp al, 'q'
        je back_to_main

; UP
        cmp ah, 48h
        je print_up
; DOWN
        cmp ah, 50h
        je print_down
; LEFT
        cmp ah, 4Bh
        je print_left
; RIGHT
        cmp ah, 4Dh
        je print_right

; PRINT INVENTORY
	cmp al, 'i'
	je inverntory

	jmp ip
print_up:
; CHECK EMENY Ở Ô KẾ TIẾP
; CACULATE OFFSET PLAYER
	mov ax, [line]
	dec ax
	imul ax, 80
	add ax, [cols]

        mov [offset_player_to_cmp], ax
        call check_emeny

        cmp dx, 1
        je pvp_emeny

; IN LÊN
; LẤY VỊ TRÍ HIỆN TẠI
	xor ax, ax
	mov ax, [line]
	xor bx, bx
	mov bx, [cols]
; I*COLS+J
	imul ax, 80
	add ax, bx
; LƯU VỊ TRÍ HIỆN TẠI
	mov si, map_data
	add si, ax
	mov cl, [si]
; LẤY VỊ TRÍ KẾ TIẾP ĐỂ CHUẨN BỊ SWAP
	xor ax, ax
	mov ax, [line]

	xor bx, bx
	mov bx, [cols]

	dec ax

	cmp ax, 0
	jl ip

	mov [line], ax			; SAVE OFFSET LINE NOW

	imul ax, 80
	add ax, bx

	mov di, map_data
	add di, ax

	xor ax, ax
	mov al, [di]
; SWAP
	mov [di], cl
	mov [si], al

        mov si, map_data
        call sys_draw_a

	jmp ip
;===============================================================================
print_down:
; CHECK EMENY Ở Ô KẾ TIẾP
; CACULATE OFFSET PLAYER
        mov ax, [line]
        inc ax
        imul ax, 80
	add ax, [cols]

        mov [offset_player_to_cmp], ax
        call check_emeny

        cmp dx, 1
        je pvp_emeny

; IN LÊN
; LẤY VỊ TRÍ HIỆN TẠI
        xor ax, ax
        mov ax, [line]
        xor bx, bx
        mov bx, [cols]
; I*COLS+J
        imul ax, 80
        add ax, bx
; LƯU VỊ TRÍ HIỆN TẠI
        mov si, map_data
        add si, ax
        mov cl, [si]
; LẤY VỊ TRÍ KẾ TIẾP ĐỂ CHUẨN BỊ SWAP
        xor ax, ax
        mov ax, [line]

        xor bx, bx
        mov bx, [cols]

        inc ax

	cmp ax, 25
	jge ip

        mov [line], ax                  ; SAVE OFFSET LINE NOW

        imul ax, 80
        add ax, bx

        mov di, map_data
        add di, ax

        xor ax, ax
        mov al, [di]
; SWAP
        mov [di], cl
        mov [si], al

        mov si, map_data
        call sys_draw_a

        call check_emeny

        cmp dx, 1
        je pvp_emeny

        jmp ip
;=========================================================
print_left:
; CHECK EMENY Ở Ô KẾ TIẾP
; CACULATE OFFSET PLAYER
        mov ax, [line]
        imul ax, 80
	add ax, [cols]
	dec ax

        mov [offset_player_to_cmp], ax
        call check_emeny

        cmp dx, 1
        je pvp_emeny

; IN LÊN
; LẤY VỊ TRÍ HIỆN TẠI
        xor ax, ax
        mov ax, [line]
        xor bx, bx
        mov bx, [cols]
; I*COLS+J
        imul ax, 80
        add ax, bx
; LƯU VỊ TRÍ HIỆN TẠI
        mov si, map_data
        add si, ax
        mov cl, [si]
; LẤY VỊ TRÍ KẾ TIẾP ĐỂ CHUẨN BỊ SWAP
        xor ax, ax
        mov ax, [line]

        xor bx, bx
        mov bx, [cols]

        dec bx

        cmp bx, 0
        jl ip

        mov [cols], bx                  ; SAVE OFFSET COLS NOW

        imul ax, 80
        add ax, bx

        mov di, map_data
        add di, ax

        xor ax, ax
        mov al, [di]
; SWAP
        mov [di], cl
        mov [si], al

        mov si, map_data
        call sys_draw_a

	call check_emeny

        cmp dx, 1
        je pvp_emeny

        jmp ip
;====================================================================
print_right:
; CHECK EMENY Ở Ô KẾ TIẾP
; CACULATE OFFSET PLAYER
        mov ax, [line]
        imul ax, 80
	add ax, [cols]
	inc ax

        mov [offset_player_to_cmp], ax
        call check_emeny

        cmp dx, 1
        je pvp_emeny

; IN RIGHT
; LẤY VỊ TRÍ HIỆN TẠI
        xor ax, ax
        mov ax, [line]
        xor bx, bx
        mov bx, [cols]
; I*COLS+J
        imul ax, 80
        add ax, bx
; LƯU VỊ TRÍ HIỆN TẠI
        mov si, map_data
        add si, ax
        mov cl, [si]
; LẤY VỊ TRÍ KẾ TIẾP ĐỂ CHUẨN BỊ SWAP
        xor ax, ax
        mov ax, [line]

        xor bx, bx
        mov bx, [cols]

        inc bx

        cmp bx, 80
        jge ip

        mov [cols], bx                  ; SAVE OFFSET COLS NOW

        imul ax, 80
        add ax, bx

        mov di, map_data
        add di, ax

        xor ax, ax
        mov al, [di]
; SWAP
        mov [di], cl
        mov [si], al

        mov si, map_data
        call sys_draw_a

	call check_emeny

	cmp dx, 1
	je pvp_emeny

	jmp ip
;==========================================================================================
pvp_emeny:

	call clear_src
	call render_skill
	call check_emeny_who_pvp
loop_pvp:
	call player_turn
; CHECK MONSTER
	mov ax, [m0]

	cmp ax, 0
	jle dead_monster

	call render_hp
	call emeny_turn
; CHECK PLAYER
	mov ax, [player_info]

	cmp ax, 0
	jle dead_player

	call render_hp

	jmp loop_pvp
;=========================================================================================
dead_monster:
; WAIT
        call clear_src

	xor bx, bx
        mov bx, 1000
        call delay

        xor di, di
        mov si, msg_win
        mov bh, 0x0F

        call sys_draw_custome
	call print_reward

	xor bx, bx
        mov bx, 3000
        call delay

	call delete_monster
	call clear_src
; HEAL HP
	mov ax, [player_info+2]
	mov [player_info], ax

	jmp ip








;================================ MODULES IN FUN DEAD MONSTER ===============================
print_reward:
; PRINT EXP
	lea si, [msg_exp]
	xor di, di
	xor di, 160
	mov bh, 0x04
	call sys_draw_custome

	lea di, [msg_reward_after_pvp+9]
	mov ax, [m0+4]

	add [player_info+6], ax				; add exp monster

	call int_to_str
	lea si, [di+1]
	xor di, di
	xor di, 200
	mov bh, 0x09
	call sys_draw_custome

; PRINT COIN

        lea si, [msg_coin]
        xor di, di
        xor di, 320
        mov bh, 0x04
        call sys_draw_custome

        lea di, [msg_reward_after_pvp+9]
        mov ax, [m0+6]

        add [player_info+4], ax                         ; add coin monster

        call int_to_str
        lea si, [di+1]
        xor di, di
        xor di, 360
        mov bh, 0x09
        call sys_draw_custome

	ret


;==========================================================================================
delete_monster:
; DELETE CHAR
	mov ax, [offset_emeny_pvp]

	cmp ax, 9			; IF IS EMENY LAST
	je skip_shift

	mov si, table_emeny_char_in_map
	add si, ax
	mov byte [si], 0
	mov bx, 9			; số lượng emeny
	sub bx, ax

loop_shift_char:
	xor dx, dx
	xchg dl, [si+1]
	xchg [si], dl
	dec bx
	inc si
        mov al, 'J'
        mov ah, 0x0E
        int 10h
	test bx, bx
	jnz loop_shift_char

skip_shift:
;DELETE OFFSET
	mov di, emeny_offset_table
        mov ax, [offset_emeny_pvp]
	imul ax, 2
	add di, ax

	mov cx, [di]
	mov si, map_data
	add si, cx
	mov byte [si], 0x20

	mov word [di], 0

	mov ax, [offset_emeny_pvp]

	cmp ax, 9
	je skip_shift_offset

	mov bx, 9			; số lượng emeny
	sub bx, ax

loop_shift_offset:
	xor dx, dx
	xchg dx, [di+2]
	xchg [di], dx
	add di, 2
	dec bx
        mov al, 'J'
        mov ah, 0x0E
        int 10h
	test bx, bx
	jnz loop_shift_offset
skip_shift_offset:
; DEC MONSTER IN MMAP
	dec word [index_emeny_offset_table]
	dec word [index_table_emeny_char_in_map]

	ret

;===========================================================================================
dead_player:
	call clear_src

	mov si, msg_lose
	call sys_write

	xor bx, bx
	mov bx, 3000
        call delay

	call clear_src

	mov ax, [player_info+2]
	mov [player_info], ax

	jmp ip












;=========================================================================================
player_turn:
; CHECK HP MONSTER
	mov ax, [m0]

	cmp ax, 0
	jle dead_monster
; LIVE
; CHOOSE SKILL
choose_skill_player:
	xor ah, ah
	int 0x16

	cmp al, '1'
	je use_skill_1

	cmp al, '2'
	je use_skill_2

	jmp choose_skill_player

use_skill_1:
	rdtsc
	xor dx, dx
	xor cx, cx
	xor cx, 6
	div cx
	mov ax, [skill_1_dmg]
	add ax, dx
	sub [m0], ax
	ret

use_skill_2:
        rdtsc
        xor dx, dx
        xor cx, cx
        xor cx, 10
        div cx
        mov ax, [skill_2_dmg]
        add ax, dx
        sub [m0], ax
	ret
;========================================================================================
render_hp:
; RENDER HP PLAYER
; RENDER INFO HP MONSTER
; DETLET
	xor di, di
	xor bh, bh
	xor di, 140
	lea si, space
	call sys_draw_custome

        lea di, [box_emeny_info_draw+7]

        mov ax, [m0]
        call int_to_str

        lea si, [di+1]
        mov bh, 0x04
        xor di, di
        xor di, 140
        call sys_draw_custome

; RENDER INFO HP PLAYER
        xor di, di
        xor bh, bh
        xor di, 40
	lea si, space
        call sys_draw_custome

        lea di, [box_player_info_draw+7]
        mov ax, [player_info]

        call int_to_str
        lea si, [di+1]

        xor di, di
        xor di, 40
        mov bh, 0x0E
        call sys_draw_custome

        ret
;========================================================================================
emeny_turn:
	rdtsc
	xor dx, dx
	xor cx, cx
	xor cx, 10
	div cx
	add dx, 31

	sub [player_info], dx

	mov ax, [player_info]

	cmp ax, 0
	jle dead_player

	ret
;=========================================================================================
check_emeny_who_pvp:
; RENDER HP && INFO
	mov si, msg_player
	mov bh, 0x0F
	xor di, di
	call sys_draw_custome

        mov si, msg_emeny
        mov bh, 0x3
        xor di, di
        xor di, 110
        call sys_draw_custome

; LOOP SCAN && CHECK

	mov al, [char_emeny_pvp]
	mov di, emeny_char

	xor cx, cx
loop_scan_and_check_emeny_pvp:
	mov bl, [di]

	cmp al, bl
	je found

	inc cx
	inc di

	jmp loop_scan_and_check_emeny_pvp
found:
; LOAD INFO EMENY FOR M0
	imul cx, 2
	mov bx, emeny_offset_table_info_monster
	add bx, cx
	mov si, [bx]
	mov di, m0
	mov cx, 4
loop_copy:
	mov ax, [si]
	mov [di], ax
	add si, 2
	add di, 2
	dec cx
	cmp cx, 0
	jne loop_copy

; RENDER INFO HP MONSTER
	lea di, [box_emeny_info_draw+7]

	mov ax, [m0]
	call int_to_str

	lea si, [di+1]
	mov bh, 0x04
	xor di, di
	xor di, 140
	call sys_draw_custome

; RENDER INFO HP PLAYER
	lea di, [box_player_info_draw+7]
	mov ax, [player_info]

	call int_to_str
	lea si, [di+1]

        xor di, di
        xor di, 40
	mov bh, 0x0E
	call sys_draw_custome

	ret
;=========================================================================================
render_skill:
; RENDER LINE
	call clear_src
	call clear_src

; RENDER LINE 20
	mov si, skill_box
	xor di, di
	xor di, 1920
	mov bh, 0x0F
	call sys_draw_custome
; RENDER LINE 30
	mov si, skill_box
	xor di, di
	xor di, 2560
        mov bh, 0x0F
	call sys_draw_custome
; RENDER LINE 40
	mov si, skill_box
	xor di, di
	xor di, 3200
        mov bh, 0x0F
	call sys_draw_custome
; RENDER LINE 48
        mov si, skill_box
        xor di, di
        xor di, 3840
        mov bh, 0x0F
        call sys_draw_custome
; BH CHOOSE COLORS
; RENDER PLAYER
	xor di, di
	xor di, 1000
	mov si, char_player
	mov bh, 0x0E
	call sys_draw_custome
; RENDER EMENY
	xor di, di
	xor di, 1080

	mov bh, 0x0A

	mov si, char_emeny_pvp
	call sys_draw_custome
; RENDER SKILL 1
	xor di, di
	xor di, 2240

	mov si, one
	mov bh, 0x09
	call sys_draw_custome

        xor di, di
        xor di, 2250

        mov si, skill_1
        mov bh, 0x09
        call sys_draw_custome
; RENDER SKILL 2
	xor di, di
	xor di, 2330

        mov si, two
        mov bh, 0x09
        call sys_draw_custome

        xor di, di
        xor di, 2340

        mov si, skill_2
        mov bh, 0x09
        call sys_draw_custome

; RENDER SKILL 3

        xor di, di
        xor di, 2880

        mov si, three
        mov bh, 0x09
        call sys_draw_custome
; RENDER SKILL 4
        xor di, di
        xor di, 2970

        mov si, four
        mov bh, 0x09
        call sys_draw_custome
; RENDER SKILL 5
        xor di, di
        xor di, 3520

        mov si, five
        mov bh, 0x09
        call sys_draw_custome
; RENDER SKILL 6
        xor di, di
        xor di, 3610

        mov si, six
        mov bh, 0x09
        call sys_draw_custome

	ret






























;=========================================================================================
check_emeny:
; CALCULATE OFFSET
	xor dx, dx
        xor cx, cx

	mov di, emeny_offset_table
loop_scan_check_emeny:
        mov bx, [di]

        cmp ax, bx
        je bit_on

        add cx, 2
        add di, 2

        cmp cx, 20
        jl loop_scan_check_emeny
	jge bit_off
bit_on:
; SAVE OFFSET EMENY
	xor dx, dx
	mov ax, cx
	mov cx, 2
	div cx
	mov [offset_emeny_pvp], ax		; save offset choose emeny PVP
	mov si, table_emeny_char_in_map
	add si, ax
	mov al, [si]
	mov [char_emeny_pvp], al
	mov byte [char_emeny_pvp+1], 0x00
; BIT ON
	mov dx, 1
bit_off:
	ret










;==========================================================================================
spawn_emeny:
; RANDOM EMENY
	rdtsc
	xor dx, dx
	xor cx, cx
	xor cx, 9
	div cx
	mov si, emeny_char
	add si, dx
	mov al, [si]

	mov si, r16b
	xchg [si], al
	mov al, [si]
; SAVE EMENY CHAR
	mov si, table_emeny_char_in_map
	mov cx, [index_table_emeny_char_in_map]
	add si, cx
	mov [si], al
	inc word [index_table_emeny_char_in_map]
;===================================
	call random_offset
	mov si, map_data
	add si, ax
	mov di, r16b
	mov bl, [di]
	mov [si], bl

	ret

;===================================
random_offset:
; RANDOM LINE
	rdtsc
	xor dx, dx
	xor cx, cx
	xor cx, 25
	div cx
	inc dx

	xchg bx, dx			; save line
; RANDOM COLS
	rdtsc
	xor dx, dx
	xor cx, cx
	xor cx, 80
	div cx
	inc dx
; CACULATE OFFSET
	xchg ax, dx			; save cols
	imul bx, 80
	add bx, ax
	mov [offset], bx

	xchg bx, ax
; CACULATE OFFSET PLAYER
	mov ax, [offset]

	mov bx, [line]
	imul bx, 80
	add bx, [cols]

	cmp ax, bx
	je random_offset
; CHECK OFFSET EMENY DIFFRENT
        mov ax, [offset]
	xor cx, cx
loop_check:
        mov di, emeny_offset_table
	add di, cx
	mov bx, [di]

	cmp ax, bx
	je random_offset

	add cx, 2
	cmp cx, 20
	jl loop_check

; SAVE OFFSET
	xor cx, cx

	mov cx, [index_emeny_offset_table]
	inc word [index_emeny_offset_table]

	mov di, emeny_offset_table

	imul cx, 2
	add di, cx

        mov ax, [offset]
	mov [di], ax

	ret

;===================================
int_to_str:
	mov byte [di], 0
	dec di
	mov byte [di], 10
	dec di
loop_int_to_str:
	xor dx, dx
	xor cx, cx
	xor cx, 10
	div cx
	add dl, '0'
	mov [di], dl
	dec di
	test ax, ax
	jnz loop_int_to_str

	ret
;===================================
sys_draw_custome:

; Ẩn con trỏ chuột (tùy chọn)
        mov ah, 0x01
        mov cx, 0x2000
        int 0x10
; DRAW
        push ds
        mov ax, 0xB800
        mov es, ax
loop_draw:
        lodsb

        cmp al, 10
        je newline

        test al, al
        jz done

	mov ah, bh
        stosw

        jmp loop_draw
done:
        pop ds
        ret


newline:
        mov ax, di
        mov cx, 160
        xor dx, dx
        div cx
        inc al
        xor ah, ah
        mov di, ax
        mul cx
        mov di, ax
        jmp loop_draw
;===================================================
; WAIT
delay:
outer_loop_wait:
        xor cx, cx
        mov cx, 65000

wait_inner_loop:
        dec cx

        test cx, cx
        jnz wait_inner_loop

        dec bx

        test bx, bx
        jnz outer_loop_wait
	ret


;========================================================
inverntory:
	call render_inverntory

	lea si, map_data
	call sys_draw_a

	jmp ip

render_inverntory:
	call clear_src
; RENDER INFO
	lea si, [msg_player_info_hp_1]
	xor di, di
	mov bh, 0x06
	call sys_draw_custome

        lea si, [msg_player_exp_1]
        xor di, di
	xor di, 160
        mov bh, 0x06
        call sys_draw_custome

        lea si, [msg_player_level_1]
        xor di, di
	xor di, 320
        mov bh, 0x06
        call sys_draw_custome

        lea si, [msg_player_coin_1]
        xor di, di
	xor di, 480
        mov bh, 0x06
        call sys_draw_custome

        lea si, [msg_player_skill_box_1]
        xor di, di
	xor di, 640
        mov bh, 0x06
        call sys_draw_custome

        lea si, [msg_player_skill_now_1]
        xor di, di
	xor di, 800
        mov bh, 0x06
        call sys_draw_custome
;====================================================================
; PRINT HP
	mov ax, [player_info+2]

	lea di, [msg_info_player+9]
	call int_to_str
	lea si, [di+1]
	xor di, di
	xor di, 60
	mov bh, 0x06
	call sys_draw_custome
; PRINT EXP
        mov ax, [player_info+6]

        lea di, [msg_info_player+9]
        call int_to_str
        lea si, [di+1]
        xor di, di
        xor di, 220
        mov bh, 0x06
        call sys_draw_custome
; PRINT LEVEL
        mov ax, [player_info+8]

        lea di, [msg_info_player+9]
        call int_to_str
        lea si, [di+1]
        xor di, di
        xor di, 380
        mov bh, 0x06
        call sys_draw_custome
; PRINT COIN
        mov ax, [player_info+4]

        lea di, [msg_info_player+9]
        call int_to_str
        lea si, [di+1]
        xor di, di
        xor di, 540
        mov bh, 0x06
        call sys_draw_custome
; PRINT BOX
        mov ax, [player_info+10]

        lea di, [msg_info_player+9]
        call int_to_str
        lea si, [di+1]
        xor di, di
        xor di, 700
        mov bh, 0x06
        call sys_draw_custome
; PRINT SKILL
        mov ax, [player_info+12]

        lea di, [msg_info_player+9]
        call int_to_str
        lea si, [di+1]
        xor di, di
        xor di, 860
        mov bh, 0x06
        call sys_draw_custome

back_to_map:
	xor ah, ah
	int 0x16
	cmp al, 'q'
	jne back_to_map
	ret

;===========================================================
delete_word:
	xor ax, ax
	mov [di], ax
	add di, 2
	dec cx
	test cx, cx
	jnz delete_word
	ret

;==========================================================
delete_byte:
        xor ax, ax
        mov [di], al
        inc di
        dec cx
        test cx, cx
        jnz delete_byte
	ret

;===========================================================
back_to_main:
	call clear_src
	mov word [line], 0
	mov word [cols], 0
	mov word [index_emeny_offset_table], 0
	mov word [index_table_emeny_char_in_map], 0
	ret



; SECTION .DATA
map_data        		db 80*25 dup(0x20)     ; full 80x25 space tile map
                		db 0

emeny_char			db "!#$%^&*~'",0
;=========================================================
; DRAW BOX AREA && SKILL

skill_box				db "================================================================================",10,0
char_player				db "@",0

msg_emeny				db "EMENY HP : ",0
msg_player				db "PLAYER HP : ",0

msg_player_exp				db "PLAYER EXP : ",0
msg_player_coin				db "PLAYER COIN : ",0

specail_1				db "/",0


msg_debug				db "debug",0

msg_win					db "<<<[ YOU WIN ]>>>",0
msg_lose				db "<<<[ YOU LOSE ]>>>",0

msg_exp					db "EXP YOU GET : ",0
msg_coin				db "COIN YOU GET : ",0


one					db "[1].",0
two					db "[2].",0
three					db "[3].",0
four					db "[4].",0
five					db "[5].",0
six					db "[6].",0

space					db 0x20,0x20,0x20,0x20,0x20,0x20,0




;=========================================================
; PLAYER_INFO
msg_player_info_hp_1				db "HP PLAYER NOW            : ",0
msg_player_exp_1				db "EXP PLAYER HAS NOW       : ",0
msg_player_level_1				db "LEVEL PLAYER HAS NOW     : ",0
msg_player_coin_1				db "COIN PLAYER HAS NOW      : ",0
msg_player_skill_box_1				db "SKILL BOX PLAYER HAS NOW : ",0
msg_player_skill_now_1				db "SKILLS PLAYER HAS NOW    : ",0












skill_1					db "SLASH A SWORD",0
skill_2					db "PIERCING STRIKE",0
skill_3					db "",0
skill_4					db "",0
skill_5					db "",0
skill_6					db "",0

skill_1_dmg:				dw 20
skill_2_dmg:				dw 20

;=========================================================
msg_reward_after_pvp:			times 10 db 0

msg_info_player:			times 10 db 0

line: 					times 1 dw 0
cols: 					times 1 dw 0

box_emeny_info_draw:			times 8 db 0
box_player_info_draw:			times 8 db 0

emeny_offset_table:			times 10 dw 0

emeny_offset_table_info_monster:	times 10 dw 0		; save addr info monster

table_emeny_char_in_map:		times 10 db 0		; save char emeny random
index_table_emeny_char_in_map:		times 1 dw 0		; lưu offset
enemy_count:				times 1 dw 0		; số lượng kẻ thù trên map

index_emeny_offset_table:		times 1 dw 0
offset:					times 1 dw 0
offset_player_to_cmp:			times 1 dw 0

char_emeny_pvp:				times 2 db 0		; save char
offset_emeny_pvp:			times 1 dw 0		; save offset pvp

ex:					times 1 dw 0

r16b:					times 1 db 0


player_info:
	dw 200				; hp now
	dw 200				; hp
	dw 0				; coin now
	dw 0				; exp
	dw 0				; level
	dw 2				; skill now
	dw 1				; Ô hiện có chứa skill

; MONSTER INFO
m0:	times 5 dw 0			; copy struct info con quái pvp vô m0


m1:
	dw 150				; hp now
	dw 150				; hp
	dw 2				; coin
	dw 10				; exp
m2:
        dw 50                   	; hp now
        dw 50                   	; hp
        dw 2                    	; coin
        dw 10                   	; exp
m3:
        dw 50                   	; hp now
        dw 50                   	; hp
        dw 2                    	; coin
        dw 10                   	; exp
m4:
        dw 50                   	; hp now
        dw 50                   	; hp
        dw 2                    	; coin
        dw 10                   	; exp
m5:
        dw 50                   	; hp now
        dw 50                   	; hp
        dw 2                    	; coin
        dw 10                   	; exp
m6:
        dw 50                   	; hp now
        dw 50                   	; hp
        dw 2                    	; coin
        dw 10                   	; exp
m7:
        dw 50                   	; hp now
        dw 50                   	; hp
        dw 2                    	; coin
        dw 10                   	; exp
m8:
        dw 50                   	; hp now
        dw 50                   	; hp
        dw 2                    	; coin
        dw 10                   	; exp
m9:
        dw 50                   	; hp now
        dw 50                   	; hp
        dw 2                    	; coin
        dw 10                   	; exp

