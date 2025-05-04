local opts = { noremap = true, silent = true }

-- Better window navigation
vim.keymap.set("n", "<C-h>", "<C-w>h", opts)
vim.keymap.set("n", "<C-j>", "<C-w>j", opts)
vim.keymap.set("n", "<C-k>", "<C-w>k", opts)
vim.keymap.set("n", "<C-l>", "<C-w>l", opts)

-- Keybinds for Nvim-Tree
vim.keymap.set("n", "<leader>t", ":NvimTreeToggle<CR>")

-- Telescope
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fw", ":Telescope grep_string<CR>")

vim.keymap.set("n", "<Esc>", function()
  local line = vim.api.nvim_get_current_line()
  local col = vim.fn.col('.') - 1
  local search_pat = vim.fn.getreg('/')

  -- Escape special characters in search pattern
  search_pat = vim.fn.escape(search_pat, '\\/.*$^~[]')

  local start_col, end_col = string.find(line, search_pat)
  if start_col and col + 1 >= start_col and col + 1 <= end_col then
    vim.cmd("nohlsearch")
  end

  -- Send normal <Esc> to exit modes etc.
  vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Esc>", true, false, true), "n", false)
end, { noremap = true, silent = true })

-- Goyo
vim.keymap.set("n", "<leader>g", ":Goyo<CR>", { desc = "Toggle Goyo" })
vim.api.nvim_create_autocmd("User", {
  pattern = "GoyoEnter",
  callback = function()
    vim.wo.number = true
    vim.wo.relativenumber = true
  end,
})

vim.api.nvim_create_autocmd("User", {
  pattern = "GoyoLeave",
  callback = function()
    -- Optionally restore your usual line number settings
    vim.wo.number = true
    vim.wo.relativenumber = true
  end,
})

local opts = { noremap = true, silent = true, buffer = bufnr }

-- Go to definition
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

-- Other useful mappings
vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, opts)
