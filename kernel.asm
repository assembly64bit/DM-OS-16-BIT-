[BITS 16]
[GLOBAL start]
; Các hàm , app , game được linked vô tương ứng để kernel xử lí
extern menu_game
extern menu_calculator
extern cmd
extern menu_learn_app
extern clear_src
extern sys_write
extern chat_bot
extern sys_draw_c
start:
;------------------------------------------
; 1 vòng lặp lớn chờ input từ người dùng
input:
; Gọi hàm xóa màn hình
	call clear_src
; Gọi hàm render custome
; Trong đó di = địa chỉ hiện tại + 0x0B800 ( địa chỉ màn hình trong bios )
; si là con trỏ đến chuỗi menu_msg
; bh = 0x0E là màu

	xor di, di
	mov si, menu_msg
	mov bh, 0x0E
	call sys_draw_c

input_1:
	xor ah, ah		; Xóa ah, ah để setup
	int 0x16		; BIOS đọc kí tự bàn phím khi gọi int 16h -> al = ascii
; kiểm tra người dùng đã chọn hàm nào
	cmp al, '1'
	je cmd_exe
	cmp al, '2'
	je menu_game_app
	cmp al, '3'
	je menu_learning_app
	cmp al, '4'
	je caculator
	jmp input_1		 ; quay lại vòng lặp nếu người dùng nhập phím không khớp hoặc sai
cmd_exe:
	call clear_src
	call cmd
	jmp input		;  quay lại vòng lặp
menu_game_app:
	call clear_src
	call menu_game
	jmp input		 ; quay lại vòng lặp
menu_learning_app:
        call clear_src
	call menu_learn_app
	jmp input		 ; quay lại vòng lặp
caculator:
        call clear_src
	call menu_calculator
	jmp input		; quay lại vòng lặp
; DATA
menu_msg db "*******************************************************************************",10
         db "*                                Welcome to My OS                             *",10
         db "*******************************************************************************",10
	 db "*                                1. Cmd                                       *",10
	 db "*                                2. Game App                                  *",10
         db "*                                3. Cheat sheet for asm x86-64                *",10
	 db "*                                4. Calculator                                *",10
	 db "*******************************************************************************",10
	 db "Enter numbers from 1-->4 to activate : ",0










