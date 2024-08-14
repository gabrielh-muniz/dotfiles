local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

local group = augroup("highlight_onyank", { clear = true })
autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "Visual", timeout = 500 })
	end,
	desc = "Highlight selection on yank",
	group = group,
	pattern = "*",
})
