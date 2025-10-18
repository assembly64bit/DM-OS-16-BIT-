[BITS 16]			 ; bit 16 để nasm nhận dạng
[ORG 0x7C00]			 ; địa chỉ thường bios
start:
	cli       	         ; tắt ngắt
	xor ax, ax
	mov ss, ax
	mov sp, 0x1000           ; stack nằm ngoài code

; Chuẩn bị các thanh ghi segment
	mov ds, ax
	mov es, ax
	mov fs, ax
	mov gs, ax
	sti
load:

; LOAD
	xor cx, cx		; đặt trạng thái thanh ghi về 0
	xor ah, ah		; đặt trạng thái thanh ghi về 0
	xor dx, dx		; đặt trạng thái thanh ghi về 0

	mov bx, 0x8000		; địa chỉ trong bộ nhớ , nơi sector được load
	mov dh, 0		; DH = head number (trên CHS addressing) → head 0

	mov dl, 0  		; DL = drive number → 0 = floppy A:, 0x80 = HDD đầu tiên
	mov ch, 0		; số track

	mov cl, 2		; do sector BIOS bắt đầu từ 1, không phải 0, nên sector 2 là sector thứ hai.
	mov ah, 0x02		; ah = 2 là lệnh đọc sector của bios int 13h
	mov al, 52		; sector read
	int 0x13		; lệnh ngắt để đọc ổ đĩa
				; INT 13h sẽ copy dữ liệu từ ổ đĩa vào ES:BX (ở đây ES mặc định = 0, BX = 0x8000).

	jc error

	jmp 0x0800:0000		; nhảy vô kernel

error:
	cli
	hlt


msg db "Loading kernel ...", 0

times 510 - ( $ - $$ ) db 0	; paging cho đủ 512 byte vì hầu hết bootloader cần đủ 512 byte mới load được
dw 0xAA55			; Cần bios mặc định cần 2 byte 0xAA55 ở cuối mới đúng định dạng và boot được thành công
				; nếu không có sẽ boot fail từ đó dẫn đến crash

