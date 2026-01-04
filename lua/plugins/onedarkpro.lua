return {
  "olimorris/onedarkpro.nvim",
  priority = 1000,
  config = function()
    require("onedarkpro").setup({
      colors =
      {
        onedark = {bg = "#16191D"}
      }
    })
    vim.cmd("colorscheme onedark")
  end
}
