return {
	"nvim-lualine/lualine.nvim",
	config = function()
		-- Define a function to show diagnostics in a floating window
		local function show_diagnostic_float()
			vim.diagnostic.open_float(nil, { scope = "cursor", border = "rounded" })
		end

		-- Custom component to show LSP status (active server names)
		local function lsp_status()
			local clients = vim.lsp.get_clients({ bufnr = 0 })
			if next(clients) == nil then
				return "No LSP"
			end
			local names = {}
			for _, client in ipairs(clients) do
				table.insert(names, client.name)
			end
			return "LSP: " .. table.concat(names, ", ")
		end

		require("lualine").setup({
			options = {
				icons_enabled = true,
				theme = "auto",
				component_separators = { left = "", right = "" },
				section_separators = { left = "", right = "" },
				disabled_filetypes = {
					statusline = {},
					winbar = {},
				},
				ignore_focus = {},
				always_divide_middle = true,
				always_show_tabline = true,
				globalstatus = false,
				refresh = {
					statusline = 100,
					tabline = 100,
					winbar = 100,
				},
			},
			sections = {
				lualine_a = { "mode" },
				lualine_b = {
					"diff",
					{
						"diagnostics",
						sources = { "nvim_lsp" },
						sections = { "error" },
						on_click = function()
							show_diagnostic_float()
						end,
						symbols = { error = " " },
					},
					{ lsp_status },
				},
				lualine_c = {
					{
						"filename",
						path = 0,
						shorting_target = 40,
						symbols = {
							modified = "[+]",
							readonly = "[-]",
							unnamed = "[No Name]",
						},
					},
				},
				lualine_x = { "encoding", "fileformat", "filetype" },
				lualine_y = { "progress" },
				lualine_z = { "location" },
			},
			inactive_sections = {
				lualine_a = {},
				lualine_b = {},
				lualine_c = {
					{
						"filename",
						path = 0,
						shorting_target = 40,
						symbols = {
							modified = "[+]",
							readonly = "[-]",
							unnamed = "[No Name]",
						},
					},
				},
				lualine_x = { "location" },
				lualine_y = {},
				lualine_z = {},
			},
			tabline = {},
			winbar = {},
			inactive_winbar = {},
			extensions = {},
		})
	end,
}
