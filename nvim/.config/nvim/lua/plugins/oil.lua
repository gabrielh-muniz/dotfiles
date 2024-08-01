return {
	"stevearc/oil.nvim",
	dependencies = { "nvim-tree/nvim-web-devicons" },
	config = function()
		require("oil").setup({
			columns = { "icon" },
			keymaps = {
				["<C-h>"] = false,
				["<M-h>"] = "actions.select_split",
			},
			view_options = {
				show_hidden = false,
				is_hidden_file = function(name, _)
					if name:match("__pycache__") then
						return true
					end
					return false
				end,
			},
		})

		vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
