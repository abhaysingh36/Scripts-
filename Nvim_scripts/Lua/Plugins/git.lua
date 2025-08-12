-- Git and editing enhancements
return {
  -- Detect tabstop and shiftwidth automatically
  "tpope/vim-sleuth",

  -- Commenting functionality
  { "tpope/vim-commentary" },

  -- Git integration with signs
  {
    "lewis6991/gitsigns.nvim",
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
        topdelete = { text = "‾" },
        changedelete = { text = "~" },
      },
    },
  },
}