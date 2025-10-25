DM-OS-16-BIT
# DM_OS – Educational 16-bit Operating System

DM_OS is a **16-bit real-mode operating system** built entirely in Assembly, created as part of a research project at Trần Khai Nguyên High School.  
The project’s goal is to make Assembly and OS development more accessible to Vietnamese students through a clear codebase and a practical learning method called **F→S (Fundamental → System)**.

---

## ⚙️ Overview

- 🧠 Written completely in x86 Assembly (no C)
- 💾 Boots directly from BIOS (512B boot sector)
- 🖥️ Text-mode GUI using VGA memory (`0xB8000`)
- ⌨️ Keyboard input via BIOS interrupt `int 0x16`
- 📂 Modular structure (bootloader, kernel, drivers, apps)
- 🧮 Built-in applications:  
  `CMD`, `Game`, `Cheat sheet assembly x86-64`, `Calculator`
- 🧩 Educational structure: each module shows one OS concept  
  (booting, interrupt handling, memory segmentation, I/O control, etc.)

---

## 🧠 Learning Purpose

This project was created to:
- Help students **understand OS internals** without complex C or paging code.
- Provide a **clear, working 16-bit example** for learning system programming.
- Demonstrate a new learning path for Assembly: **F→S Method (Fundamental → System)** — learning through building real components step-by-step.

---


