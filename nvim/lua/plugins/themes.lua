-- 600+ themes. Theme plugins are split into two groups:
--   * mass collections (tinted-vim + base16-nvim) -> loaded eagerly so their
--     hundreds of palettes are visible to :colorscheme and Telescope
--   * family plugins -> lazy-loaded; nvim auto-discovers each scheme via
--     `colors/*.vim|lua` once the plugin is on the rtp the first time it loads.
--
-- base16-nvim doesn't pre-generate `colors/*.lua` shims for its 318 palettes,
-- so we generate them ourselves at startup (idempotent, runs once).

local function generate_base16_shims()
  local data_dir = vim.fn.stdpath("data") .. "/lazy/base16-nvim/lua/colors"
  local out_dir  = vim.fn.stdpath("config") .. "/colors"
  if vim.fn.isdirectory(data_dir) == 0 then return end
  vim.fn.mkdir(out_dir, "p")
  -- Skip if already generated
  if vim.fn.glob(out_dir .. "/base16-*.lua") ~= "" then return end
  local schemes = vim.fn.readdir(data_dir)
  for _, fname in ipairs(schemes) do
    local name = fname:gsub("%.lua$", "")
    local path = out_dir .. "/base16-" .. name .. ".lua"
    local f = io.open(path, "w")
    if f then
      f:write(string.format(
        'require("base16-colorscheme").setup(require("colors.%s"))\n', name))
      f:close()
    end
  end
end

return {
  -- ===== Mass collections (eager so colors/ directories register) =====
  {
    "RRethy/base16-nvim",
    lazy = false,
    priority = 900,
    config = function() generate_base16_shims() end,
  },
  {
    "tinted-theming/tinted-vim",
    lazy = false,
    priority = 900,
  },

  -- ===== Popular families (eager so all variants register in :colorscheme) =====
  -- All are tiny highlight-group files; eager-loading adds <5ms total.
  { "catppuccin/nvim",             name = "catppuccin", lazy = false, priority = 1000 },
  { "folke/tokyonight.nvim",       lazy = false, priority = 800 },
  { "rose-pine/neovim",            name = "rose-pine",  lazy = false, priority = 800 },
  { "sainnhe/gruvbox-material",    lazy = false, priority = 800 },
  { "sainnhe/everforest",          lazy = false, priority = 800 },
  { "sainnhe/sonokai",             lazy = false, priority = 800 },
  { "sainnhe/edge",                lazy = false, priority = 800 },
  { "rebelot/kanagawa.nvim",       lazy = false, priority = 800 },
  { "navarasu/onedark.nvim",       lazy = false, priority = 800 },
  { "EdenEast/nightfox.nvim",      lazy = false, priority = 800 },
  { "projekt0n/github-nvim-theme", lazy = false, priority = 800 },
  { "Mofiqul/vscode.nvim",         lazy = false, priority = 800 },
  { "marko-cerovac/material.nvim", lazy = false, priority = 800 },
  { "Shatur/neovim-ayu",           lazy = false, priority = 800 },
  { "Mofiqul/dracula.nvim",        lazy = false, priority = 800 },
  { "AlexvZyl/nordic.nvim",        lazy = false, priority = 800 },
  { "ribru17/bamboo.nvim",         lazy = false, priority = 800 },
  { "nyoom-engineering/oxocarbon.nvim", lazy = false, priority = 800 },
  { "savq/melange-nvim",           lazy = false, priority = 800 },
  { "vague2k/vague.nvim",          lazy = false, priority = 800 },
  { "neanias/everforest-nvim",     lazy = false, priority = 800 },
  { "oxfist/night-owl.nvim",       lazy = false, priority = 800 },

  -- ===== Theme picker with persistence =====
  -- Eager-load so saved theme is restored on every nvim launch (e.g. `vim foo.html`).
  -- priority is lower than the family plugins above so all colorschemes are
  -- already registered before themery's setup runs.
  {
    "zaldih/themery.nvim",
    lazy = false,
    priority = 100,
    config = function()
      require("themery").setup({
        themes = vim.fn.getcompletion("", "color"),
        livePreview = true,
      })
    end,
  },
}
