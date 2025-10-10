# 👑 GRP OS - Makefile
# Tự động build bootloader, kernel từ nhiều file .asm

all: os.img

# 🧱 Build bootloader (stage 1 - 512 byte)
bootloader.bin: bootloader.asm
	nasm -f bin bootloader.asm -o bootloader.bin

# 🧠 Build kernel từ nhiều file .asm
kernel.elf: kernel.asm sys_write.asm sys_read.asm sys_read_special.asm sys_draw.asm sys_draw_animation.asm clear_src.asm sys_read_specail_for_math.asm sys_draw_c.asm cmd.asm menu_calculator.asm basic.asm dec_to_bin.asm LCM_GCD.asm menu_game.asm x_o.asm menu_game_2048.asm easy_mode.asm gui_game_math.asm math_quiz.asm menu_ad_game.asm ad_game_play.asm chat_bot.asm menu_learn_app.asm linker.ld
	#UI_sur.asm play.asm inventory.asm player_wp.asm player_cth.asm player_armor.asm ai_wp.asm ai_cth.asm ai_armor.asm guess_num.asm

	nasm -f elf32 -g -F dwarf kernel.asm -o kernel.o

	nasm -f elf32 -g -F dwarf sys_write.asm -o sys_write.o
	nasm -f elf32 -g -F dwarf sys_read.asm -o sys_read.o
	nasm -f elf32 -g -F dwarf clear_src.asm -o clear_src.o
	nasm -f elf32 -g -F dwarf sys_read_special.asm -o sys_read_special.o
	nasm -f elf32 -g -F dwarf sys_draw.asm -o sys_draw.o
	nasm -f elf32 -g -F dwarf sys_read_specail_for_math.asm -o sys_read_specail_for_math.o
	nasm -f elf32 -g -F dwarf menu_game.asm -o menu_game.o
	nasm -f elf32 -g -F dwarf sys_draw_animation.asm -o sys_draw_animation.o
	nasm -f elf32 -g -F dwarf sys_draw_c.asm -o sys_draw_c.o
#CMD
	nasm -f elf32 -g -F dwarf cmd.asm -o cmd.o
#Game guess num
#	nasm -f elf32 -g -F dwarf guess_num.asm -o guess_num.o
	nasm -f elf32 -g -F dwarf x_o.asm -o x_o.o
#Game 2048
	nasm -f elf32 -g -F dwarf menu_2048.asm -o menu_game_2048.o
	nasm -f elf32 -g -F dwarf easy_mode.asm -o easy_mode.o
#Game quiz math
	nasm -f elf32 -g -F dwarf gui_game_math.asm -o gui_game_math.o
	nasm -f elf32 -g -F dwarf math_quiz.asm -o math_quiz.o
#Game snake
	nasm -f elf32 -g -F dwarf menu_ad_game.asm -o menu_ad_game.o
	nasm -f elf32 -g -F dwarf ad_game_play.asm -o ad_game_play.o
#GAME RPG SUR
#	nasm -f elf32 -g -F dwarf UI_sur.asm -o UI_sur.o
#	nasm -f elf32 -g -F dwarf play.asm -o play.o
#	nasm -f elf32 -g -F dwarf inventory.asm -o inventory.o
#	nasm -f elf32 -g -F dwarf player_wp.asm -o player_wp.o
#	nasm -f elf32 -g -F dwarf player_cth.asm -o player_cth.o
#	nasm -f elf32 -g -F dwarf player_armor.asm -o player_armor.o
#	nasm -f elf32 -g -F dwarf ai_wp.asm -o ai_wp.o
#	nasm -f elf32 -g -F dwarf ai_cth.asm -o ai_cth.o
#	nasm -f elf32 -g -F dwarf ai_armor.asm -o ai_armor.o
#APP LEARN
	nasm -f elf32 -g -F dwarf menu_learn_app.asm -o menu_learn_app.o
#Chat bot
	nasm -f elf32 -g -F dwarf chat_bot.asm -o chat_bot.o

#APP CACULATOR
	nasm -f elf32 -g -F dwarf menu_calculator.asm -o menu_calculator.o
	nasm -f elf32 -g -F dwarf basic.asm -o basic.o
	nasm -f elf32 -g -F dwarf dec_to_bin.asm -o dec_to_bin.o
	nasm -f elf32 -g -F dwarf LCM_GCD.asm -o LCM_GCD.o

	ld -m elf_i386 -T linker.ld -o kernel.elf kernel.o sys_write.o sys_read.o sys_read_special.o sys_draw.o sys_draw_animation.o clear_src.o sys_read_specail_for_math.o sys_draw_c.o cmd.o menu_calculator.o basic.o dec_to_bin.o LCM_GCD.o menu_game.o x_o.o menu_game_2048.o easy_mode.o gui_game_math.o math_quiz.o menu_ad_game.o ad_game_play.o chat_bot.o menu_learn_app.o
	#UI_sur.o play.o inventory.o player_wp.o player_cth.o player_armor.o ai_wp.o ai_cth.o ai_armor.o guess_num.o

# ✂️ Cắt ELF thành raw binary (cho BIOS xài)
kernel.bin: kernel.elf
	dd if=kernel.elf of=kernel.bin bs=512 conv=notrunc



# 🖼️ Tạo đĩa image đầy đủ
os.img: bootloader.bin kernel.bin
	dd if=/dev/zero of=os.img bs=512 count=2880
	dd if=bootloader.bin of=os.img conv=notrunc bs=512 seek=0
	dd if=kernel.bin of=os.img conv=notrunc bs=512 seek=1

# 🚀 Chạy bằng QEMU
run: os.img
	qemu-system-i386 -drive if=floppy,format=raw,file=os.img

# 🐛 Debug bằng GDB
debug: os.img
#	qemu-system-i386 -fda os.img -S -gdb tcp::1234
	qemu-system-x86_64 -drive format=raw,file=os.img -no-reboot -no-shutdown -d int,cpu_reset
# 🧹 Dọn sạch
clean:
	rm -f *.bin *.o *.elf *.img

