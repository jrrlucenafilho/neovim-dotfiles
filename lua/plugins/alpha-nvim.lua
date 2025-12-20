-- Greeter
return {
  "goolord/alpha-nvim",
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },

  config = function()
    local alpha = require("alpha")
    local dashboard = require("alpha.themes.dashboard")

    -- Load the custom header table once
    local custom_header = require("ui.headers.header_zooey_title_dragons")

    -- Overwrite the header section's content (val)
    dashboard.section.header.val = custom_header.val

    -- Overwrite the header section's options (opts) (for coloring)
    dashboard.section.header.opts = custom_header.opts

    -- Pass the type (text)
    dashboard.section.header.type = custom_header.type

    -- Dashboard buttons
    dashboard.section.buttons.val = {
      -- New file
      dashboard.button("n", "  New file", "<cmd>ene<CR>"),

      -- Find file
      dashboard.button("ff", "󰈞  Find file", "<cmd>lua require('telescope.builtin').find_files()<CR>"),

      -- Recently opened files
      dashboard.button(
        "r",
        "󰈚  Recently opened files",
        "<cmd>lua require('telescope.builtin').oldfiles()<CR>"
      ),

      -- Frecency / MRU (telescope-frecency)
      dashboard.button(
        "fr",
        "󰄉  Frecency / MRU",
        "<cmd>lua require('telescope').extensions.frecency.frecency()<CR>"
      ),

      -- Find word
      dashboard.button(
        "lg",
        "󰈬  Find word / Live grep",
        "<cmd>lua require('telescope.builtin').live_grep()<CR>"
      ),

      -- Jump to bookmarks (Telescope marks)
      dashboard.button("b", "󰃀  Jump to bookmarks", "<cmd>lua require('telescope.builtin').marks()<CR>"),

      -- Open session menu
      dashboard.button(
        "ss",
        "  Open session selection",
        "<cmd>lua require('persistence').select()<CR>"
      ),

      -- Open last session (persistence.nvim)
      dashboard.button(
        "ls",
        "󰁯  Open last session",
        "<cmd>lua require('persistence').load({ last = true })<CR>"
      ),

      -- Quit
      dashboard.button("q", "󰅖  Quit", "<cmd>qa<CR>"),
    }

    -- Finally, set it up
    alpha.setup(dashboard.config)
  end,
}
