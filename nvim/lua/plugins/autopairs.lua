return {
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    dependencies = { "hrsh7th/nvim-cmp" },
    config = function()
      local autopairs = require("nvim-autopairs")
      autopairs.setup({
        check_ts = true,
        -- map_cr = true makes Enter between { } / ( ) / [ ] expand to a
        -- VSCode-style indented block (cursor lands centered). Safe to enable
        -- now that the <C-CR> collision in keymaps.lua has been removed.
        map_cr = true,
        map_bs = true,
        fast_wrap = {
          map = "<A-w>",
          chars = { "{", "[", "(", '"', "'" },
          pattern = [=[[%'%"%>%]%)%}%,]]=],
          end_key = "$",
          keys = "qwertyuiopzxcvbnmasdfghjkl",
          check_comma = true,
          highlight = "Search",
          highlight_grey = "Comment",
        },
        disable_filetype = { "TelescopePrompt" },
      })

      -- Hook autopairs into cmp so confirming a function completion still
      -- triggers bracket auto-insertion.
      local ok_cmp, cmp = pcall(require, "cmp")
      if ok_cmp then
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end
    end,
  },
  {
    "windwp/nvim-ts-autotag",
    ft = { "html", "xml", "javascript", "typescript", "javascriptreact",
           "typescriptreact", "vue", "svelte", "php" },
    opts = {},
  },
}
