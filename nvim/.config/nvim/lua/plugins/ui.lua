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
    dependencies = { "nvim-lualine/lualine.nvim" },
    config = function() 
      require("lualine").setup({
        options = {
          section_separators = '',
          component_separators = '',
        },
      })
    end,
  },
}
