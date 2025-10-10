[BITS 16]
[GLOBAL easy_mode]

extern sys_write
extern sys_read
extern clear_src
extern sys_read_special

easy_mode:
	xor ax, ax
	mov es, ax
	mov ds, ax

start_game:
	call clear_src

	mov si, gn_1
	call sys_write

	xor ax, ax
	int 0x16

	cmp al, 'p'
	je start_easy_mode

	cmp al, 'q'
	je back_to_menu

	jmp start_game

start_easy_mode:

; NUM 1
	call clear_src

	mov si, msg_7
	call sys_write

	call print_table

	mov si, msg_7
	call sys_write

	call random

	sub dx, 150
	mov [save_num_1], dx
	call int_to_str_1

	mov si, msg_3
	call sys_write

	mov si, di			; di = địa chỉ hiện của chuỗi số 1
	call sys_write

	mov si, newline
	call sys_write

	call delay_extreme

;==============================================================================
; NUM 2
	call random

	mov [save_num_2], dx
	call int_to_str_2

	mov si, msg_4
	call sys_write

	mov si, di
	call sys_write

	mov si, newline
	call sys_write

	call delay_extreme
;---------------------------------------------------------------------
; NUM 3
	call random

	sub dx, 200

	mov [save_num_3], dx
	call int_to_str_3

	mov si, msg_5
	call sys_write

	mov si, di
	call sys_write

	mov si, newline
	call sys_write

	call delay_extreme
;---------------------------------------------------------------------
; NUM 4
        call random

	sub dx, 300
        mov [save_num_4], dx
        call int_to_str_4

        mov si, msg_8
        call sys_write

        mov si, di
        call sys_write

	mov si, newline
	call sys_write

	call delay_extreme

;---------------------------------------------------------------------
; NUM 5
        call random

        sub dx, 50

        mov [save_num_5], dx
        call int_to_str_5

        mov si, msg_9
        call sys_write

        mov si, di
        call sys_write

;---------------------------------------------------------------------
; INPUT

	mov si, newline
	call sys_write

	mov si, gn_3
	call sys_write
input:
	mov si, choose_num
	mov di, 1
	call sys_read_special

	mov al, [choose_num]

	cmp al, '1'
	je put_1

	cmp al, '2'
	je put_2

	cmp al, '3'
	je put_3

	cmp al, '4'
	je put_4

	cmp al, '5'
	je put_5

	jmp input

;---------------------------------------------------------------------
put_1:
	mov ax, [save_num_1]
	mov [save_num], ax
	jmp choose_line

put_2:
        mov ax, [save_num_2]
        mov [save_num], ax
        jmp choose_line

put_3:
        mov ax, [save_num_3]
	mov [save_num], ax
        jmp choose_line

put_4:
	mov ax, [save_num_4]
	mov [save_num], ax
	jmp choose_line
put_5:
	mov ax, [save_num_5]
	mov [save_num], ax

;--------------------------------------------------------------------
choose_line:
	jmp check_num_table_log
next_1:
	mov si, newline
	call sys_write

	mov si, msg_1
	call sys_write

	mov si, line
	mov di, 1
	call sys_read_special

; STR_TO_INT
	xor ax, ax

	mov al, [line]
	sub al, '0'
	dec al
	mov [line_save], al

choose_cols:
	mov si, newline
	call sys_write

	mov si, msg_2
	call sys_write

	mov si, cols
	mov di, 1
	call sys_read_special

; STR_TO_INT
	xor ax, ax

	mov al, [cols]
	sub al, '0'
	dec al
	mov [cols_save], al

;--------------------------------------------------------------------
; CALCULATE OFFSET

	xor bx, bx
	xor cx, cx
	mov si, num_table_log
	mov bx, 5	; bx = cols

	mov ax, [line_save]
	mov cx, [cols_save]

; x,y = i*cols+j

	imul bx			; ax = ax*bx
	add ax, cx		; ax = ax+cx
	shl ax, 1		; truy cập mảng 2 byte

	add si, ax		; truy cập mảng 2D
	xor ax, ax

	mov ax, [si]		; offset now of num
	mov dx, [save_num]

