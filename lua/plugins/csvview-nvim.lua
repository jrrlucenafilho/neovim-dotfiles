-- Csv viewing and processing
return {
  ---@module "csvview"
  ---@type CsvView.Options
  "hat0uma/csvview.nvim",
  ft = { "csv", "tsv" },
  fallbacks = { ",", "\t", ";", "|", ":", " " },
  opts = {
    view = {
      enable = true,
    },
    parser = { comments = { "#", "//" } },
    keymaps = {
      -- Text objects for selecting fields
      textobject_field_inner = { "if", mode = { "o", "x" } },
      textobject_field_outer = { "af", mode = { "o", "x" } },
      -- Excel-like navigation:
      -- Use <Tab> and <S-Tab> to move horizontally between fields.
      -- Use <Enter> and <S-Enter> to move vertically between rows and place the cursor at the end of the field.
      -- Note: In terminals, you may need to enable CSI-u mode to use <S-Tab> and <S-Enter>.
      jump_next_field_end = { "<Tab>", mode = { "n", "v" } },
      jump_prev_field_end = { "<S-Tab>", mode = { "n", "v" } },
      jump_next_row = { "<Enter>", mode = { "n", "v" } },
      jump_prev_row = { "<S-Enter>", mode = { "n", "v" } },
    },
  },
  cmd = { "CsvViewEnable", "CsvViewDisable", "CsvViewToggle" },

  config = function()
    -- Autocmd so it auto-loads on csv files
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "csv",
      callback = function()
        vim.cmd("CsvViewEnable")
      end,
    })

    --Keymaps
    -- Toggle between csv viewing modes
    local custom_csv_mode = false
    vim.keymap.set("n", "<leader>csvt", function()
      -- Always disable first (if active)
      pcall(vim.cmd, "CsvViewDisable")
      if custom_csv_mode then
        -- Switch back to NORMAL CsvView
        vim.cmd("CsvViewEnable")
        custom_csv_mode = false
      else
        -- Switch to CUSTOM CsvView
        vim.cmd("CsvViewEnable delimiter=; display_mode=border header_lnum=1")
        custom_csv_mode = true
      end
    end, { desc = "Toggle custom CSV view mode" })
  end,
}
