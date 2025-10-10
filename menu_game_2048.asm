[GLOBAL menu_2048]






































; SECTION .DATA
gi_1        db ""
gi_2        db "======== BIOS 2048 OF LUCK & LOGIC ========",13,10
            db "Board sizes:",13,10
            db "- Easy   : 3x3",13,10
            db "- Medium : 2x3",13,10
            db "- Hard   : 1x3",13,10
            db "",13,10
            db "Each turn, 3 numbers appear. Choose 1 to place.",13,10
            db "Manual merge only! Example:",13,10
            db "Before:   100   0   100",13,10
            db "You get:  100",13,10
            db "Place on column 1 → Now: 200   0   100",13,10
            db "No auto-merge even if same values are side-by-side!",13,10
            db "",13,10
            db "Every 5 turns: You automatically gain a 500 block.",13,10
            db "Every 10 turns:",13,10
            db "- Lucky?  You get a number >1000.",13,10
            db "- Unlucky? Number 13 appears → your highest block is deleted.",13,10
            db "",13,10
            db "Target: Reach a number >= 10000 to win the game!",13,10
            db "No takebacks. One wrong move, and it may be over!",13,10
            db "==========================================",13,10
            db 0






