local function map(mode, lhs, rhs, opts)
  -- set default value if not specify
  if opts.noremap == nil then
    opts.noremap = true
  end
  if opts.silent == nil then
    opts.silent = true
  end

  vim.keymap.set(mode, lhs, rhs, opts)
end

vim.g.mapleader = " "
vim.g.maplocalleader = " "

map("i", "jk", "<ESC>", {})

-- better up/down
local keymap = vim.keymap

keymap.set({ "n", "v" }, "j", function()
  return vim.v.count > 0 and "j" or "gj"
end, { expr = true })

keymap.set({ "n", "v" }, "k", function()
  return vim.v.count > 0 and "k" or "gk"
end, { expr = true})

-- better scrolling
map("n", "<C-u>", "<C-u>zz", {})
map("n", "<C-d>", "<C-d>zz", {})
map("n", "<C-b>", "<C-b>zz", {})
map("n", "<C-f>", "<C-f>zz", {})

-- leader mappings
map("n", "<leader>pv", vim.cmd.Ex, {})
map("n", "<leader>nh", ":nohl<CR>", {})
map("n", "<leader>s", ":so<CR>", {})
map("n", "<leader>+", "<C-a>", {})

map("n", "<leader>sv", "<C-w>v", {})
map("n", "<leader>sh", "<C-w>s", {})
map("n", "<leader>qq", ":q<CR>", {})

map("n", "<leader>to", ":tabnew<CR>", {})
map("n", "<leader>tx", ":tabclose<CR>", {})
map("n", "<leader>tn", ":tabn<CR>", {})
map("n", "<leader>tp", ":tabp<CR>", {})
map("n", "<leader>tf", ":tabnew %<CR>", {})