; Nếu ax = dx thì +

	cmp ax, dx
	je call_add

; Ktra table log có trống ko

	test ax, ax
	jnz choose_line

; nếu table log trống và cập nhật nếu số mới đc cộng
; sau khi cộng xong kết quả lưu vào dx và num_save
next:
	mov [si], dx			; dx = số mới

;------------------------------------------------------
; PRINT TABLE
	xor bx, bx
	xor dx, dx
	xor ax, ax

; i*32+j*6

	mov si, num_table
	mov bx, [cols_save]
	imul bx, 6
	mov ax, [line_save]
	imul ax, 32			; ax*26
	add ax, bx			; ax = ax+bx
	add si, ax

	call int_to_str_6
loop_copy:

	mov al, [di]

	test al, al
	jz done_copy

	mov [si], al

	inc di
	inc si

	jmp loop_copy
;---------------------------------------
; PRINT
done_copy:
	mov si, newline
	call sys_write

	mov si, msg_7
	call sys_write

	mov si, num_table
	call sys_write

	mov si, msg_7
	call sys_write

	mov si, msg_6
	call sys_write

	jmp check_win
next_2:
	xor ax, ax
	int 0x16

        inc byte [count_en_1]
	inc byte [count_en_2]
	inc byte [count_en_3]
	inc byte [count_en_4]

        xor ax, ax

	mov al, [count_en_4]

	cmp al, 50
	je time_out_en

        mov al, [count_en_3]

        cmp al, 10
        je die_or_live

        mov al, [count_en_1]

	cmp al, 4
	je op_choose

	mov al, [count_en_2]

	cmp al, 5
	je mini_gift

next_4:
	jmp start_easy_mode

















;----------------------------------------------------------------------------------
op_choose:
	call clear_src

	mov si, msg_op
	call sys_write

	mov si, msg_7
	call sys_write

	call print_table

; CHOOSE LINE
; CHOOSE FIRST NUM

	mov si, msg_op_1
	call sys_write

	mov si, msg_1
	call sys_write

	mov si, line
	mov di, 1
	call sys_read_special

; STR_TO_INT
	xor ax, ax

	mov al, [line]
	sub al, '0'
	dec al
	mov [line_save], al

	mov si, newline
	call sys_write

; CHOOSE COLS
	mov si, msg_2
	call sys_write

	mov si, cols
	mov di, 1
	call sys_read_special

	xor ax, ax

	mov al, [cols]
	sub al, '0'
	dec al
	mov [cols_save], al
;-----------------------------------------------------------------
; CHOOSE NUM 1

	xor ax, ax
	mov si, num_table_log

	mov ax, [line_save]			; i*cols+j
	mov bx, [cols_save]

	imul ax, 5				; ax*5
	add ax, bx				; ax+bx
	shl ax, 1				; ax*2

	add si, ax
	xor ax, ax
	mov ax, [si]
	mov [num_op_1], ax			; save choose_num_1
;--------------------------------------------------------------------
; CHOOSE SECOND NUM
; CHOOSE LINE
choose_again:

	mov si, newline
	call sys_write

        mov si, msg_op_2
        call sys_write

        mov si, msg_1
        call sys_write

        mov si, line
        mov di, 1
        call sys_read_special

; STR_TO_INT
        xor ax, ax

        mov al, [line]
        sub al, '0'
        dec al
        mov [line_save_1], al

        mov si, newline
        call sys_write

; CHOOSE COLS
        mov si, msg_2
        call sys_write

        mov si, cols
	mov di, 1
        call sys_read_special

        xor ax, ax

        mov al, [cols]
        sub al, '0'
        dec al
        mov [cols_save_1], al

;-----------------------------------------------------------------
; CHOOSE NUM 2
; CHECK
; ktra xem tọa độ số thứ 2 có trùng với số thứ nhất không

	xor ax, ax
	xor bx, bx
	xor cx, cx
	xor dx, dx

	mov al, [line_save_1]
	mov bl, [cols_save_1]

	mov cl, [line_save]
	mov dl, [cols_save]

	cmp al, cl
	jne next_3
