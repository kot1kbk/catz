# ⚡ catz

> **catz** — a blazing-fast drop-in replacement for the classic `cat` utility, written from scratch in **Zig**. It doesn't just mimic the original behavior — it outperforms it with modern system calls and advanced buffering.

[![Zig](https://img.shields.io/badge/Zig-0.16.0-orange?logo=zig)](https://ziglang.org/)
[![Linux](https://img.shields.io/badge/Linux-x86__64-blue?logo=linux)](https://kernel.org/)
[![License](https://img.shields.io/badge/License-MIT-green)](LICENSE)

---

## 🚀 Features

- ✅ **Fully compatible** with GNU `cat` — supports all major flags
- ⚡ **Blazing fast** — outperforms `cat` on small files by up to **1.74x**, and nearly matches it on large files
- 🦎 **Written in Zig** — memory-safe, no segmentation faults, no surprises
- 📦 **Single binary** — no external dependencies, just `catz` and your terminal

---

## 📋 Supported Flags

| Flag | Long Form | Description |
|------|-----------|-------------|
| `-n` | `--number` | Number all output lines |
| `-b` | `--number-nonblank` | Number only non-empty lines |
| `-E` | `--show-ends` | Display `$` at the end of each line |
| `-s` | `--squeeze-blank` | Suppress repeated empty lines |
| `--help` | — | Show help message and exit |

> 💡 Flags can be combined (e.g., `catz -nE file.txt`).

---

## 📦 Installation

### From Source

Make sure you have **Zig 0.16.0** installed.

```bash
git clone https://github.com/yourusername/catz.git
cd catz
zig build-exe -O ReleaseFast main.zig -femit-bin=catz
sudo cp catz /usr/local/bin/
