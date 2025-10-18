[BITS 16]
[GLOBAL sys_read]
sys_read:
        xor ax, ax
	xor cx, cx		; cx = count
				; di = số lượng kí tự đã nhập
loop_read:
        mov ah, 0x00		; chọn chức năng đọc từ bàn phím
        int 0x16            	; Đọc phím từ bàn phím vào AL , AL = kí tự , AH = scancode

        cmp al, 0Dh         	; Enter?
        je .maybe_enter		; xử lí enter

        cmp al, 0x08
        je .handle_backspace	; xử lí phím backspace
; CHECK LIMIT
	cmp cx, di		; nếu cx >= di thì quay lại vòng lặp loop read
	jae loop_read

 	jmp .store_and_print    ; Nếu không phải thì đọc lại
.store_and_print:
; si là con trỏ vào buffer
; cx là count

        mov [si], al        	; Lưu vào buffer
        inc si			; tăng si lên 1
        inc cx			; tăng cx lên 1

        mov ah, 0x0E        	; ah = 0xE , chức năng Teletype Output
        int 0x10		; gọi interupt trong bios với chức năng video

        jmp loop_read		; quay lại vòng lặp

.handle_backspace:
        cmp cx, 0		; nếu cx = 0 , cần quay lại vòng lặp loop read
        je loop_read		; do nếu dec cx khi cx = 0 , thì cx = -1 từ đó dẫn đến lỗi lệch số đếm , có thể crash

        dec si			; giảm chỉ số con trỏ đi 1
        dec cx			; giảm count đi 1

        mov ah, 0x0E		; ah = 0xE , chức năng Teletype Outpu
	int 0x10		;   gọi interupt trong bios với chức năng video

        mov al, ' '		; al = kí tự space
        int 0x10		;  gọi interupt trong bios với chức năng video

        mov al, 8		; nếu ah = 0xE và al = 8 thì khi int 10h chỉ làm lùi con trỏ
        int 0x10

        jmp loop_read		; quay lại vòng lặp
.maybe_enter:
        test cx, cx		; nếu count = 0 ( người dùng chưa nhập hoặc nhập enter ) thì quay lại vòng lặp
        jz loop_read

done_read_loop:
; CHECK ENTER REAL OR SPAM
        mov al, 0		; al = 0x0
        mov [si], al        	; Kết thúc chuỗi bằng null
        ret			; trở về code chính