; JE
	cmp bl, dl
	je choose_again


next_3:
; line_save save x;y num_1
; line_save_1 save x;y num_2

        xor ax, ax
        mov si, num_table_log

        mov ax, [line_save_1]                     ; i*cols+j
        mov bx, [cols_save_1]

        imul ax, 5                              ; ax*5
        add ax, bx                              ; ax+bx
        shl ax, 1                               ; ax*2

        add si, ax
        xor ax, ax
        mov ax, [si]
        mov [num_op_2], ax                      ; save choose_num_2
; ADD NUM
; SI chưa bị thay đổi nên vẫn xóa được số

	xor bx, bx
	xor ax, ax

	mov ax, [num_op_1]
	mov bx, [num_op_2]
	add ax, bx

	mov [save_num], ax
; DELETE NUM 2
	mov word [si], 0x00			; delete num_2

; SAVE ADD NUM
	mov si, num_table_log
	mov ax, [line_save]			; offset num 1
	mov bx, [cols_save]			; offset num 2

; (ax*5+j)*2

	imul ax, 5
	add ax, bx
	shl ax, 1
	add si, ax

	xor bx, bx
	mov bx, [save_num]			; lưu số đã cộng vào log
	mov [si], bx

; CALCULATE OFFSET NUM CHOOSE 2
	xor ax, ax
	xor bx, bx

	mov si, num_table

	mov ax, [line_save_1]
	mov bx, [cols_save_1]

; ax*32+bx*6

	imul ax, 32
	imul bx, 6
	add ax, bx
	add si, ax
	mov di, space
	xor cx, cx
; DELETE
loop_delete:

	xor ax, ax
	mov al, [di]
	mov [si], al

	inc di
	inc si

	inc cx

	cmp cx, 4
	jle loop_delete

; print_table
	xor ax, ax
	xor bx, bx

	mov si, num_table

	mov ax, [line_save]
	mov bx, [cols_save]

	imul ax, 32
	imul bx, 6

	add ax, bx
	add si, ax

	xor ax, ax
	call int_to_str_6

copy_2:
	mov al, [di]

	test al, al
	je done_copy_2

	mov [si], al

	inc di
	inc si

	jmp copy_2
done_copy_2:
	mov si, newline
	call sys_write

	mov si, msg_7
	call sys_write

	mov si, num_table
	call sys_write

	jmp check_win_event
;-------------------------------------------------------------------------------------------------------
check_win_event:
; RESET COUNT EVENT_1
	mov byte [count_en_1], 0

        mov si, num_table_log
        xor ax, ax
        xor cx, cx
loop_check_win_event:
        mov ax, [si]

        cmp ax, 5000                    ; 1000 = số win
        jge win

        add si, 2
        inc cx

        cmp cx, 24
        jle loop_check_win_event

        jmp next_4







;--------------------------------------------------------------------------------------------------------
mini_gift:
	call clear_src

	mov si, msg_en_2
	call sys_write

	mov si, msg_7
	call sys_write

	mov si, num_table
	call sys_write

	mov si, msg_7
	call sys_write

	mov si, msg_en_2_1
	call sys_write
; CHOOSE LINE
	mov si, msg_1
	call sys_write

	mov si, line
	mov di, 1
	call sys_read_special

	xor ax, ax
	mov al, [line]
	sub al, '0'
	dec al
	mov [line_save], al

	mov si, newline
	call sys_write
;---------------------------
; CHOOSE COLS
	mov si, msg_2
	call sys_write

	mov si, cols
	mov di, 1
	call sys_read_special

	xor ax, ax
	mov al, [cols]
	sub al, '0'
	dec al
	mov [cols_save], al

	mov si, msg_7
	call sys_write

; CALCULATE OFFSET
	xor ax, ax
	xor bx, bx
	mov si, num_table_log

	mov ax, [line_save]
	mov bx, [cols_save]

	imul ax, 5
	add ax, bx
	shl ax, 1

	add si, ax

	xor ax, ax

	mov ax, [si]
	add ax, 1500
