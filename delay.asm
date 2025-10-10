[BITS 16]
[GLOBAL delay]
delay:
	mov cx, 0xFFFF
loop_delay:
	nop
	loop loop_delay
	ret
