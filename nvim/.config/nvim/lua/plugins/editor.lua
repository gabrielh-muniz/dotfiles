local ignore_patterns = {
	"__pycache__",
}

return {
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
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		build = ":TSUpdate",
		config = function()
			---@diagnostic disable-next-line: missing-fields
			require("nvim-treesitter.configs").setup({
				highlight = { -- enable syntax highlight
					enable = true,
				},
				sync_install = false,
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
					"astro",
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
		"nvim-telescope/telescope.nvim",
		branch = "0.1.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
			"nvim-tree/nvim-web-devicons",
			"nvim-telescope/telescope-ui-select.nvim",
		},
		config = function()
			local telescope = require("telescope")
			local actions = require("telescope.actions")

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
					extensions = {
						["ui-select"] = {
							require("telescope.themes").get_dropdown({}),
						},
					},
					file_ignore_patterns = { "node_modules" },
				},
			})

			telescope.load_extension("fzf")
			telescope.load_extension("ui-select")

			local builtin = require("telescope.builtin")

			vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Fuzzy find" })
			vim.keymap.set("n", "<leader>fr", builtin.oldfiles, { desc = "Fin recent" })
			vim.keymap.set("n", "<leader>fs", builtin.live_grep, { desc = "Find string" })
			vim.keymap.set("n", "<leader>fc", builtin.grep_string, { desc = "Find string under cursor" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "Find existing buffers" })
			vim.keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<CR>", { desc = "Find TODOS" })
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find diagnostics" })
		end,
	},
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		config = function()
			local todo_comments = require("todo-comments")

			local keymap = vim.keymap

			keymap.set("n", "]t", function()
				todo_comments.jump_next()
			end, { desc = "Next todo comment" })

			keymap.set("n", "[t", function()
				todo_comments.jump_prev()
			end, { desc = "Previous todo comment" })

			todo_comments.setup()
		end,
	},
	{
		"stevearc/conform.nvim",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					javascript = { "prettier" },
					typescript = { "prettier" },
					javascriptreact = { "prettier" },
					typescriptreact = { "prettier" },
					css = { "prettier" },
					html = { "prettier" },
					json = { "prettier" },
					lua = { "stylua" },
				},
				format_on_save = {
					lsp_format = "fallback",
					timeout_ms = 1000,
				},
			})

			-- format a selected range
			vim.keymap.set("v", "<leader>f", function()
				conform.format({
					lsp_format = "fallback",
					timeout_ms = 1000,
				})
			end, { desc = "Format range in VISUAL mode" })
		end,
	},
	{
		"brenoprata10/nvim-highlight-colors",
		config = function()
			require("nvim-highlight-colors").setup({
				---Render style
				---@usage 'background'|'foreground'|'virtual'
				render = "virtual",

				---Set virtual symbol (requires render to be set to "virtual")
				virtual_symbol = "■",
			})
		end,
		-- TODO: add blink cmp integration
	},
	{
		"mfussenegger/nvim-lint",
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local lint = require("lint")

			lint.linters_by_ft = {
				javascript = { "eslint_d" },
				typescript = { "eslint_d" },
				javascriptreact = { "eslint_d" },
				typescriptreact = { "eslint_d" },
			}

			local lint_augroup = vim.api.nvim_create_augroup("LintOnSave", { clear = true })
			vim.api.nvim_create_autocmd("BufWritePost", {
				group = lint_augroup,
				callback = function()
					lint.try_lint()
				end,
			})
		end,
	},
	{
		"j-hui/fidget.nvim",
		tag = "v1.6.1",
		opts = {
			notification = {
				window = {
					winblend = 0, -- make the fidget window opaque
				},
			},
		},
	},
	{
		"lewis6991/gitsigns.nvim",
		config = function()
			require("gitsigns").setup({
				signs = {
					add = { text = "+" },
					change = { text = "*" },
					delete = { text = "-" },
					topdelete = { text = "‾" },
					changedelete = { text = "~" },
					untracked = { text = "┆" },
				},
			})
		end,
	},
}