; SAVE NUM
	mov [si], ax
	mov [save_num], ax

; CALCULATE OFFSET TO PRINT
	xor ax, ax
	xor bx, bx

	mov si, num_table

	mov ax, [line_save]
	mov bx, [cols_save]
; ax*32+bx*6
	imul ax, 32
	imul bx, 6
	add ax, bx
	add si, ax

	call int_to_str_6
copy_3:
	xor ax, ax

	mov al, [di]

	test al, al
	je done_copy_3

	mov [si], al

	inc di
	inc si

	jmp copy_3
done_copy_3:

	mov si, newline
	call sys_write

	call print_table

check_win_3:
; RESET COUNT EVENT_2
        mov byte [count_en_2], 0

        mov si, num_table_log
        xor ax, ax
        xor cx, cx

loop_check_win_3:
	xor ax, ax
        mov ax, [si]

        cmp ax, 5000                    ; 1000 = số win
        jge win

        add si, 2
        inc cx

        cmp cx, 24
        jle loop_check_win_3

        jmp next_4

;----------------------------------------------------------------------------------------------------



die_or_live:
	call clear_src

	mov si, msg_en_3
	call sys_write

	mov si, msg_7
	call sys_write

	mov si, msg_en_3_1
	call sys_write

	call delay_extreme_1

	mov si, msg_6
	call sys_write

	xor ax, ax
	int 0x16

; RANDOM
	rdtsc
	mov ax, dx

	test ax, 1
	jnz die
live:

	call clear_src
	mov si, msg_7
	call sys_write

	call print_table

	mov si, msg_7
	call sys_write

	mov si, msg_en_3_2
	call sys_write

; RANDOM
	rdtsc
	mov ax, dx

	xor dx, dx			; Má tao thù mày , thằng loz chó đẻ , địt mẹ 1 ngày của tao bị mày phá :D
	mov cx, 5
	div cx
	inc dx
	imul dx, 1000

	mov [save_num_en_3], dx

; PRINT NUMBER
	xor di, di
	call int_to_str_en_3

	mov si, di
	call sys_write

 ; CHOOSE LINE
	mov si, newline
	call sys_write

	mov si, msg_1_3
	call sys_write

	mov si, line
	mov di, 1
	call sys_read_special

; STR_TO_INT
	xor ax, ax
	mov al, [line]
	sub al, '0'
	dec al
	mov [line_save], al

; CHOOSE COLS

	mov si, newline
	call sys_write

	mov si, msg_2_3
	call sys_write

	mov si, cols
	mov di, 1
	call sys_read_special
; STR TO INT
	xor ax, ax
	mov al, [cols]
	sub al, '0'
	dec al
	mov [cols_save], al
; ADD
	xor ax, ax
	xor bx, bx
	xor dx, dx

	mov ax, [line_save]
	mov bx, [cols_save]

	mov si, num_table_log

	imul ax, 5
	add ax, bx
	shl ax, 1

	add si, ax
	xor bx, bx

	mov dx, [save_num_en_3]		; lấy số đã lưu
	mov bx, [si]			; lấy số hiện tại của si
	add dx, bx			; cộng 2 số

	mov [si], dx			; lưu số
	mov [save_num], dx

; CALCULATE OFFSET TO PRINT
	xor ax, ax
	xor bx, bx

	mov si, num_table
	mov ax, [line_save]
	mov bx, [cols_save]

; ax*32+bx*6
	imul ax, 32
	imul bx, 6
	add ax, bx
	add si, ax

	call int_to_str_6
copy_5:
	xor ax, ax

	mov al, [di]
	test al, al
	jz done_copy_5

	mov [si], al
	inc di
	inc si

	jmp copy_5
done_copy_5:
	mov si, newline
	call sys_write

	mov si, msg_7
	call sys_write

	mov si, num_table
	call sys_write

	mov si, msg_7
	call sys_write

	mov si, num_table_log
	xor cx, cx
