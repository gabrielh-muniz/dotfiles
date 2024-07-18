return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
  },
  config = function()
    local status_ok_telescope, telescope = pcall(require, "telescope")
    local status_ok_actions, actions = pcall(require, "telescope.actions")

    if not status_ok_telescope then
      print("Error on loading telescope")
      return
    end

    if not status_ok_actions then
      print("Error on loading telescope actions submodule")
      return
    end

    telescope.setup({
			defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + actions.open_qflist,
          },
        },
      },
    })

    telescope.load_extension("fzf")

	  local builtin = require "telescope.builtin"

    vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]uzzy [F]ind" })
    vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [R]ecent" })
    vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "[F]ind [S]tring" })
    vim.keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "[F]ind string under [C]ursor" })
    vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })

  end,
}
