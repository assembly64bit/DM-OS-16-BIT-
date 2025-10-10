[BITS 16]
[GLOBAL clear_src]

clear_src:
	mov ax, 0x0600       ; Scroll up function
	mov bh, 0x07        ; Attribute used for blank lines (white on black)
	mov cx, 0x0000      ; Upper left corner of window (row=0, col=0)
	mov dx, 0x184F      ; Lower right corner (row=24, col=79)
	int 0x10            ; Call BIOS video service

	mov ah, 02h    ; Hàm set cursor position
	mov bh, 0      ; Số trang (thường là 0)
	mov dh, 0      ; Hàng (row) = 0 (trên cùng)
	mov dl, 0      ; Cột (column) = 0 (trái cùng)
	int 10h        ; Gọi BIOS video service
	ret

