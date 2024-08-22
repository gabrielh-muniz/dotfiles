local ignore_patterns = {
  "__pycache__",
  "%.aux$",
  "%.lof$",
  "%.log$",
  "%.fls$",
  "%.out$",
  "%.toc$",
  "%.fmt$",
  "%.fot$",
  "%.cb$",
  "%.cb2$",
  "%.synctex.gz$",
  "%.fdb_latexmk$",
  "%.pdf$",
  "%.pdf_tex$",
  "%.eps_tex$",
  "%.eps$",
}

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
          for _, pattern in ipairs(ignore_patterns) do
            if name:match(pattern) then
              return true
            end
          end
					return false
				end,
			},
		})

		vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" })
	end,
}
