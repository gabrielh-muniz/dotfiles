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

local function smart_move(x, y)
    vim.keymap.set({ "n", "v" }, x, function()
        return vim.v.count > 0 and x or y
    end, { expr = true })
end

smart_move("j", "gj")
smart_move("k", "gk")

map("n", "<C-u>", "<C-u>zz", {})
map("n", "<C-d>", "<C-d>zz", {})

map("n", "<leader>nh", ":nohl<CR>", {})

map("n", "<leader>sv", "<C-w>v", {})
map("n", "<leader>sh", "<C-w>s", {})
map("n", "<leader>qq", ":q<CR>", {})

map("v", "J", ":m '>+1<CR>gv=gv", {})
map("v", "K", ":m '<-2<CR>gv=gv", {})

map("x", "<leader>p", '"_dP', {})

map({ "n", "v" }, "<leader>y", [["+y]], {})

map("n", "<leader>s", [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]], {})

map("v", "<", "<gv", {})
map("v", ">", ">gv", {})

