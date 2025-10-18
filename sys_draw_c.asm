[BITS 16]
[GLOBAL sys_draw_c]

sys_draw_c:

; Ẩn con trỏ chuột (tùy chọn)
        mov ah, 0x01
        mov cx, 0x2000
        int 0x10
; DRAW
; chuẩn bị segment
        push ds
        mov ax, 0xB800		; ax = địa chỉ màn hình bios = 0xB800
        mov es, ax		; stosw = es:si
loop_draw:
        lodsb			; load từng byte vào al

        cmp al, 10		; nếu al = 10 , nhảy đến newline
        je newline

        test al, al		; nếu al = 0 , kết thúc việc in
        jz done

        mov ah, bh		; ah = màu kí tự , bh là màu chọn ở ngoài
        stosw			; vẽ 2 byte lên màn hình 0x0B800

        jmp loop_draw
done:
        pop ds
        ret			; trở về hàm chính


newline:
        mov ax, di		; di = ax = địa chỉ hiện tại
        mov cx, 160		; cx = số cột
        xor dx, dx		; set thanh dx về 0
        div cx			; chia cx cho 160
        inc al
        xor ah, ah
        mov di, ax
        mul cx
        mov di, ax
        jmp loop_draw