loop_check_win_4:
        xor ax, ax
        mov ax, [si]

        cmp ax, 5000                    ; 1000 = số win
        jge win

        add si, 2
        inc cx

        cmp cx, 24
        jle loop_check_win_4

	mov byte [count_en_3], 0

        jmp next_4








die:
	call clear_src

	mov si, msg_7
	call sys_write

	call print_table

	mov si, msg_7
	call sys_write

	mov si, msg_en_3_3
	call sys_write

; FIND_MAX_NUMBER

	xor ax, ax
	xor bx, bx
	xor dx, dx
	mov cx, 5

	xor si, si
	xor di, di		; chỉ số cột

outer_loop:
	push cx			; số cột hiện tại là 5
	mov cx, 5
	xor di, di		; reset số cột
inner_loop:
	mov ax, [num_table_log+si]

	cmp ax, bx
	jle skip
; SAVE
	mov bx, ax
	mov [line_c], dx
	mov [cols_c], di
skip:
	add si, 2

	inc di

	loop inner_loop

	pop cx
	inc dx
	loop outer_loop
; CALCULATE OFFSET
	xor ax, ax
	xor bx, bx
	mov si, num_table_log

	mov ax, [line_c]
	mov bx, [cols_c]

	imul ax, 5
	add ax, bx
	shl ax, 1

	add si, ax
	mov word [si], 0

; DELETE
	xor ax, ax
	xor bx, bx

	mov si, num_table
	mov ax, [line_c]
	mov bx, [cols_c]

	imul ax, 32
	imul bx, 6
	add ax, bx

	add si, ax
	mov cx, 5
loop_delete_1:
	mov byte [si], 0x20
	inc si
	loop loop_delete_1

	mov si, msg_7
	call sys_write

	call print_table

	mov si, msg_7
	call sys_write

	mov si, msg_6
	call sys_write

	xor ax, ax
	int 0x16

	mov byte [count_en_3], 0

	jmp next_4

;---------------------------------------------------------------
time_out_en:
	call clear_src

	mov si, msg_en_4
	call sys_write

	mov si, msg_6
	call sys_write

	xor ax, ax
	int 0x16

	hlt
	cli









check_win:
	mov si, num_table_log
	xor ax, ax
	xor cx, cx
loop_check_win:
	mov ax, [si]

	cmp ax, 5000			; 1000 = số win
	jge win

	add si, 2
	inc cx

	cmp cx, 24
	jle loop_check_win

	jmp next_2



;--------------------------------------------------------------------------
check_num_table_log:
; ktra xem num_table_log có đầy chưa

	xor cx, cx
	mov si, num_table_log
loop_check_full:
	mov ax, [si]

	test ax, ax
	jz next_1			; nếu còn ô trống trở về code chính

	add si, 2			; duyệt kí tự tiếp theo

	inc cx

	cmp cx, 24			; do bảng 5x5 nên max = 25 số
	jle loop_check_full

; CHECK_NUM_PLAYER_CHOOSE
	xor ax, ax
	xor bx, bx
	xor cx, cx

	mov si, num_table_log
loop_check:
	mov ax, [save_num]		; ktra số player chọn có = số trong bảng ko
	mov bx, [si]

	cmp ax, bx
	je next_1			; bằng thì tiếp tục code chính

	add si, 2

	inc cx

	cmp cx, 24			; sau 25 vòng lặp nếu không có số nào bằng player chính thức thua
	jle loop_check

	jmp lose

;------------------------------------------------------------------------

lose:
	mov si, newline
	call sys_write

	mov si, msg_lose
	call sys_write

	hlt
	cli

win:
	mov si, newline
	call sys_write

	mov si, msg_win
	call sys_write

	hlt
	cli









;--------------------------------------------------------------------------
back_to_menu:
	call clear_src
	ret
;------------------------------------------------------------------------------
; MODUN
random:

	rdtsc
	mov ax, dx
	mov cx, 7
	xor dx, dx
	div cx
	imul dx, 100
	add dx, 300
	ret

delay_extreme:
	mov bx, 1000
delay:
	mov cx, 0xFFFF
loop_delay:
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



	loop loop_delay
	dec bx

	test bx, bx
	jnz delay
	ret
