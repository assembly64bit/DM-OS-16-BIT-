[BITS 16]
[GLOBAL menu_learn_app]
extern sys_write
extern clear_src

menu_learn_app:
        call clear_src

        xor cx, cx              ; count page
        mov [count_page], cx
main:
        call input

        cmp dx, 1
        je page_next
        jne page_back

        jmp main
page_next:
        call clear_src

        lea di, [addr_page]
        mov cx, [count_page]

        cmp cx, 16
        jg main

        add di, cx

        mov si, [di]
        call sys_write

        mov cx, [count_page]
        add cx, 2
        mov [count_page], cx

        jmp main

page_back:
        call clear_src

        mov cx, [count_page]

        test cx, cx
        jle main

        mov cx, [count_page]
        sub cx, 2
        mov [count_page], cx
        lea di, [addr_page]
        add di, cx

        mov si, [di]
        call sys_write

        jmp main












;=========================================================
input:
	mov si, msg
	call sys_write
ip:
        xor ax, ax
        int 16h

        cmp ah, 4Dh
        je next_page

        cmp ah, 4Bh
        je back_page

	cmp al, 'q'
	je back_to_menu

        jmp ip

next_page:
        mov dx, 1               ; bit on
        ret
back_page:
        mov dx, 0
        ret








back_to_menu:
        call clear_src
        pop ax
	xor ax, ax
	ret






















; SECTION .DATA



count_page:             times 1 dw 0


; -------------------------
; Data: 9 pages of cheat sheet (expanded)
; addr_page is a table of near offsets (dw)
; count_page stores current offset (0,2,4,...)
; -------------------------

addr_page:
        dw cheat_sheet_msg_1
        dw cheat_sheet_msg_2
        dw cheat_sheet_msg_3
        dw cheat_sheet_msg_4
        dw cheat_sheet_msg_5
        dw cheat_sheet_msg_6
        dw cheat_sheet_msg_7
        dw cheat_sheet_msg_8

msg:	db "[ Press -> to next page ]",10,13
	db "[ Press <- to back page ]",13,10,0

; -------- page 1: introduction ----------
cheat_sheet_msg_1:
        db "=== x86-64 Assembly Basic Cheat Sheet ===",13,10
        db "Assembly = low-level instructions controlling CPU, registers & memory.",13,10
        db "Useful for performance, OS, bootloaders, and exploit dev.",13,10
        db "[ Page 1 ]",13,10,0

; -------- page 2: registers ----------
cheat_sheet_msg_2:
        db "[Registers (64-bit)]",13,10
        db "RAX - Accumulator / return value",13,10
        db "RBX - Base (callee-save)",13,10
        db "RCX - Counter / shifts (arg 4 in 32-bit conventions)",13,10
        db "RDX - Data / I/O (syscall arg)",13,10
        db "RSI - Source index (arg)",13,10
        db "RDI - Destination index (arg)",13,10
        db "RBP - Base pointer (frame)",13,10
        db "RSP - Stack pointer",13,10
        db "R8-R15 - Extra GP registers",13,10
        db "RIP - Instruction pointer, RFLAGS - CPU flags",13,10
        db "[ Page 2 ]",13,10,0

; -------- page 3: common instructions ----------
cheat_sheet_msg_3:
        db "[Common Instructions]",13,10
        db "mov dst, src     ; copy",13,10
        db "add dst, src     ; arithmetic",13,10
        db "sub dst, src",13,10
        db "mul src / div src; integer multiply/divide (use rax/rdx)",13,10
        db "inc/dec reg",13,10
        db "push reg / pop reg",13,10
        db "cmp a,b  ; then je/jne/jl/jg etc",13,10
        db "jmp label / call / ret",13,10
        db "lea reg, [mem]   ; load effective address",13,10
        db "[ Page 3 ]",13,10,0

; -------- page 4: syscalls summary ----------
cheat_sheet_msg_4:
        db "[Syscalls (Linux x86-64)]",13,10
        db "RAX = syscall number",13,10
        db "Args: RDI, RSI, RDX, R10, R8, R9",13,10
        db "Return: RAX (neg = error)",13,10
        db "Common: read(0), write(1), open, close, mmap, exit(60)",13,10
        db "[ Page 4 ]",13,10,0

; -------- page 5: syscalls example (pseudo x86-64) ----------
cheat_sheet_msg_5:
        db "[Syscall examples (x86-64)]",13,10
        db "write(fd, buf, len):",13,10
        db "  mov rax, 1",13,10
        db "  mov rdi, <fd>",13,10
        db "  mov rsi, <buf>",13,10
        db "  mov rdx, <len>",13,10
        db "  syscall",13,10
        db "",13,10
        db "read(fd, buf, len): set rax=0, rdi=fd, rsi=buf, rdx=len; syscall",13,10
        db "exit(status): rax=60, rdi=status; syscall",13,10
        db "[ Page 5 ]",13,10,0

; -------- page 6: System V AMD64 calling conv (short) ----------
cheat_sheet_msg_6:
        db "[System V AMD64 calling convention]",13,10
        db "Args in registers: RDI, RSI, RDX, RCX, R8, R9 (integer/pointer)",13,10
        db "Return in RAX (64-bit) or RDX:RAX for 128-bit",13,10
        db "Caller-saved: RAX, RCX, RDX, RSI, RDI, R8-R11",13,10
        db "Callee-saved: RBX, RBP, R12-R15 -> must be preserved by callee",13,10
        db "Stack must be 16-byte aligned at call boundary",13,10
        db "[ Page 6 ]",13,10,0

; -------- page 7: stack layout & prologue/epilogue ----------
cheat_sheet_msg_7:
        db "[Stack & function frame]",13,10
        db "Stack grows down. Memory at [rsp] is top.",13,10
        db "Typical prologue:",13,10
        db "  push rbp",13,10
        db "  mov rbp, rsp",13,10
        db "Epilogue: mov rsp, rbp ; pop rbp ; ret",13,10
        db "Local vars stored at negative offsets from rbp (x86-64)",13,10
        db "[ Page 7 ]",13,10,0

; -------- page 8: tips & short cheats ----------
cheat_sheet_msg_8:
        db "[Tips & cheats]",13,10
        db "- Keep DS (or segments) correct in 16-bit environment.",13,10
        db "- For your 16-bit menu: addr_page uses NEAR offsets (dw).",13,10
        db "- If sys_write needs length, implement scan to null or pass CX.",13,10
        db "- Use small examples: print, add, call, return, then expand.",13,10
        db "- Read assembly listings from compiled C to learn patterns.",13,10
        db "[ Page 8 ]",13,10,0
