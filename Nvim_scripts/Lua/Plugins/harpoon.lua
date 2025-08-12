return {
	"ThePrimeagen/harpoon",
	branch = "harpoon2",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = function()
		local harpoon = require("harpoon")

		-- Initialize Harpoon
		harpoon:setup()

		-- Keymaps for Harpoon
		vim.keymap.set("n", "<leader>a", function()
			harpoon:list():add()
		end, { desc = "Harpoon: Add file to list" })
		vim.keymap.set("n", "<leader>fh", function()
			harpoon.ui:toggle_quick_menu(harpoon:list())
		end, { desc = "Harpoon: Toggle quick menu" })
		vim.keymap.set("n", "<C-r>", function()
			harpoon:list():remove()
		end, { desc = "Harpoon: Remove current file from list" })
	end,
}
