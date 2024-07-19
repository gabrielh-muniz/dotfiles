return {
  "nvim-treesitter/nvim-treesitter",
  event = { "BufReadPre", "BufNewFile" },
  build = ":TSUpdate", -- execute whenever the plugin is updated or installed
  dependencies = {
    "windwp/nvim-ts-autotag",
  },
  config = function()
    local status_ok, treesitter = pcall(require, "nvim-treesitter.configs")
    if not status_ok then
      print("Error on loading treesitter module")
      return
    end
    
    treesitter.setup({
      highlight = { -- enable syntax highlight
        enable = true,
      },
      indent = { enable = true }, -- enable better indentation
      autotag = {
        enable = true,
      },
      -- language parsers to be installed
      ensure_installed = {
        "json",
        "javascript",
        "html",
        "css",
        "markdown",
        "markdown_inline",
        "bash",
        "lua",
        "vim",
        "gitignore",
        "vimdoc",
        "c",
        "cpp",
        "python",
        "sql",
        "make",
      },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
    
  end,
}
