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

## 🚀 Build & Run

### Prerequisites
Install NASM and QEMU (Linux/WSL):
```bash
sudo apt install nasm make qemu-system-x86 -y
sudo apt install make
make run 
```
---
## 🧠 F→S Method (Fundamental → System)
DM_OS introduces a new structured learning model for Assembly — the F→S Method, short for Fundamental → System.
It helps students progress from understanding basic CPU instructions to building real operating systems step-by-step.
🩻 Stage 1 – Fundamental (Levels F--- → E+++)
Learn registers, flags, and memory layout
Practice with small programs: add, jump, loops
Use debugger (GDB/QEMU) to observe register changes
⚙️ Stage 2 – Engineer (Levels D--- → B+++)
Combine theory and hands-on coding
Understand interrupts, stack, and segment registers
Write simple drivers and memory managers
🧩 Stage 3 – System (Levels A--- → S+++)
Integrate everything into a full OS
Build bootloader, kernel, syscall table, GUI
Debug memory flow and handle hardware interrupts
🧭 “Learn by building, not memorizing.”
Each level ends with a tangible product — a working piece of the OS.
---

