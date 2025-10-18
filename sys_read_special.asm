[BITS 16]
[GLOBAL sys_read_special]
sys_read_special:
        xor ax, ax
        xor cx, cx

read_special_loop:
        mov ah, 0x00
        int 0x16            ; Đọc phím từ bàn phím vào AL

        cmp al, 0Dh         ; Enter?
        je .maybe_enter

	cmp al, 0x08
	je .handle_backspace

        ; Chỉ nhận 1, 2, 3
        cmp al, '1'
        je .check_limit

        cmp al, '2'
        je .check_limit

        cmp al, '3'
        je .check_limit

	cmp al, '4'
	je .check_limit

	cmp al, '5'
	je .check_limit

	cmp al, 'q'
	je .check_limit

        jmp read_special_loop       ; Nếu không phải thì đọc lại
.check_limit:
	cmp cx, di
	jae read_special_loop

.store_and_print:
        mov [si], al        ; Lưu vào buffer
        inc si
        inc cx

        mov ah, 0x0E        ; In ký tự AL ra màn hình
        int 0x10

        jmp read_special_loop

.handle_backspace:
	cmp cx, 0
	je read_special_loop

	dec si
	dec cx

	mov ah, 0x0E
	int 0x10

	mov al, ' '
	int 0x10

	mov al, 8
	int 0x10

	jmp read_special_loop
.maybe_enter:
	test cx, cx
	jz read_special_loop
done_read_loop:
; CHECK ENTER REAL OR SPAM

        mov al, 0
        mov [si], al        ; Kết thúc chuỗi bằng null
        ret
