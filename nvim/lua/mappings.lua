require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map('n', 'gd', vim.lsp.buf.definition, {desc = "Go to definition"})

-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")
