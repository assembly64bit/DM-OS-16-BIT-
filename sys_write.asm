[BITS 16]
[GLOBAL sys_write]

sys_write:
; Ẩn con trỏ chuột (tùy chọn)
        mov ah, 0x01		; ah = 0x01 là chức năng đặt kiểu con trỏ text mode
        mov cx, 0x2000		; cl = dòng đầu bắt đầu con trỏ , ch dòng kết thúc con trỏ , trong bios khi nếu dòng đầu >= dòng kết thúc con trỏ sẽ được ẩn
        int 0x10		; gọi interupt video theo chức năng đã chuẩn bị cho ah
loop_write:
	lodsb			; load từng byte từ si ( nguồn ) vào al
	test al, al		; kiểm tra al
	jz done			; nếu al = 0x00 thì kết thúc chuỗi
	mov ah, 0xE		; ah = chọn chức năng Teletype Output , al là kí tự muốn in
	int 10h			; gọi interupt của bios
	jmp loop_write		; lặp đến khi gặp 0x00
done:
	ret			; trở về code chính
