local function mode_emoji()
  local mode_map = {
    n = "🌊 NORMAL",
    i = "INSERT",
    v = "VISUAL",
    t = "TERMINAL",
  }

  local mode = vim.api.nvim_get_mode().mode
  return mode_map[mode] or "🤔 " .. mode
end
return {
	'nvim-lualine/lualine.nvim',
	dependencies = { 'nvim-tree/nvim-web-devicons' },
	lazy = false,
	config = function()
		require("lualine").setup({
			options = {
				theme = "auto",
				section_separators = { left = "", right = ""},
				component_separators = { left = '-', right = '-' },

				icons_enabled = true,
				globalstatus = true,
			},
			sections = {
    			lualine_a = { mode_emoji }, -- replaced "mode"
				lualine_b = { "branch", "diff", "diagnostics" },
				lualine_c = { { "filename", path = 1 } }, -- 1 = relative path
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "searchcount", "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = { "filename" },
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
		})
	end,
}
