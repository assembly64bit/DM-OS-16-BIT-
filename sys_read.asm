[BITS 16]
[GLOBAL sys_read]
sys_read:
        xor ax, ax
        xor cx, cx

loop_read:
        mov ah, 0x00
        int 0x16            ; Đọc phím từ bàn phím vào AL

        cmp al, 0Dh         ; Enter?
        je .maybe_enter

        cmp al, 0x08
        je .handle_backspace

 	jmp .store_and_print       ; Nếu không phải thì đọc lại

.store_and_print:
        mov [si], al        ; Lưu vào buffer
        inc si
        inc cx

        mov ah, 0x0E        ; In ký tự AL ra màn hình
        int 0x10

        jmp loop_read

.handle_backspace:
        cmp cx, 0
        je loop_read

        dec si
        dec cx

        mov ah, 0x0E
        int 0x10

        mov al, ' '
        int 0x10

        mov al, 8
        int 0x10

        jmp loop_read




.maybe_enter:
        test cx, cx
        jz loop_read


done_read_loop:
; CHECK ENTER REAL OR SPAM

        mov al, 0
        mov [si], al        ; Kết thúc chuỗi bằng null
        ret









