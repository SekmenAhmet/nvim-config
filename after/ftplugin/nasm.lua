local map = vim.keymap.set
local opts = { buffer = true, noremap = true, silent = true }

map("i", ".text", "section .text", opts)
map("i", ".data", "section .data", opts)
map("i", ".rodata", "section .rodata", opts)
map("i", ".bss", "section .bss", opts)
