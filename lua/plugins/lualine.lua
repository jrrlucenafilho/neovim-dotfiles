-- Bottom line that shows status and more info
return {
  'nvim-lualine/lualine.nvim',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require("lualine").setup({
      options = {
        theme = "nightfly"
      },
      sections = {
        lualine_x = {
          -- Molten status sections
          function() return require("molten.status").initialized() end,
          function() return require("molten.status").kernels() end,
          function() return require("molten.status").all_kernels() end,
        }
      }
    })
  end
}
