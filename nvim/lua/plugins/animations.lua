return {
  -- ===== Dashboard (cooler startup screen) =====
  {
    "goolord/alpha-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      local alpha = require("alpha")
      local dashboard = require("alpha.themes.dashboard")

      dashboard.section.header.val = {
        [[                                                                       ]],
        [[    ██╗  ██╗ █████╗ ███╗   ██╗███████╗██╗  ██╗██╗    ██╗███████╗      ]],
        [[    ██║ ██╔╝██╔══██╗████╗  ██║██╔════╝██║ ██╔╝██║    ██║██╔════╝      ]],
        [[    █████╔╝ ███████║██╔██╗ ██║█████╗  █████╔╝ ██║ █╗ ██║███████╗      ]],
        [[    ██╔═██╗ ██╔══██║██║╚██╗██║██╔══╝  ██╔═██╗ ██║███╗██║╚════██║      ]],
        [[    ██║  ██╗██║  ██║██║ ╚████║███████╗██║  ██╗╚███╔███╔╝███████║      ]],
        [[    ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝  ╚═══╝╚══════╝╚═╝  ╚═╝ ╚══╝╚══╝ ╚══════╝      ]],
        [[                                                                       ]],
        [[     ▄▄▄  ▄▄▄ • ▪   • ▌ ▄ ·.    ▄▄▄▄▄▄▄▄ .▄▄▄  • ▌ ▄ ·. ▪   ▐ ▄  ▄▄▄· ]],
        [[    ▀▄ █·▐█ ▀ █ ██ ·██ ▐███▪    •██  ▀▄.▀·▀▄ █··██ ▐███▪██ •█▌▐█▐█ ▀█ ]],
        [[    ▐▀▀▄ ▄█ ▀█▄▐█·▐█ ▌▐▌▐█·     ▐█.▪▐▀▀▪▄▐▀▀▄ ▐█ ▌▐▌▐█·▐█·▐█▐▐▌▄█▀▀█ ]],
        [[    ▐█•█▌▐█▄▪▐█▐█▌██ ██▌▐█▌     ▐█▌·▐█▄▄▌▐█•█▌██ ██▌▐█▌▐█▌██▐█▌▐█ ▪▐▌]],
        [[    .▀  ▀·▀▀▀▀ ▀▀▀▀▀  █▪▀▀▀     ▀▀▀  ▀▀▀ .▀  ▀▀▀  █▪▀▀▀▀▀▀▀▀ █▪ ▀  ▀ ]],
        [[                                                                       ]],
      }
      dashboard.section.header.opts = { position = "center", hl = "Function" }

      -- Cyberpunk / anime / coder quotes — one shown at random each launch.
      local quotes = {
        "「 Code is poetry written in logic 」",
        "「 The world is cruel, but also very beautiful 」",
        "「 1000-7 = 993. 993-7 = 986... 」",
        "「 Tatakae. Tatakae. 」",
        "「 Wake up samurai, we have a codebase to burn 」",
        "「 If you don't like your destiny, don't accept it 」",
        "「 Hard work betrays none, but dreams betray many 」",
        "「 The only ones who should kill are those prepared to be killed 」",
        "「 Talk less. Smile more. Ship code. 」",
        "「 I'll take a potato chip... AND EAT IT! 」",
        "「 Plus Ultra 」",
        "「 Stay hungry, stay foolish, stay caffeinated 」",
        "「 Power comes in response to a need, not a desire 」",
        "「 Believe it. 」",
        "「 The strong eat the weak. That's a law of nature. 」",
      }
      math.randomseed(os.time())
      local quote = quotes[math.random(#quotes)]

      dashboard.section.footer.val = {
        "",
        quote,
        "",
        os.date("  %A, %B %d  •  %H:%M"),
      }
      dashboard.section.footer.opts = { position = "center", hl = "Comment" }

      -- Stylish buttons with vertical bars
      dashboard.section.buttons.val = {
        dashboard.button("e", "  New file",        "<cmd>ene<CR>"),
        dashboard.button("f", "󰈞  Find file",       "<cmd>Telescope find_files<CR>"),
        dashboard.button("r", "  Recent files",    "<cmd>Telescope oldfiles<CR>"),
        dashboard.button("g", "  Live grep",       "<cmd>Telescope live_grep<CR>"),
        dashboard.button("t", "  Theme picker",    "<cmd>Themery<CR>"),
        dashboard.button("c", "  Config",          "<cmd>e $MYVIMRC<CR>"),
        dashboard.button("l", "󰒲  Lazy",            "<cmd>Lazy<CR>"),
        dashboard.button("m", "  Mason (LSPs)",    "<cmd>Mason<CR>"),
        dashboard.button("q", "󰗼  Quit",            "<cmd>qa<CR>"),
      }
      for _, btn in ipairs(dashboard.section.buttons.val) do
        btn.opts.hl = "Keyword"
        btn.opts.hl_shortcut = "Type"
      end

      alpha.setup(dashboard.config)

      -- Re-render the footer (clock/quote) when alpha redraws so it stays fresh.
      vim.api.nvim_create_autocmd("User", {
        pattern = "AlphaReady",
        callback = function()
          vim.opt_local.foldenable = false
          vim.opt_local.cursorline = false
          vim.opt_local.colorcolumn = ""
        end,
      })
    end,
  },

  -- Smear-cursor and neoscroll removed: too heavy for Crostini's xterm emulator.
  -- Both redraw on every cursor move which is the #1 cause of perceived lag.

  -- ===== Yank/paste glimmer =====
  {
    "rachartier/tiny-glimmer.nvim",
    event = "TextYankPost",
    opts = {
      enabled = true,
      animations = { fade = { max_duration = 400 } },
    },
  },

  -- ===== On-demand visual effects =====
  -- :CellularAutomaton make_it_rain     -- text falls like Matrix rain
  -- :CellularAutomaton game_of_life     -- Conway's Game of Life over code
  { "eandrju/cellular-automaton.nvim", cmd = "CellularAutomaton" },

  -- ===== Idle screensaver =====
  {
    "tamton-aquib/zone.nvim",
    event = "CursorHold",
    opts = {
      style = "treadmill",
      after = 300,
    },
  },

  -- ===== Statusline (static colors — no per-redraw hue computation) =====
  {
    "nvim-lualine/lualine.nvim",
    event = "VeryLazy",
    opts = {
      options = { theme = "auto", globalstatus = true, icons_enabled = true },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { "filename" },
        lualine_x = { "encoding", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
    },
  },
}
