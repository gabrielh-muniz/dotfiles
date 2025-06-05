return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {
					ui = {
						icons = {
							package_installed = "✓",
							package_pending = "➜",
							package_uninstalled = "✗",
						},
					},
				},
			},
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
					end

					map("K", vim.lsp.buf.hover, "Hover")
					map("<Leader>gD", vim.lsp.buf.definition, "Goto definition")
					map("<Leader>gd", vim.lsp.buf.declaration, "Goto declaration")
					map("<Leader>gr", vim.lsp.buf.references, "Goto references")
					map("<Leader>ca", vim.lsp.buf.code_action, "Code Action", { "n", "x" })
					map("<Leader>rn", vim.lsp.buf.rename, "Rename symbol")
					map("<Leader>g0", vim.lsp.buf.document_symbol, "Document Symbol")

					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, { bufnr = bufnr })
						end
					end

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup =
							vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
							end,
						})
					end

					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			vim.diagnostic.config({
				severity_sort = true,
				float = { border = "rounded", source = "if_many" },
				underline = { severity = vim.diagnostic.severity.ERROR },
				signs = false,
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {
				-- clangd = {},
				-- gopls = {},
				-- pyright = {},
				-- rust_analyzer = {},
				-- ... etc. See `:help lspconfig-all` for a list of all the pre-configured LSPs
				--
				-- Some languages (like typescript) have entire language plugins that can be useful:
				--    https://github.com/pmizio/typescript-tools.nvim
				--
				-- But for many setups, the LSP (`ts_ls`) will work just fine
				-- ts_ls = {},
				--
				lua_ls = {
					cmd = { "lua-language-server" },
					filetypes = { "lua" },
					capabilities = capabilities,
					root_markers = { ".luarc.json", ".luarc.jsonc" },
					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
							-- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
							diagnostics = { disable = { "missing-fields" }, globals = { "vim" } },
						},
					},
				},
				bashls = {
					cmd = { "bash-language-server", "start" },
					capabilities = capabilities,
					filetypes = { "bash", "sh" },
					root_markers = { ".git" },
					single_file_support = true,
				},
				dockerls = {
					cmd = { "docker-langserver", "--stdio" },
					capabilities = capabilities,
					filetypes = {
						"dockerfile",
						"dockerfile.vim",
						"dockerfile.dockerfile",
						"dockerfile.docker",
						"dockerfile.docker-compose",
					},
					root_markers = { ".git", ".dockerignore", "Dockerfile" },
					single_file_support = true,
				},
				tailwindcss = {
					cmd = { "tailwindcss-language-server", "--stdio" },
					filetypes = {
						"astro",
						"css",
						"html",
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"json",
						"markdown",
						"markdown.mdx",
						"postcss",
						"scss",
						"svelte",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
					},
					settings = {
						tailwindCSS = {
							validate = true,
							lint = {
								cssConflict = "warning",
								invalidApply = "error",
								invalidScreen = "error",
								invalidVariant = "error",
								invalidConfigPath = "error",
								invalidTailwindDirective = "error",
								recommendedVariantOrder = "warning",
							},
							classAttributes = {
								"class",
								"className",
								"class:list",
								"classList",
								"ngClass",
							},
							includeLanguages = {
								eelixir = "html-eex",
								eruby = "erb",
								templ = "html",
								htmlangular = "html",
							},
						},
					},
					root_markers = {
						"tailwind.config.js",
						"tailwind.config.cjs",
						"tailwind.config.mjs",
						"tailwind.config.ts",
						"postcss.config.js",
						"postcss.config.cjs",
						"postcss.config.mjs",
						"postcss.config.ts",
						"vite.config.js",
					},
				},
				ts_ls = {
					init_options = { hostInfo = "neovim" },
					cmd = { "typescript-language-server", "--stdio" },
					capabilities = capabilities,
					filetypes = {
						"javascript",
						"javascriptreact",
						"javascript.jsx",
						"typescript",
						"typescriptreact",
						"typescript.tsx",
					},
					root_markers = { "tsconfig.json", "jsconfig.json", "package.json", ".git" },
					single_file_support = true,
				},
			}

			-- Ensure the servers and tools above are installed
			--
			-- To check the current status of installed tools and/or manually install
			-- other tools, you can run
			--    :Mason
			--
			-- You can press `g?` for help in this menu.
			--
			-- `mason` had to be setup earlier: to configure its options see the
			-- `dependencies` table for `nvim-lspconfig` above.
			--
			-- You can add other tools here that you want Mason to install
			-- for you, so that they are available from within Neovim.
			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
				"prettier",
				"eslint_d",
			})
			require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}
						-- This handles overriding only values explicitly passed
						-- by the server configuration above. Useful when disabling
						-- certain features of an LSP (for example, turning off formatting for ts_ls)
						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		config = function()
			require("copilot").setup({
				seggestion = { enabled = false },
				panel = { enabled = false },
			})
		end,
	},
	{
		"saghen/blink.cmp",
		dependencies = { "rafamadriz/friendly-snippets", "fang2hou/blink-copilot" },
		version = "1.*",
		event = "InsertEnter",

		---@module "blink.cmp"
		---@type blink.cmp.Config
		opts = {
			keymap = {
				preset = "super-tab",

				["<C-j>"] = { "select_next" },
				["<C-k>"] = { "select_prev" },
			},
			appearance = {
				nerd_font_variant = "mono",
			},
			completion = {
				accept = { auto_brackets = { enabled = true } },
				documentation = { auto_show = true, auto_show_delay_ms = 500 },
				ghost_text = { enabled = true },
				menu = {
					draw = {
						columns = {
							{ "kind_icon", "label", "label_description", gap = 1 },
							{ "kind", "source_name", gap = 1 },
						},
					},
				},
			},
			sources = {
				default = { "lazydev", "lsp", "copilot", "path", "snippets", "buffer" },
				providers = {
					lazydev = {
						name = "LazyDev",
						module = "lazydev.integrations.blink",
						-- make lazydev completions top priority (see `:h blink.cmp`)
						score_offset = 100,
					},
					copilot = {
						name = "copilot",
						module = "blink-copilot",
						score_offset = 100,
						async = true,
					},
				},
			},
			fuzzy = { implementation = "prefer_rust_with_warning" },
			--signature = { enabled = true },
		},
		opts_extend = { "sources.default" },
	},
	{
		"windwp/nvim-autopairs",
		event = "InsertEnter",
		config = function()
			require("nvim-autopairs").setup({
				check_ts = true,
			})

			-- add spaces between sings
			-- from documentation
			local Rule = require("nvim-autopairs.rule")
			local cond = require("nvim-autopairs.conds")
			local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }

			require("nvim-autopairs").add_rules({
				Rule(" ", " ")
					-- Pair will only occur if the conditional function returns true
					:with_pair(function(opts)
						-- We are checking if we are inserting a space in (), [], or {}
						local pair = opts.line:sub(opts.col - 1, opts.col)
						return vim.tbl_contains({
							brackets[1][1] .. brackets[1][2],
							brackets[2][1] .. brackets[2][2],
							brackets[3][1] .. brackets[3][2],
						}, pair)
					end)
					:with_move(cond.none())
					:with_cr(cond.none())
					-- We only want to delete the pair of spaces when the cursor is as such: ( | )
					:with_del(
						function(opts)
							local col = vim.api.nvim_win_get_cursor(0)[2]
							local context = opts.line:sub(col - 1, col + 2)
							return vim.tbl_contains({
								brackets[1][1] .. "  " .. brackets[1][2],
								brackets[2][1] .. "  " .. brackets[2][2],
								brackets[3][1] .. "  " .. brackets[3][2],
							}, context)
						end
					),
			})
			for _, bracket in pairs(brackets) do
				require("nvim-autopairs").add_rules({
					-- Each of these rules is for a pair with left-side '( ' and right-side ' )' for each bracket type
					Rule(bracket[1] .. " ", " " .. bracket[2])
						:with_pair(cond.none())
						:with_move(function(opts)
							return opts.char == bracket[2]
						end)
						:with_del(cond.none())
						:use_key(bracket[2])
						-- Removes the trailing whitespace that can occur without this
						:replace_map_cr(function(_)
							return "<C-c>2xi<CR><C-c>O"
						end),
				})
			end
		end,
	},
	{
		"windwp/nvim-ts-autotag",
		event = { "BufReadPre", "BufNewFile" },
		opts = {},
	},
}
