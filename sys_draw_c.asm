[BITS 16]
[GLOBAL sys_draw_c]

sys_draw_c:

; Ẩn con trỏ chuột (tùy chọn)
        mov ah, 0x01
        mov cx, 0x2000
        int 0x10
; DRAW
        push ds
        mov ax, 0xB800
        mov es, ax
loop_draw:
        lodsb

        cmp al, 10
        je newline

        test al, al
        jz done

        mov ah, bh
        stosw

        jmp loop_draw
done:
        pop ds
        ret


newline:
        mov ax, di
        mov cx, 160
        xor dx, dx
        div cx
        inc al
        xor ah, ah
        mov di, ax
        mul cx
        mov di, ax
        jmp loop_draw
