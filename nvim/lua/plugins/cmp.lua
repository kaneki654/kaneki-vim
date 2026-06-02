return {
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
    },
    config = function()
      local cmp = require("cmp")
      cmp.setup({
        snippet = {
          expand = function(args) require("luasnip").lsp_expand(args.body) end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-n>"]     = cmp.mapping.select_next_item(),
          ["<C-p>"]     = cmp.mapping.select_prev_item(),
          -- Enter: confirm completion if the menu is visible AND an item is
          -- explicitly selected; otherwise fall through to a plain newline.
          -- The fallback is what prevents the "Enter freezes" bug when no
          -- suggestion is highlighted.
          ["<CR>"] = cmp.mapping(function(fallback)
            if cmp.visible() and cmp.get_selected_entry() ~= nil then
              cmp.confirm({ select = false })
            else
              fallback()
            end
          end, { "i", "s" }),
          -- Tab: minuet ghost text takes priority (its own <Tab> handler runs
          -- first when ghost text is visible). If no ghost text but cmp menu
          -- is open, confirm the first suggestion. Otherwise fall through.
          ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true })
            else
              fallback()
            end
          end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "path" },
        }),
        performance = { fetching_timeout = 2000 },
      })
    end,
  },
}
