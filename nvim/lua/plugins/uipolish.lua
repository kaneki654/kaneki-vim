-- Floats: make borders transparent so the theme bleeds through cleanly.
vim.api.nvim_create_autocmd("ColorScheme", {
  callback = function()
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })
    vim.api.nvim_set_hl(0, "FloatTitle",  { bg = "none" })
  end,
})

return {
  -- ===== Indent guides (faint vertical lines, like VSCode) =====
  {
    "lukas-reineke/indent-blankline.nvim",
    main = "ibl",
    event = "BufReadPost",
    opts = {
      indent = { char = "▏", tab_char = "▏" },
      scope = { enabled = true, show_start = false, show_end = false },
      exclude = { filetypes = { "alpha", "dashboard", "NvimTree", "Themery" } },
    },
  },

  -- ===== Current-scope highlight (animation OFF for terminal perf) =====
  {
    "echasnovski/mini.indentscope",
    version = "*",
    event = "BufReadPost",
    opts = {
      symbol = "│",
      options = { try_as_border = true },
      draw = { animation = function() return 0 end },  -- instant, no per-move redraws
    },
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "alpha", "dashboard", "NvimTree", "Themery", "lazy", "mason" },
        callback = function() vim.b.miniindentscope_disable = true end,
      })
    end,
  },

  -- noice + nvim-notify removed: noice was intercepting the cmdline area,
  -- which made `:wq!` and `:qa!` typing invisible in the bottom-left.
  -- Native cmdline is faster anyway.

  -- ===== Better UI for vim.ui.select/input (theme picker, rename, etc.) =====
  {
    "stevearc/dressing.nvim",
    event = "VeryLazy",
    opts = {
      input = { border = "rounded", relative = "editor" },
      select = { backend = { "telescope", "builtin" } },
    },
  },

  -- ===== Git decorations in the sign column =====
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPost",
    opts = {
      signs = {
        add          = { text = "▎" },
        change       = { text = "▎" },
        delete       = { text = "" },
        topdelete    = { text = "" },
        changedelete = { text = "▎" },
      },
      current_line_blame = false,  -- off for terminal perf
    },
  },

  -- ===== Highlight TODO / NOTE / FIX / HACK / WARN tags =====
  {
    "folke/todo-comments.nvim",
    event = "BufReadPost",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {},
  },

  -- ===== Color-code hex values (only in css/html/scss to keep things fast) =====
  {
    "norcalli/nvim-colorizer.lua",
    ft = { "css", "scss", "html", "javascript", "typescript", "javascriptreact", "typescriptreact" },
    config = function()
      require("colorizer").setup(
        { "css", "scss", "html", "javascript", "typescript", "javascriptreact", "typescriptreact" },
        { RGB = true, RRGGBB = true, RRGGBBAA = true, names = false, mode = "background" }
      )
    end,
  },

}
