-- telescope.nvim
return {
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
		dependencies = {
			"nvim-lua/plenary.nvim",
			{
				"nvim-telescope/telescope-fzf-native.nvim",
				build = "cmake -S. -Bbuild -DCMAKE_BUILD_TYPE=Release && cmake --build build --config Release",
			},
			"nvim-telescope/telescope-file-browser.nvim",
		},
		config = function()
			require("telescope").setup({
				extensions = {
					fzf = {
						fuzzy = true, -- false will only do exact matching
						override_generic_sorter = true, -- override the generic sorter
						override_file_sorter = true, -- override the file sorter
						case_mode = "smart_case",
					},
				},
				pickers = {
					colorscheme = {
						enable_preview = true,
					},
					find_files = {
						hidden = true,
						find_command = {
							"rg",
							"--files",
							"--glob",
							"!{.git/*,.next/*,.svelte-kit/*,target/*,node_modules/*}",
							"--path-separator",
							"/",
						},
					},
				},
			})

			require("telescope").load_extension("fzf")
			require("telescope").load_extension("zoxide")
			-- telescope setup
			local builtin = require("telescope.builtin")

			vim.keymap.set(
				"n",
				"<leader>fk",
				"<cmd>lua require'telescope.builtin'.find_files({ find_command = {'rg', '--files', '--hidden', '-g', '!.git' }})<cr>",
				{ desc = "current directory files" }
			)
			vim.keymap.set("n", "<leader>fb", ":Telescope file_browser<cr>", {})
			vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "live grep search" })
			vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "diagnostics" })
			vim.keymap.set("n", "<leader>fz", ":Telescope zoxide list<CR>", { desc = "Telescope zoxide" })
			vim.keymap.set("n", "<leader>fv", builtin.help_tags, { desc = "help_tags" })
			vim.keymap.set("n", "<leader>fw", builtin.grep_string, { desc = "[S]earch current [W]ord" })
			vim.keymap.set("n", "<leader>fs", builtin.resume, { desc = "Recents searches" })
			vim.keymap.set("n", "<leader>fr", function()
				builtin.oldfiles({
					cwd_only = true,
					prompt_title = "Recent Files in Project",
					layout_config = { width = 0.8, height = 0.8 },
				})
			end, { desc = "Recent Files" })
			vim.keymap.set("n", "<leader><leader>", builtin.buffers, { desc = "[ ] Find existing buffers" })
		end,
	},
	{
		"jvgrootveld/telescope-zoxide",
		config = function() end,
	},
	{
		"nvim-telescope/telescope-ui-select.nvim",
		config = function()
			require("telescope").setup({
				extensions = {
					["ui-select"] = {
						require("telescope.themes").get_dropdown({
							-- even more opts
						}),
					},
				},
			})
			-- To get ui-select loaded and working with telescope, you need to call
			-- load_extension, somewhere after setup function:
			require("telescope").load_extension("ui-select")
		end,
	},
}
