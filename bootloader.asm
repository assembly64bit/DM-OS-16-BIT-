[BITS 16]
[ORG 0x7C00]
start:
; NEW CODE
	cli                     ; tắt ngắt
	xor ax, ax
	mov ss, ax
	mov sp, 0x1000           ; stack nằm ngoài code
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

	mov bx, 0x8000
	mov dh, 0

	mov dl, 0
	mov ch, 0

	mov cl, 2
	mov ah, 0x02
	mov al, 52		; sector read
	int 0x13		; lệnh ngắt để đọc ổ đĩa

	jc error

	jmp 0x0800:0000		; nhảy vô kernel

error:
	cli
	hlt


msg db "Loading kernel ...", 0

times 510 - ( $ - $$ ) db 0
dw 0xAA55
