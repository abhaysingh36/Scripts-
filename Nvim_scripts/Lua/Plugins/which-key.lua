return {
	{
		"folke/which-key.nvim",
		event = "VimEnter",
		opts = {
			preset = "helix",
			plugins = {
				marks = false,
				operators = false,
				windows = false,
				nav = false,
			},
			icons = {
				mappings = vim.g.have_nerd_font,
				keys = vim.g.have_nerd_font and {} or {
					Up = "<Up> ",
					Down = "<Down> ",
					Left = "<Left> ",
					Right = "<Right> ",
					C = "<C-",
					M = "<M-",
					D = "<D-",
					S = "<S-",
					CR = "<CR> ",
					Esc = "<Esc> ",
					ScrollWheelDown = "<ScrollWheelDown> ",
					ScrollWheelUp = "<ScrollWheelUp> ",
					NL = "<NL> ",
					BS = "<BS> ",
					Space = "<Space> ",
					Tab = "<Tab> ",
					F1 = "<F1>",
					F2 = "<F2>",
					F3 = "<F3>",
					F4 = "<F4>",
					F5 = "<F5>",
					F6 = "<F6>",
					F7 = "<F7>",
					F8 = "<F8>",
					F9 = "<F9>",
					F10 = "<F10>",
					F11 = "<F11>",
					F12 = "<F12>",
				},
			},
			win = {
				padding = { 0, 1 },
				title = false,
				border = "none",
				width = 40, -- Optional: Set a fixed width for the popup
			},
			layout = {
				align = "right", -- Align to the right edge
				position = "top", -- Place at the top (for top-right corner)
				relative = "editor", -- Position relative to the entire editor window
				-- Optional: Add offsets if needed
				x = -2, -- Small negative offset from the right edge
				y = 10, -- Small offset from the top
			},
			-- Document existing key chains
			spec = {
				{ "<leader>c", group = "[C]ode", mode = { "n", "x" } },
				{ "<leader>s", group = "[S]earch", mode = "n" },
				{ "<leader>f", group = "[F]ind", mode = "n" },
			},
		},
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			-- Register additional mappings not covered by spec
		end,
	},
}