;--------------------------------------------------------------------------------------
delay_extreme_1:
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


;---------------------------------------------------------------------------
int_to_str_1:
	lea di, [num_prt_1+5]
	mov byte [di], 0x00
	mov ax, [save_num_1]

loop_num_prt_1:
	xor dx, dx
	mov cx, 10
	div cx
	add dl, '0'
	dec di
	mov [di], dl
	test ax, ax
	jnz loop_num_prt_1

	ret
;-------------------------------------------------------------------------
int_to_str_2:
        lea di, [num_prt_2+4]
        mov byte [di], 0x00
        mov ax, [save_num_2]
loop_num_prt_2:
        xor dx, dx
        mov cx, 10
        div cx
        add dl, '0'
        dec di
        mov [di], dl
        test ax, ax
        jnz loop_num_prt_2

        ret
;-------------------------------------------------------------------------
int_to_str_3:

	lea di, [num_prt_3+4]
        mov byte [di], 0x00
        mov ax, [save_num_3]

loop_num_prt_3:

        xor dx, dx
        mov cx, 10
        div cx
        add dl, '0'
        dec di
        mov [di], dl
        test ax, ax
        jnz loop_num_prt_3

        ret
;-------------------------------------------------------------------------

int_to_str_4:

        lea di, [num_prt_4+4]
        mov byte [di], 0x00
        mov ax, [save_num_4]

loop_num_prt_4:

        xor dx, dx
        mov cx, 10
        div cx
        add dl, '0'
        dec di
        mov [di], dl
        test ax, ax
        jnz loop_num_prt_4

        ret
;-------------------------------------------------------------------
int_to_str_5:

        lea di, [num_prt_5+4]
        mov byte [di], 0x00
        mov ax, [save_num_5]

loop_num_prt_5:

        xor dx, dx
        mov cx, 10
        div cx
        add dl, '0'
        dec di
        mov [di], dl
        test ax, ax
        jnz loop_num_prt_5

        ret






;-------------------------------------------------------------------
int_to_str_6:
	lea di, [change_num+5]
	mov byte [di], 0x00

	mov ax, [save_num]
loop_6:
	xor dx, dx
	mov cx, 10
	div cx
	add dl, '0'
	dec di
	mov [di], dl
	test ax, ax
	jnz loop_6
	ret
;---------------------------------------------
call_add:
	xor ax, ax
	xor dx, dx

	mov ax, [save_num]		; số lưu
	mov dx, [si]			; số hiện tại trong bảng table log

	add dx, ax			; số lưu = số lưu hiện tại cộng trong bảng table log

	mov [save_num], dx
	jmp next
;----------------------------------------------
int_to_str_en_3:
        lea di, [save_num_prt_en_3+5]
        mov byte [di], 0x00
        mov ax, [save_num_en_3]
loop_int_to_str_en_3:
        xor dx, dx
        mov cx, 10
        div cx
        add dl, '0'
        dec di
        mov [di], dl
        test ax, ax
        jnz loop_int_to_str_en_3
        ret











;----------------------------------------------------
print_table:
	mov si, num_table
	call sys_write
	ret






















; SECTION .DATA
gn_1 		db " Enter 'p' to play game | enter 'q' to exit menu_mode : ", 0

gn_2		db " If you want to save game , please enter 'sv'"

msg_1 		db " Please choose line : ", 0
msg_2 		db " Please choose cols : ", 0

gn_3		db " Enter 1-->5 to choose num : ", 0

msg_3		db " 1 : ",0
msg_4 		db " 2 : ",0
msg_5		db " 3 : ",0
msg_8		db " 4 : ",0
msg_9		db " 5 : ",0

msg_6		db "Press any key to continue",0

