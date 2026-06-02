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

-- ============================================================
-- VSCode-style autosave
-- ============================================================
-- Saves the current buffer automatically when:
--   * you leave insert mode (Esc)               -> InsertLeave
--   * you make a normal-mode edit (dd, p, r)    -> TextChanged
--   * the terminal/window loses focus           -> FocusLost
--   * you switch to another buffer              -> BufLeave
-- Skipped silently for unnamed buffers, read-only buffers, special
-- buftypes (terminal/quickfix/help), and files in /tmp.
local autosave_group = vim.api.nvim_create_augroup("KanekiAutosave", { clear = true })

local function should_autosave(buf)
  if vim.bo[buf].readonly or not vim.bo[buf].modifiable then return false end
  if vim.bo[buf].buftype ~= "" then return false end
  local name = vim.api.nvim_buf_get_name(buf)
  if name == "" then return false end
  if name:match("^/tmp/") then return false end
  if not vim.bo[buf].modified then return false end
  return true
end

local function register_autosave()
  vim.api.nvim_create_autocmd({ "InsertLeave", "TextChanged", "FocusLost", "BufLeave" }, {
    group = autosave_group,
    callback = function(args)
      if should_autosave(args.buf) then
        pcall(vim.api.nvim_buf_call, args.buf, function()
          vim.cmd("silent! write")
        end)
      end
    end,
  })
end

register_autosave()
vim.g.kaneki_autosave_on = true

vim.api.nvim_create_user_command("AutosaveToggle", function()
  if vim.g.kaneki_autosave_on then
    vim.api.nvim_clear_autocmds({ group = autosave_group })
    vim.g.kaneki_autosave_on = false
    vim.notify("Autosave OFF", vim.log.levels.WARN)
  else
    register_autosave()
    vim.g.kaneki_autosave_on = true
    vim.notify("Autosave ON", vim.log.levels.INFO)
  end
end, { desc = "Toggle VSCode-style autosave" })
