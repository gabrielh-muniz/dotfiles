-- change default netrw settings
-- vim.g.netrw_liststyle   = 3
-- vim.g.netrw_banner      = 0
-- vim.g.netrw_bufsettings = "noma nomod nu rnu nowrap ro nobl"

local opt = vim.opt

-- line numbers
opt.relativenumber = true
opt.number = true
opt.scrolloff = 10

-- tabs & indentation
opt.tabstop = 2
opt.shiftwidth = 2
opt.expandtab = true
opt.autoindent = true
opt.smartindent = true

-- search
opt.ignorecase = true
opt.smartcase = true
opt.incsearch = true

-- window
opt.splitright = true
opt.splitbelow = true

-- update & timeout
opt.updatetime = 250
opt.timeoutlen = 300

opt.termguicolors = true

-- opt.clipboard:append("unnamedplus")

opt.swapfile = false
opt.backup = false

opt.list = true
opt.listchars = { space = "⋅", eol = "↲" }

opt.signcolumn = "number"
