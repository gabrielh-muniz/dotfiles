local function map(mode, lhs, rhs, opts)
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
map("v", "jk", "<ESC>", {})

local keymap = vim.keymap
keymap.set({ "n", "v" }, "j", function()
  return vim.v.count > 0 and "j" or "gj"
end, { expr = true })

keymap.set({ "n", "v" }, "k", function()
  return vim.v.count > 0 and "k" or "gk"
end, { expr = true})

map("n", "<C-u>", "<C-u>zz", {})
map("n", "<C-d>", "<C-d>zz", {})

map("n", "<leader>pv", vim.cmd.Ex, {})
map("n", "<leader>nh", ":nohl<CR>", {})
map("n", "<leader>+", "<C-a>", {})

map("n", "<leader>sv", "<C-w>v", {})
map("n", "<leader>sh", "<C-w>s", {})
map("n", "<leader>qq", ":q<CR>", {})

map("n", "<leader>to", ":tabnew<CR>", {})
map("n", "<leader>tx", ":tabclose<CR>", {})
map("n", "<leader>tn", ":tabn<CR>", {})
map("n", "<leader>tp", ":tabp<CR>", {})
map("n", "<leader>tf", ":tabnew %<CR>", {})

map("v", "J", ":m '>+1<CR>gv=gv", {})
map("v", "K", ":m '<-2<CR>gv=gv", {})

map("n", "n", "nzzzv", {})
map("n", "N", "Nzzzv", {})

map("x", "<leader>p", "\"_dP", {})

map({"n", "v"}, "<leader>y", [["+y]], {})
map("n", "<leader>Y", [["+Y]], {})

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {})

map("v", "<", "<gv", {})
map("v", ">", ">gv", {})
