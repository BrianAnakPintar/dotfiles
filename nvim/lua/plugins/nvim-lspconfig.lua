local on_attach = function(_, bufnr)
end

return {
	"neovim/nvim-lspconfig",
	dependencies = {
		"williamboman/mason.nvim",
		{ "williamboman/mason-lspconfig.nvim", config = function() end },
		{
			"folke/lazydev.nvim",
			ft = "lua", -- only load on lua files
			opts = {
				library = {
					-- See the configuration section for more details
					-- Load luvit types when the vim.uv word is found
					{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
				},
			},
		}
	},

	config = function()
		require("mason").setup()
		require("mason-lspconfig").setup()
		require("lspconfig").clangd.setup{}
		require("lspconfig").gopls.setup{}
		require("lspconfig").lua_ls.setup{}
	end
}

