[BITS 16]
[GLOBAL sys_draw]

sys_draw:
; Ẩn con trỏ chuột (tùy chọn)
	mov ah, 0x01
	mov cx, 0x2000
	int 0x10

;---------------------------------------
; Giai đoạn 1: vẽ vào back buffer (0x9000)
;---------------------------------------
	push ds
 	xor ax, ax
	mov ax, 0x9000
	mov es, ax
	xor di, di
	mov cx, 25*80
loop_draw_back:
	lodsb
	mov ah, 0x04
	stosw

	loop loop_draw_back

;---------------------------------------
; Giai đoạn 2: copy từ back → video RAM (0xB800)
;---------------------------------------
	xor si, si
	mov ax, 0x9000
	mov ds, ax

	xor di, di
	mov ax, 0xB800
	mov es, ax

	mov cx, 80*25
.copy:
	lodsw
	stosw
	loop .copy

	pop ds
	ret
