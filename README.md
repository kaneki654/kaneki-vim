# kaneki-vim

VSCode-flavored Neovim distro for ChromeOS Crostini / Debian / Ubuntu.

What you get:
- AI ghost-text completion via Codestral (free Mistral API)
- VSCode 1:1 keybindings (Ctrl+S save, Ctrl+P quick open, Ctrl+/ comment, etc.)
- Auto-pairs: `{`, `[`, `(`, `"`, `'` auto-double; Enter inside brackets expands to a centered indented block
- 6 LSPs auto-installed: pyright, html-lsp, css-lsp, typescript-language-server, intelephense, clangd
- ~600 themes (base16 collection + tinted-vim + 22 family plugins) with persistent theme picker
- Alpha dashboard, indent guides, gitsigns, todo-comments, colorizer
- Tuned for low-end terminals (Crostini xterm) — startup under 1s

## Install

```bash
git clone <this-repo> ~/kaneki-vim
cd ~/kaneki-vim
./install.sh
```

The installer will:
1. Install neovim, ripgrep, fd-find, nodejs, npm, build-essential, git, curl (via apt)
2. Back up any existing `~/.config/nvim` to `~/.config/nvim.bak.<timestamp>`
3. Copy the bundled `nvim/` config to `~/.config/nvim`
4. Add `alias vim=nvim` and `export CODESTRAL_API_KEY="..."` lines to `~/.bashrc` (prompts for your key)
5. Launch nvim once headlessly so lazy.nvim and Mason can bootstrap

## Get a Codestral API key (free)

1. Go to <https://console.mistral.ai/codestral>
2. Sign in and click **Create new key**
3. Pick the **Codestral** key (not the regular Mistral key)
4. Paste it when the installer asks, or set it later in `~/.bashrc`:
   ```bash
   export CODESTRAL_API_KEY="your-key-here"
   ```

## Key cheatsheet

| Action | Key |
|---|---|
| Save | `Ctrl+S` |
| Quick Open | `Ctrl+P` |
| Command palette | `Ctrl+Shift+P` |
| Find in files | `Ctrl+Shift+F` |
| Toggle sidebar | `Ctrl+B` |
| Toggle terminal | ``Ctrl+` `` |
| Comment line | `Ctrl+/` |
| Move line up/down | `Alt+Up` / `Alt+Down` |
| Go to definition | `F12` |
| Rename symbol | `F2` |
| Accept AI suggestion (ghost text) | `Tab` |
| Accept cmp menu suggestion | `Tab` or `Enter` (after `Ctrl+N` to pick) |
| Trigger AI manually | `:MinuetTrigger` |
| Theme picker (fuzzy) | `Space + t + c` |
| Theme picker (cycle + save) | `Space + t + t` |
| File tree | `Space + e` |

## Notes for terminal users

Three VSCode-style shortcuts can't be replicated in a terminal because the terminal sends ambiguous bytes:
- `Ctrl+Enter`, `Ctrl+Shift+Enter` — terminals send the same byte as plain Enter
- `Ctrl+[` — terminals send the same byte as Escape

Use `o` / `O` in normal mode for "new line below/above". Use `<<` for outdent.

## Uninstall

```bash
rm -rf ~/.config/nvim ~/.local/share/nvim ~/.local/state/nvim ~/.cache/nvim
mv ~/.config/nvim.bak.<timestamp> ~/.config/nvim   # if you want your old config back
```
