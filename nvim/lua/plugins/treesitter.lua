return {
  {
    "nvim-treesitter/nvim-treesitter",
    branch = "master",
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "python", "html", "css", "typescript", "javascript", "php", "c", "lua", "vim",
        },
        highlight = { enable = true },
        indent    = { enable = true },
      })
    end,
  },
}
