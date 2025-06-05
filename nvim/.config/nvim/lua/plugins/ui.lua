---@alias VimModeDisplay string  -- e.g. "NORMAL", "INSERT", etc.
---@alias ShortMode string       -- e.g. "N", "I", etc.
---@type table<VimModeDisplay, ShortMode>
local short_mode = {
  ['NORMAL']   = 'N',
  ['INSERT']   = 'I',
  ['VISUAL']   = 'V',
  ['V-LINE']   = 'V-L',
  ['V-BLOCK']  = 'V-B',
  ['REPLACE']  = 'R',
  ['COMMAND']  = 'C',
  ['TERMINAL'] = 'T',
  ['SELECT']   = 'S',
  ['S-LINE']   = 'S-L',
  ['S-BLOCK']  = 'S-B',
  ['EX']       = 'Ex',
  ['SHELL']    = '!',
}

---@return string
local cp_status = function()
    if vim.fn.mode() ~= "i" then return "" end

    for _, client in pairs(vim.lsp.get_clients({ bufnr = 0 })) do
        if client.name == "copilot" then return "%#CopilotActive#" end
    end
    return "%#CopilotInactive#"
end

return {
  {
    "ellisonleao/gruvbox.nvim",
    priority = 1000,
    config = function()
      require("gruvbox").setup({
        transparent_mode = true,
      })

      vim.cmd.colorscheme "gruvbox"
      vim.api.nvim_set_hl(0, "NormalFloat", { bg = "#1d2021", }) 
      vim.api.nvim_set_hl(0, "CopilotActive", { fg = "#98971a", bg = "NONE"  })
      vim.api.nvim_set_hl(0, "CopilotInactive", { fg = "#ebdbb2", bg = "NONE" })
    end,
  },
  {
		"nvim-lualine/lualine.nvim",
		dependencies = { "nvim-tree/nvim-web-devicons" },
		config = function()
			local lazy_status = require("lazy.status")
      --[[ 
			local lsp_clients = function()
				local clients = vim.lsp.get_clients()
				if next(clients) == nil then
					return ""
				end

				return clients[1].name
			end
      ]]

			require("lualine").setup({
				options = {
					section_separators = "",
					component_separators = "",
				},
				sections = {
          lualine_a = {
            { "mode", fmt = function(str) return short_mode[str] or str end },
          },
          lualine_b = {
            { "branch", icon = "" },
            { "diff", },
          },
          lualine_c = {
          {
            "filename",
            symbols = {
              modified = "",
              readonly = "󰈡",
            },
          },
          },
					lualine_x = {
						{
							lazy_status.updates,
							cond = lazy_status.has_updates,
							color = { fg = "#D79921" },
						},
						-- { lsp_clients },
            { cp_status },
            { "diagnostics", },
            {
              "lsp_status",
              icon = '',
              symbols = {
                spinner = { '⠋', '⠙', '⠹', '⠸', '⠼', '⠴', '⠦', '⠧', '⠇', '⠏' },
                done = '✓',
                separator = ' ',
              },
              ignore_lsp = { "copilot" },
            },
            {
              "filetype",
              colored = true,
              icon_only = true,
            },
					},
				},
			})
		end,
	},
}
