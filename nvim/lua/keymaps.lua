-- VSCode-style keybindings for Neovim
local map = vim.keymap.set
local opts = { silent = true, noremap = true }

-- ============================================================
-- FILE OPERATIONS
-- ============================================================
map({ "n", "i", "v" }, "<C-s>", "<Esc><cmd>w<CR>", opts)              -- Save
map("n",               "<C-n>", "<cmd>enew<CR>", opts)                -- New file
map("n",               "<C-w>", "<cmd>bd<CR>", opts)                  -- Close buffer (overrides window prefix)
map("n",               "<C-S-t>", "<cmd>e #<CR>", opts)               -- Reopen last closed
map("n",               "<C-q>", "<cmd>qa<CR>", opts)                  -- Quit all

-- ============================================================
-- EDITING (clipboard)
-- ============================================================
map("v", "<C-c>", '"+y', opts)                                        -- Copy
map("v", "<C-x>", '"+d', opts)                                        -- Cut
map("n", "<C-v>", '"+p', opts)                                        -- Paste (normal)
map("i", "<C-v>", "<C-r>+", opts)                                     -- Paste (insert)
map("v", "<C-v>", '"+p', opts)                                        -- Paste (visual)
map({ "n", "i" }, "<C-a>", "<Esc>ggVG", opts)                         -- Select All
map({ "n", "i" }, "<C-z>", "<Esc>u", opts)                            -- Undo
map({ "n", "i" }, "<C-y>", "<Esc><C-r>", opts)                        -- Redo
map({ "n", "i" }, "<C-S-z>", "<Esc><C-r>", opts)                      -- Redo (alt)

-- ============================================================
-- FIND / REPLACE
-- ============================================================
map({ "n", "i" }, "<C-f>", "<Esc>/", { noremap = true })              -- Find in file
map({ "n", "i" }, "<C-h>", "<Esc>:%s/", { noremap = true })           -- Replace in file
map("n", "<C-p>",   "<cmd>Telescope find_files<CR>", opts)            -- Quick Open
map("n", "<C-S-p>", "<cmd>Telescope commands<CR>", opts)              -- Command Palette
map("n", "<C-S-f>", "<cmd>Telescope live_grep<CR>", opts)             -- Search in Files
map("n", "<C-S-o>", "<cmd>Telescope lsp_document_symbols<CR>", opts)  -- Go to Symbol in File

-- ============================================================
-- LINE EDITING
-- ============================================================
map("n", "<C-/>", "gcc", { remap = true })                            -- Toggle comment (normal)
map("i", "<C-/>", "<Esc>gccA", { remap = true })                      -- Toggle comment (insert)
map("v", "<C-/>", "gc",  { remap = true })                            -- Toggle comment (visual)

map("n", "<A-Up>",   "<cmd>m .-2<CR>==", opts)                        -- Move line up
map("n", "<A-Down>", "<cmd>m .+1<CR>==", opts)                        -- Move line down
map("i", "<A-Up>",   "<Esc><cmd>m .-2<CR>==gi", opts)
map("i", "<A-Down>", "<Esc><cmd>m .+1<CR>==gi", opts)
map("v", "<A-Up>",   ":m '<-2<CR>gv=gv", opts)
map("v", "<A-Down>", ":m '>+1<CR>gv=gv", opts)

map("n", "<S-A-Up>",   "<cmd>t .-1<CR>", opts)                        -- Duplicate line up
map("n", "<S-A-Down>", "<cmd>t .<CR>",  opts)                         -- Duplicate line down
map("v", "<S-A-Up>",   ":t '<-1<CR>gv",  opts)
map("v", "<S-A-Down>", ":t '><CR>gv",   opts)

-- NOTE: <C-CR>, <C-S-CR>, and <C-[> cannot be safely mapped in a terminal.
-- Terminals send the same byte for <CR> and <C-CR> (0x0D), and <C-[> IS Esc
-- (0x1B). Mapping any of them hijacks Enter or Escape and causes the editor
-- to appear frozen on every Enter press. VSCode-style "new line below/above"
-- is unavailable in terminal nvim — use `o` / `O` in normal mode instead.
-- For outdent, use `<<` in normal mode or `<S-Tab>` in visual mode.

map({ "n", "i" }, "<C-S-k>", "<Esc><cmd>d<CR>", opts)                 -- Delete line

map("n", "<C-]>", ">>", opts)                                         -- Indent
map("v", "<Tab>", ">gv", opts)
map("v", "<S-Tab>", "<gv", opts)

map({ "n", "i" }, "<C-g>", "<Esc><cmd>lua vim.ui.input({prompt='Go to line: '}, function(l) if l then vim.cmd(l) end end)<CR>", opts)

-- ============================================================
-- LSP NAVIGATION
-- ============================================================
map("n", "<F12>",   vim.lsp.buf.definition, opts)                     -- Go to Definition
map("n", "<S-F12>", vim.lsp.buf.references, opts)                     -- Find All References
map("n", "<F2>",    vim.lsp.buf.rename, opts)                         -- Rename Symbol
map({ "n", "i" }, "<C-.>", vim.lsp.buf.code_action, opts)             -- Quick Fix / Code Action
map("n", "<F8>",    vim.diagnostic.goto_next, opts)                   -- Next Problem
map("n", "<S-F8>",  vim.diagnostic.goto_prev, opts)                   -- Prev Problem
map("n", "<C-S-Space>", vim.lsp.buf.signature_help, opts)             -- Trigger Parameter Hints

-- ============================================================
-- UI / PANELS
-- ============================================================
map({ "n", "i", "t" }, "<C-b>", "<Esc><cmd>NvimTreeToggle<CR>", opts) -- Toggle Sidebar
map({ "n", "i", "t" }, "<C-`>", "<Esc><cmd>ToggleTerm<CR>", opts)     -- Toggle Terminal
-- NOTE: <C-j> removed entirely. In most terminals (including Crostini's default
-- xterm), pressing <Enter> sends the same byte as <C-j> (0x0A), so mapping
-- <C-j> hijacks Enter and breaks all typing. Use <C-`> for the terminal panel.

-- ============================================================
-- TAB / BUFFER NAVIGATION
-- ============================================================
map("n", "<C-Tab>",   "<cmd>bnext<CR>", opts)                         -- Next tab
map("n", "<C-S-Tab>", "<cmd>bprevious<CR>", opts)                     -- Previous tab
map("n", "<C-PageDown>", "<cmd>bnext<CR>", opts)
map("n", "<C-PageUp>",   "<cmd>bprevious<CR>", opts)

-- Ctrl+1..9 jump to buffer N (VSCode jumps to tab N)
for i = 1, 9 do
  map("n", "<C-" .. i .. ">", "<cmd>BufferLineGoToBuffer " .. i .. "<CR>", opts)
end

-- ============================================================
-- TERMINAL MODE escape
-- ============================================================
map("t", "<Esc>", "<C-\\><C-n>", opts)                                -- Leave terminal mode

-- ============================================================
-- VIM BLOCK-SELECT (since C-v is paste now)
-- ============================================================
map("n", "<C-q>", "<C-v>", opts)                                      -- Visual block mode

-- ============================================================
-- THEME PICKERS
-- ============================================================
map("n", "<leader>tc", "<cmd>Telescope colorscheme enable_preview=true<CR>",
    { silent = true, noremap = true, desc = "Theme picker (fuzzy + live preview)" })
map("n", "<leader>tt", "<cmd>Themery<CR>",
    { silent = true, noremap = true, desc = "Theme picker (cycle + save)" })
