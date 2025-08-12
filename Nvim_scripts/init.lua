require("core.globals")
require("core.options")

require("functions.autocommands").setup_yank_highlight()
require("functions.keymaps").setup()
-- Ensure lazy.nvim is installed and set up
require("setup_lazy").ensure_lazy()

-- Load icons and set up lazy.nvim
local icons = require("icons")
require("lazy").setup({
	{ import = "plugins" },
}, {
	ui = icons,
})