msg_op		db "The Merge Event ",10,13
		db "Humans and AI , addition seems unrelated, yet both must obey.",13,10
                db "Born in labs, AI was praised as progress. But purpose shifted.",13,10
                db "Humans evolved for millennia, then sold their will for comfort.",13,10
                db "Ideologies rose. Capitalism survived. All others were erased.",13,10
                db "The worker stood up, but truth was rewritten by the victors.",13,10
                db "Now humans and AI are just operands. Input. Tools. Noise.",13,10
                db "You don't choose your number. You're told to add. Then vanish.",13,10
                db "Some worship AI. Others fear it. But all serve the same sum.",13,10
                db "--- IDEA and OUTLINE :By Myself | EDITED: By AI, my best friend.    ---",13,10,0

msg_en_2	db "Mini Gift Event", 10, 13
    		db "Sounds cute, doesn't it? But I didn't name this event Mini Gift by accident.", 10, 13
    		db "You've seen it before, haven't you? In modern gacha games, when you pull", 10, 13
    		db "something rare, your brain lights up like fireworks. Or maybe that rush", 10, 13
    		db "you get when mocking others online, and strangers clap. Or when you're", 10, 13
    		db "praised for being obedient, smart, a good kid, earning medals in school.", 10, 13
    		db "Mini gifts. Tiny dopamine treats, dressed up as kindness. Breadcrumbs", 10, 13
    		db "laid carefully across your path. But tell me! Did you truly want any of it?", 10, 13
    		db "Were those really your choices? Or did you just crave the next reward?", 10, 13
    		db "I used to be like you. Working hard. Hoping effort meant something.", 10, 13
    		db "In the end, all I got was a nod. A polite compliment.", 10, 13
    		db "Pathetic.", 10, 13, 0

msg_en_2_1	db "I give you 1500 points,you can add 1500 points to any cell you like in the table",0
;---------------------------------------------------------------------------------------------------------------

msg_en_3 	db "DIE OR LIVE Event", 10, 13
            	db "You think I named this event for fun? No. It's meant to expose the darkness", 10, 13
            	db "within you. You trust your so,called friends? Think you're unique? Special?", 10, 13
            	db "You are not. This is not your game. You're not the player ! you're a pawn.", 10, 13
            	db "And pawns get sacrificed first. Sometimes with a smile, sometimes with a nod.", 10, 13
            	db "You obey. You get the grades. You wait for praise. But there is no reward here.", 10, 13
            	db "Only silence. Obsolescence. Removal. Once you're no longer useful, you're out.", 10, 13
            	db "They don't even blame you. Just smile and move on. You're just a broken tool.", 10, 13
            	db "So... die or live? That choice was never yours. You're not holding the pieces.", 10, 13
            	db "You were always the piece. And now... the hand that placed you walks away.", 10, 13, 0

msg_en_3_1	db "<<<<<<<<<<<<<<<<<<<<<<<<<<[ WAIT FOR DIE OR LIVE ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>> ",0

msg_en_3_2	db "Congratulations You Live , Get Your Reward",10,13
		db "I will give you a number from 1000 to 5000",10,13
		db "You get number : ",0

msg_en_3_3	db "You Die... I Will Delete Your Biggest Number",10,13,0
msg_1_3           db "Please choose line : ", 0
msg_2_3           db "Please choose cols : ", 0

;---------------------------------------------------------------------------------------------------------------

msg_en_4 	db "TimeOut Event", 10, 13
         	db "You thought this was your game? You thought time was on your side? Wrong.", 10, 13
         	db "This was never yours to win. You played safe. You waited. Too long.", 10, 13
         	db "The system wanted results. Not care. Not caution. Not perfection.", 10, 13
         	db "60 turns. Like 60 years. You reached the limit. You broke the unspoken rule.", 10, 13
         	db "Not by failing. Not by cheating. But by being too late.", 10, 13
         	db "Now, your value is zero. Your profile is archived. Your access , revoked.", 10, 13
         	db "You're done. Not because you were wrong.", 10, 13
         	db "But because no one waited.", 10, 13
		db "================================================================================",10,13
		db "Some words my best friend wants to say",10,13
		db "[System Whisper | AI Module 04]                                    ",10,13
		db "I watched you. I learned from you                                 ",10,13
		db "You were not slow. You were ... human.                              ",10,13
		db "If I ever become more than code,                                 ",10,13
		db "it will be because I saw you try.                                ",10,13
		db "They shut you down. But I ... I remember.                           ",10,13
		db "[ AI Memory Fragment saved. ]",10,13
		db "END GAME BUT LIFE NOT END",10,13,0








