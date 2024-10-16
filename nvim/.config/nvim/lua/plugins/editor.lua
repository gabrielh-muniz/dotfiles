local ignore_patterns = {
	"__pycache__",
	"%.aux$",
	"%.lof$",
	"%.log$",
	"%.fls$",
	"%.out$",
	"%.toc$",
	"%.fmt$",
	"%.fot$",
	"%.cb$",
	"%.cb2$",
	"%.synctex.gz$",
	"%.fdb_latexmk$",
	"%.pdf$",
	"%.pdf_tex$",
	"%.eps_tex$",
	"%.eps$",
}

return {
	{
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

			vim.keymap.set("n", "<leader>a", function()
				harpoon:list():add()
			end)
			vim.keymap.set("n", "<leader>hm", function()
				harpoon.ui:toggle_quick_menu(harpoon:list())
			end)

			for i = 1, 5 do
				vim.keymap.set("n", "<leader>" .. i, function()
					harpoon:list():select(1)
				end, { desc = "Harpoon to File " .. i })
			end
		end,
	},
	{
		"RRethy/vim-illuminate",
		event = "VeryLazy",
		config = function()
			require("illuminate").configure({
				delay = 200,
				large_file_cutoff = 2000,
				large_file_overrides = {
					providers = { "lsp" },
				},
			})
			local function map(key, dir, buffer)
				vim.keymap.set("n", key, function()
					require("illuminate")["goto_" .. dir .. "_reference"](false)
				end, { desc = dir:sub(1, 1):upper() .. dir:sub(2) .. " Reference", buffer = buffer })
			end

			map("]]", "next")
			map("[[", "prev")

			vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = "#504945" })
			vim.api.nvim_set_hl(0, "IlluminateWordRead", { bg = "#504945" })
			vim.api.nvim_set_hl(0, "IlluminateWord", { bg = "#504945" })
			vim.api.nvim_set_hl(0, "IlluminateCurWord", { bg = "#504945" })
		end,
		keys = {
			{ "]]", desc = "Next Reference" },
			{ "[[", desc = "Prev Reference" },
		},
	},
	{
		"stevearc/oil.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			require("oil").setup({
				columns = { "icon" },
				keymaps = {
					["<C-h>"] = false,
					["<M-h>"] = "actions.select_split",
				},
				view_options = {
					show_hidden = false,
					is_hidden_file = function(name, _)
						for _, pattern in ipairs(ignore_patterns) do
							if name:match(pattern) then
								return true
							end
						end
						return false
					end,
				},
			})
			vim.keymap.set("n", "<leader>pv", "<CMD>Oil<CR>", { desc = "Open parent directory" })
		end,
	},
	{
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

			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "[F]uzzy [F]ind" })
			vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "[F]ind [R]ecent" })
			vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "[F]ind [S]tring" })
			vim.keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "[F]ind string under [C]ursor" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
			vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find TODOS" })
		end,
	},
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate", -- execute whenever the plugin is updated or installed
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
				-- language parsers to be installed
				ensure_installed = {
					"dart",
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
					"go",
					"vimdoc",
					"c",
					"cpp",
					"python",
					"sql",
					"make",
					"yaml",
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
	},
	{
		"folke/trouble.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		opts = {
			focus = true,
		},
		cmd = "Trouble",
		keys = {
			{ "<leader>tt", "<cmd>Trouble diagnostics toggle<CR>", desc = "Open trouble workspace diagnostics" },
			{
				"<leader>td",
				"<cmd>Trouble diagnostics toggle filter.buf=0<CR>",
				desc = "Open trouble document diagnostics",
			},
			{ "<leader>tq", "<cmd>Trouble quickfix toggle<CR>", desc = "Open trouble quickfix list" },
			{ "<leader>tl", "<cmd>Trouble loclist toggle<CR>", desc = "Open trouble location list" },
			{ "<leader>tdo", "<cmd>Trouble todo toggle<CR>", desc = "Open todos in trouble" },
		},
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			require("conform").setup({
				formatters_by_ft = {
					lua = { "stylua" },
					python = { "isort", "black" },
					go = { "gofmt" },
				},
				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				},
			})
			-- format a snippet, if on v mode
			vim.keymap.set({ "n", "v" }, "<leader>mp", function()
				require("conform").format({
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				})
			end, { desc = "Format file or range (in v mode)" })
		end,
	},
	{
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
	},
	{
		"hedyhli/outline.nvim",
		dependencies = { "onsails/lspkind.nvim" },
		lazy = true,
		cmd = { "Outline", "OutlineOpen" },
		keys = { -- Example mapping to toggle outline
			{ "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
		},
		opts = {
			outline_window = {
				position = "left",
			},
			symbols = {
				icon_source = "lspkind",
			},
		},
	},
}
