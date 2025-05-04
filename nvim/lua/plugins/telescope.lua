return {
	'nvim-telescope/telescope.nvim',
	tag = '0.1.8',
	dependencies = { 'nvim-lua/plenary.nvim' },

	config = function()
		local themes = {
			"edge",
			"kanagawa-dragon",
			"kanagawa-wave",
		}

		local pickers = require("telescope.pickers")
		local finders = require("telescope.finders")
		local conf = require("telescope.config").values
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		local function save_theme(name)
			local file = vim.fn.stdpath("config") .. "/lua/custom/theme.lua"
			local f = io.open(file, "w")
			if f then
				f:write(string.format("vim.cmd.colorscheme('%s')\n", name))
				f:close()
				print("Saved theme: " .. name)
			else
				print("Failed to save theme.")
			end
		end

		local function theme_picker()
			local previewed = nil
			pickers.new({}, {
				prompt_title = "Choose Colorscheme",
				finder = finders.new_table {
					results = themes,
				},
				sorter = conf.generic_sorter({}),
				layout_config = {
            		prompt_position = "top",
					width = 0.4,   -- 40% of the screen width
					height = 0.3,  -- 30% of the screen height
            		preview_width = 0.5,
				},
				attach_mappings = function(prompt_bufnr, map)
					local function preview()
						local entry = action_state.get_selected_entry()
						if entry and entry[1] ~= previewed then
							pcall(vim.cmd.colorscheme, entry[1])
							previewed = entry[1]
						end
					end

					map({"n", "i"}, "<C-n>", function()
						actions.move_selection_next(prompt_bufnr)
						preview()
					end)

					map({"n", "i"}, "<C-p>", function()
						actions.move_selection_previous(prompt_bufnr)
						preview()
					end)

					-- Arrow keys (optional but intuitive)
					map({"n", "i"}, "<Down>", function()
						actions.move_selection_next(prompt_bufnr)
						preview()
					end)

					map({"n", "i"}, "<Up>", function()
						actions.move_selection_previous(prompt_bufnr)
						preview()
					end)

					actions.select_default:replace(function()
						actions.close(prompt_bufnr)
						local selection = action_state.get_selected_entry()
						if selection then
							local name = selection[1]
							pcall(vim.cmd.colorscheme, name)
							save_theme(name)
						end
					end)

					return true
				end,
			}):find()
		end
		vim.api.nvim_create_user_command("ThemePicker", theme_picker, {})

		local telescope = require("telescope")
		telescope.setup({
			defaults = {
				layout_strategy = "horizontal",
				layout_config = {
            		prompt_position = "top",
					width = 0.8,
					height = 0.6,
            		preview_width = 0.5,
				},
				border = true,
				sorting_strategy = "ascending",
				prompt_prefix = "   ",
				selection_caret = "> ",
				entry_prefix = "  ",
				path_display = function(opts, path)
				  local tail = require("telescope.utils").path_tail(path)
  				  return string.format("%s - %s", tail, path), { { { 1, #path }, "Comment" } }
				end,
			},
		})
	end,
}
