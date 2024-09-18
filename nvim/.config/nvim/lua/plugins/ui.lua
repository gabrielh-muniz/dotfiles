return {
	{
		"ellisonleao/gruvbox.nvim",
		priority = 1000,
		config = function()
			local status_ok, gruvbox = pcall(require, "gruvbox")
			if not status_ok then
				print("Error on loading gruvbox module")
				return
			end

			gruvbox.setup({
				bold = true,
				italic = {
					strings = false,
					comments = false,
				},
			})

			vim.cmd("colorscheme gruvbox")
		end,
	},
	{
		"lukas-reineke/indent-blankline.nvim",
		event = { "BufReadPre", "BufNewFile" },
		main = "ibl",
		opts = {
			indent = { char = "┊" },
		},
	},
	{
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local lazy_status = require("lazy.status")

			local lsp_clients = function()
				local clients = vim.lsp.get_clients()
				if next(clients) == nil then
					return ""
				end

				return clients[1].name
			end

			require("lualine").setup({
				options = {
					section_separators = "",
					component_separators = "",
				},
				sections = {
					lualine_x = {
						{
							lazy_status.updates,
							cond = lazy_status.has_updates,
						},
						{ lsp_clients, icon = "" },
						{ "encoding" },
						{ "fileformat" },
						{ "filetype" },
					},
				},
			})
		end,
	},
}
