local HEIGHT_RATIO = 0.5
local WIDTH_RATIO = 0.25

return {
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local nvim_tree = require("nvim-tree")
    local api = require("nvim-tree.api")

	local function setup_float()
		nvim_tree.setup({
			hijack_cursor = true,
			view = {
				float = {
					enable = true,
					open_win_config = function()
					  local screen_w = vim.opt.columns:get()
					  local screen_h = vim.opt.lines:get() - vim.opt.cmdheight:get()
					  local win_w = math.floor(screen_w * WIDTH_RATIO)
					  local win_h = math.floor(screen_h * HEIGHT_RATIO)
					  local win_x = math.floor((screen_w - win_w) / 2)
					  local win_y = math.floor((screen_h - win_h) / 2)
					  return {
						relative = "editor",
						border = "solid",
						width = win_w,
						height = win_h,
						row = win_y,
						col = win_x,
					  }
					end,
				},
				width = function()
					return math.floor(vim.opt.columns:get() * WIDTH_RATIO)
				end,
			},
	  	})	
		vim.api.nvim_create_autocmd("FileType", {
		pattern = "NvimTree",
		callback = function()
		  if require("nvim-tree.view").View.float then
			vim.keymap.set("n", "<Esc>", ":NvimTreeClose<CR>", {
			  buffer = true,
			  silent = true,
			  desc = "Close NvimTree with Esc",
			})
		  end
		end,
	  })
	end

	local function open_nvim_tree_float()
	  setup_float()
	  api.tree.open()
	end
    
    local function open_nvim_tree_side()
		nvim_tree.setup({
			hijack_cursor = true,
			view = {
				float = { enable = false },
				side = "right"
			},
		})

    	api.tree.open()
    end
	setup_float()
	vim.keymap.set("n", "<leader>ef", open_nvim_tree_float, { desc = "Create new Floating Tree" })
	vim.keymap.set("n", "<leader>es", open_nvim_tree_side, { desc = "Create new Side Tree" })
  end,
}


