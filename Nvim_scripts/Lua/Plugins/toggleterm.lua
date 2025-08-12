return {
	"akinsho/toggleterm.nvim",
	version = "*",
	config = function()
		require("toggleterm").setup({
			open_mapping = [[<leader>t]], -- Keybinding to toggle terminal
			direction = "tab", -- Opens in a new tab, which acts like a full-screen window
			shade_terminals = true,
		})
		-- Optional: Exit terminal mode with Esc for easier toggling
		vim.keymap.set("t", "<Esc>", [[<C-\><C-n>]], { desc = "Exit terminal mode" })
		-- Optional: Toggle back to previous buffer
		vim.keymap.set("t", "<leader>t", [[<C-\><C-n>:b#<CR>]], { desc = "Toggle back to previous buffer" })
	end,
}
