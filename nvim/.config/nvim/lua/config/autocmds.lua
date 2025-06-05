local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local highlight_on_yank = augroup("HighlightOnYank", { clear = true })
autocmd("TextYankPost", {
	group = highlight_on_yank,
	pattern = "*",
	desc = "Briefly highlight yanked text",
	callback = function()
		vim.highlight.on_yank({
			higroup = "Visual",
			timeout = 500,
		})
	end,
})

