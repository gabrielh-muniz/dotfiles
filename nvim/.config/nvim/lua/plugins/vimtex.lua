return {
	"lervag/vimtex",
	lazy = false,
	init = function()
		vim.g.vimtex_compiler_method = "latexmk"
		vim.g.vimtex_compiler_latexmk = {
			callback = 1,
			continuos = 1,
			executable = "latexmk",
			options = {
				"-shell-escape",
				"-verbose",
				"-file-line-error",
				"-synctex=1",
				"-interaction=nonstopmode",
			},
		}
		vim.g.vimtex_view_method = "zathura"
		-- do not open pdf viewer on compile
		vim.g.vimtex_view_automatic = 0
		-- external pdf viewer
		vim.g.vimtex_context_pdf_viewer = "okular"
	end,
}
