return {
  "ThePrimeagen/harpoon",
  event = "VeryLazy",
  branch = "harpoon2",
  config = function() 
    local status_ok, harpoon = pcall(require, "harpoon")
    if not status_ok then
      print("Error on loading harpoon module")
      return
    end

    harpoon:setup()

    vim.keymap.set("n", "<leader>a", function() harpoon:list():add() end)
    vim.keymap.set("n", "<leader>hm", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

    vim.keymap.set("n", "<leader>kk", function() harpoon:list():select(1) end)
    vim.keymap.set("n", "<leader>jj", function() harpoon:list():select(2) end)

  end,
}
