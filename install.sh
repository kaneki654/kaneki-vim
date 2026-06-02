#!/usr/bin/env bash
# kaneki-vim installer
# Installs neovim + all dependencies, copies the bundled config to
# ~/.config/nvim, wires CODESTRAL_API_KEY into ~/.bashrc, and bootstraps
# lazy.nvim + Mason headlessly.
#
# Safe to re-run: existing ~/.config/nvim is backed up to nvim.bak.<timestamp>.

set -euo pipefail

# ----- pretty output -----
c_red()  { printf '\033[1;31m%s\033[0m\n' "$*"; }
c_grn()  { printf '\033[1;32m%s\033[0m\n' "$*"; }
c_ylw()  { printf '\033[1;33m%s\033[0m\n' "$*"; }
c_cyn()  { printf '\033[1;36m%s\033[0m\n' "$*"; }
step()   { c_cyn "==> $*"; }
ok()     { c_grn "  ok: $*"; }
warn()   { c_ylw "  warn: $*"; }
die()    { c_red "  err: $*"; exit 1; }

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NVIM_SRC="${SCRIPT_DIR}/nvim"
NVIM_DST="${HOME}/.config/nvim"
BASHRC="${HOME}/.bashrc"
TS="$(date +%Y%m%d-%H%M%S)"

# ----- 0. sanity checks -----
step "Checking environment"
[ -d "$NVIM_SRC" ] || die "bundled nvim/ config not found at $NVIM_SRC"
[ "$(uname -s)" = "Linux" ] || warn "non-Linux OS detected; apt step may fail"
ok "running as $(whoami) on $(uname -srm)"

# ----- 1. install system packages -----
step "Installing system packages via apt"
if command -v apt-get >/dev/null 2>&1; then
  sudo apt-get update -y
  sudo apt-get install -y \
    neovim \
    git \
    curl \
    build-essential \
    ripgrep \
    fd-find \
    nodejs \
    npm \
    python3 \
    python3-pip \
    unzip
  # fd is named fdfind on Debian/Ubuntu; add a fd shim if missing
  if ! command -v fd >/dev/null 2>&1 && command -v fdfind >/dev/null 2>&1; then
    mkdir -p "$HOME/.local/bin"
    ln -sf "$(command -v fdfind)" "$HOME/.local/bin/fd"
    ok "linked fdfind -> ~/.local/bin/fd"
  fi
  ok "apt packages installed"
else
  warn "apt-get not found; skipping system package install"
  warn "install manually: neovim git curl build-essential ripgrep fd nodejs npm python3"
fi

# ----- 2. verify neovim version -----
step "Verifying neovim version"
if ! command -v nvim >/dev/null 2>&1; then
  die "neovim not installed"
fi
NVIM_VER="$(nvim --version | head -1)"
ok "$NVIM_VER"

# ----- 3. backup existing config -----
step "Backing up existing ~/.config/nvim"
mkdir -p "${HOME}/.config"
if [ -e "$NVIM_DST" ] || [ -L "$NVIM_DST" ]; then
  BAK="${NVIM_DST}.bak.${TS}"
  mv "$NVIM_DST" "$BAK"
  ok "previous config moved to $BAK"
else
  ok "no previous config (clean install)"
fi

# Also clear plugin caches so the new config starts fresh
for d in "${HOME}/.local/share/nvim" "${HOME}/.local/state/nvim" "${HOME}/.cache/nvim"; do
  if [ -d "$d" ]; then
    mv "$d" "${d}.bak.${TS}"
    ok "cleared $d (saved to ${d}.bak.${TS})"
  fi
done

# ----- 4. copy the new config -----
step "Installing kaneki-vim config to ~/.config/nvim"
cp -r "$NVIM_SRC" "$NVIM_DST"
ok "copied $NVIM_SRC -> $NVIM_DST"

# ----- 5. configure Codestral API key -----
step "Configuring Codestral API key"
touch "$BASHRC"

# Prompt only if no key in env AND no key already in bashrc
EXISTING_KEY="${CODESTRAL_API_KEY:-}"
if [ -z "$EXISTING_KEY" ] && ! grep -q '^export CODESTRAL_API_KEY=' "$BASHRC"; then
  echo
  c_ylw "  Get a free Codestral API key at: https://console.mistral.ai/codestral"
  c_ylw "  Pick the 'Codestral' key (NOT the regular Mistral key)."
  echo
  read -r -p "  Paste your CODESTRAL_API_KEY (or press Enter to skip): " USER_KEY
  if [ -n "${USER_KEY:-}" ]; then
    {
      echo ""
      echo "# kaneki-vim: Codestral AI completion key"
      echo "export CODESTRAL_API_KEY=\"${USER_KEY}\""
    } >> "$BASHRC"
    ok "CODESTRAL_API_KEY written to $BASHRC"
    export CODESTRAL_API_KEY="$USER_KEY"
  else
    warn "skipped — AI completion disabled until you set CODESTRAL_API_KEY"
  fi
else
  ok "CODESTRAL_API_KEY already set (env or ~/.bashrc)"
fi

# ----- 6. add vim->nvim alias -----
step "Adding 'alias vim=nvim' to ~/.bashrc"
if ! grep -q '^alias vim=nvim' "$BASHRC"; then
  {
    echo ""
    echo "# kaneki-vim: use neovim when typing vim"
    echo "alias vim=nvim"
  } >> "$BASHRC"
  ok "alias added"
else
  ok "alias already present"
fi

# ----- 7. bootstrap lazy.nvim + plugins headlessly -----
step "Bootstrapping plugins (lazy.nvim + Mason). This may take 2-5 minutes."
warn "first run downloads ~50 plugins and 6 LSP servers; please be patient."
# Run twice: first invocation installs lazy.nvim and plugins; second installs LSPs via Mason.
nvim --headless "+Lazy! sync" +qa 2>&1 | tail -20 || warn "lazy sync exited non-zero (often safe to ignore)"
nvim --headless "+sleep 3" "+MasonUpdate" "+qa" 2>&1 | tail -5 || true
ok "plugins installed"

# ----- 8. final report -----
echo
c_grn "================================================================"
c_grn "  kaneki-vim installed successfully"
c_grn "================================================================"
echo
echo "  Next steps:"
echo "    1. Open a new terminal (or run: source ~/.bashrc)"
echo "    2. Launch nvim:   vim   (or: nvim)"
echo "    3. Pick a theme:  press Space then t then c"
echo
echo "  AI completion:"
if [ -n "${CODESTRAL_API_KEY:-}" ] || grep -q '^export CODESTRAL_API_KEY=' "$BASHRC"; then
  c_grn "    Codestral key configured — ghost text will appear as you type"
else
  c_ylw "    Codestral key NOT set — add to ~/.bashrc to enable AI:"
  echo '      export CODESTRAL_API_KEY="your-key-here"'
fi
echo
echo "  Autosave is ENABLED by default (VSCode style):"
echo "    Files are written on InsertLeave / TextChanged / FocusLost / BufLeave."
echo "    Toggle off mid-session with :AutosaveToggle."
echo
echo "  Backup of previous config (if any): ~/.config/nvim.bak.${TS}"
echo
