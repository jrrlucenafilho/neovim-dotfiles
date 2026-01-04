-- Path autocompletion
return {
  "hrsh7th/cmp-path",
  config = function()
    local cmp = require("cmp")

    cmp.setup({
      sources = cmp.config.sources({
        {
          name = "path",
          trigger_characters = { "/", ".", "~" },
          option = {
            trailing_slash = true,
            pathMappings = {
              ["@"] = "${folder}/src",
            },
          },
        },
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "buffer" },
      }),
    })
  end,
}