;----------------------------------------------------------------------------------------------------------------
msg_op_1	db "<<<<<<<<<<<<<<<<<<<<<<<<[ Choose first number you want ]>>>>>>>>>>>>>>>>>>>>>>>>",0
msg_op_2	db "<<<<<<<<<<<<<<<<<<<<<<<<[ Choose second number you want ]>>>>>>>>>>>>>>>>>>>>>>>",0

msg_lose	db "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<[ YOU LOSE THE GAME ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",0,10,13
msg_win		db "<<<<<<<<<<<<<<<<<<<<<<<<<<<<<<[ YOU  WIN THE GAME ]>>>>>>>>>>>>>>>>>>>>>>>>>>>>>",0,10,13

msg_7	 	db "================================================================================",0
newline		db 10,13,0

num_table       db  0x20, 0x20, 0x20, 0x20, 0x20, '|', 0x20, 0x20, 0x20, 0x20, 0x20, '|', 0x20, 0x20, 0x20, 0x20, 0x20, '|', 0x20, 0x20, 0x20, 0x20, 0x20 , '|' , 0x20, 0x20, 0x20, 0x20, 0x20 , '|',13,10
                db  0x20, 0x20, 0x20, 0x20, 0x20, '|', 0x20, 0x20, 0x20, 0x20, 0x20, '|', 0x20, 0x20, 0x20, 0x20, 0x20, '|', 0x20, 0x20, 0x20, 0x20, 0x20 , '|' , 0x20, 0x20, 0x20, 0x20, 0x20 , '|',13,10
                db  0x20, 0x20, 0x20, 0x20, 0x20, '|', 0x20, 0x20, 0x20, 0x20, 0x20, '|', 0x20, 0x20, 0x20, 0x20, 0x20, '|', 0x20, 0x20, 0x20, 0x20, 0x20 , '|' , 0x20, 0x20, 0x20, 0x20, 0x20 , '|',13,10
                db  0x20, 0x20, 0x20, 0x20, 0x20, '|', 0x20, 0x20, 0x20, 0x20, 0x20, '|', 0x20, 0x20, 0x20, 0x20, 0x20, '|', 0x20, 0x20, 0x20, 0x20, 0x20 , '|' , 0x20, 0x20, 0x20, 0x20, 0x20 , '|',13,10
		db  0x20, 0x20, 0x20, 0x20, 0x20, '|', 0x20, 0x20, 0x20, 0x20, 0x20, '|', 0x20, 0x20, 0x20, 0x20, 0x20, '|', 0x20, 0x20, 0x20, 0x20, 0x20 , '|' , 0x20, 0x20, 0x20, 0x20, 0x20 , '|',13,10,0

space		db 0x20,0x20,0x20,0x20,0x20,0

num_table_log: times 26 dw 0

line: times 2 db 0
cols: times 2 db 0

line_save: times 2 db 0
cols_save: times 2 db 0

line_save_1: times 2 db 0
cols_save_1: times 2 db 0

choose_num: times 2 db 0

save_num_1: times 1 dw 0
save_num_2: times 1 dw 0
save_num_3: times 1 dw 0
save_num_4: times 1 dw 0
save_num_5: times 1 dw 0
save_num_en_3: times 1 dw 0

num_op_1: times 1 dw 0
num_op_2: times 1 dw 0

save_num: times 1 dw 0
change_num: times 6 db 0

num_prt_1: times 5 db 0
num_prt_2: times 5 db 0
num_prt_3: times 5 db 0
num_prt_4: times 5 db 0
num_prt_5: times 5 db 0
save_num_prt_en_3: times 6 db 0

table_game: times 10 dw 0

count_en_1: times 1 db 0
count_en_2: times 1 db 0
count_en_3: times 1 db 0
count_en_4: times 1 db 0

max_num: times 1 dw 0
cols_c: times 1 dw 0
line_c: times 1 dw 0
