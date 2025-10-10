[BITS 16]
[GLOBAL start]

extern menu_game
extern menu_calculator
extern cmd
extern menu_learn_app

extern clear_src
extern sys_write
extern chat_bot
extern sys_draw_c


start:
	cli
	xor ax, ax
	mov ds, ax
	mov es, ax

; ===== BẬT A20 LINE =====
        mov ax, 2401h
        int 15h                 ; BIOS enable A20 (giả sử BIOS ok)
; ===== SETUP LGDT

        lgdt [gdt_desc]
; ===== ENTER PROTECTED MODE =====
        mov eax, cr0
        or  eax, 1
        mov cr0, eax

[BITS 32]
protected_mode_entry:
        mov ax, 10h
        mov ds, ax
        mov es, ax
        mov fs, ax
        mov gs, ax
        mov ss, ax


; ===== EXIT PROTECTED MODE (UNREAL MODE) =====
        mov eax, cr0
        and eax, 0xFFFFFFFE
        mov cr0, eax

; *** VERY IMPORTANT: FAR JUMP về real mode ***
        jmp 0x0000:unreal_mode_entry

[BITS 16]
unreal_mode_entry:
    ; Now CPU in real mode, nhưng DS/ES/SS limit vẫn = 4GB (unreal)
    ; CS = 0x0800 real mode segment
        mov ax, 0x0000
        mov ss, ax
        mov sp, 0xF000

        sti                     ; enable interrupts
;------------------------------------------
input:
	call clear_src

	xor di, di
	mov si, menu_msg
	mov bh, 0x0E
	call sys_draw_c

input_1:
	xor ah, ah
	int 0x16

	cmp al, '1'
	je cmd_exe

	cmp al, '2'
	je menu_game_app

	cmp al, '3'
	je menu_learning_app

	cmp al, '4'
;	je chat_bot_app

	cmp al, '4'
	je caculator

	jmp input_1
cmd_exe:
	call clear_src
	call cmd

	jmp input

menu_game_app:
	call clear_src
	call menu_game

	jmp input


menu_learning_app:
        call clear_src
	call menu_learn_app

	jmp input

chat_bot_app:
        call clear_src
	call chat_bot

	jmp input

caculator:
        call clear_src
	call menu_calculator

	jmp input





; DATA
menu_msg db "*******************************************************************************",10
         db "*                                Welcome to My OS                             *",10
         db "*******************************************************************************",10
	 db "*                                1. Cmd                                       *",10
	 db "*                                2. Game App                                  *",10
         db "*                                3. Cheat sheet for asm x86-64                *",10
 ;        db "*                                4. Chat Bot                                  *",10
	 db "*                                4. Calculator                                *",10
	 db "*******************************************************************************",10
	 db "Enter numbers from 1-->4 to activate : ",0

gdt:
    dq 0x0000000000000000   ; null
    dq 0x00CF9A000000FFFF   ; code: base=0, limit=4GB
    dq 0x00CF92000000FFFF   ; data: base=0, limit=4GB
gdt_end:
gdt_desc:
    dw gdt_end - gdt - 1
    dd gdt


;==============================================================APP LEARN










