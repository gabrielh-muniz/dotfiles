return {
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
}
