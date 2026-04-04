return {
  'nvim-telescope/telescope-ui-select.nvim',
  config = function()
    -- Wider / taller dropdown so long Cursor model ids fit; CodeCompanion uses `kind = "codecompanion.nvim"`.
    local ui_select_opts = require("telescope.themes").get_dropdown({
      layout_config = {
        width = function(_, max_columns, _)
          return math.floor(max_columns * 0.92)
        end,
        height = function(_, _, max_lines)
          return math.min(max_lines, math.floor(vim.o.lines * 0.85))
        end,
      },
    })
    -- Keep default single-line display (uses CodeCompanion's format_item, including the * current mark).
    -- Rich ordinals so Telescope's sorter matches on model id, name, and description.
    ui_select_opts.specific_opts = {
      ["codecompanion.nvim"] = {
        make_ordinal = function(e)
          local item = e.text
          if type(item) == "table" and (item.modelId or item.id) then
            return table.concat({
              item.modelId or item.id or "",
              item.name or "",
              item.description or "",
            }, " ")
          end
          return tostring(item)
        end,
      },
    }

    require("telescope").setup({
      extensions = {
        ["ui-select"] = ui_select_opts,
      },
    })
    -- To get ui-select loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    require("telescope").load_extension("ui-select")
  end
}
