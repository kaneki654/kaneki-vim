vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.termguicolors = true
vim.opt.signcolumn = "yes"
vim.opt.mouse = "a"
vim.opt.clipboard = "unnamedplus"
vim.opt.smartindent = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.updatetime = 300
vim.opt.cmdheight = 1                 -- cmdline always visible
vim.opt.showmode = true               -- show -- INSERT -- at bottom
vim.opt.shortmess:append("c")         -- no "match 1 of N" messages from cmp
vim.opt.completeopt = "menu,menuone,noselect"  -- never auto-select a completion item

-- ===== Terminal performance tuning =====
vim.opt.lazyredraw = false       -- false on modern nvim (noice/cmp need it off)
vim.opt.ttyfast = true
vim.opt.synmaxcol = 240          -- don't syntax-highlight crazy-long lines
vim.opt.regexpengine = 1         -- old regex engine; faster for syntax matching
vim.opt.redrawtime = 1500
vim.opt.timeoutlen = 400
vim.opt.ttimeoutlen = 10         -- snappy <Esc>

-- Disable built-in plugins we never use (saves ~20ms each)
local disabled = {
  "gzip", "matchit", "matchparen", "netrw", "netrwPlugin", "netrwSettings",
  "netrwFileHandlers", "tar", "tarPlugin", "tohtml", "tutor", "zip", "zipPlugin",
}
for _, p in ipairs(disabled) do vim.g["loaded_" .. p] = 1 end

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require("lazy").setup("plugins")
require("keymaps")
