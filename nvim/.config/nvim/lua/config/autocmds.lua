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

-- Hot reload
local dart_group = augroup("DartTools", { clear = true })
autocmd({ "BufWritePost" }, {
	group = dart_group,
	pattern = { "*.dart" },
	callback = function()
		os.execute("pgrep -f -o '[f]lutter_tool.*run' | xargs kill -s USR1")
	end,
})
