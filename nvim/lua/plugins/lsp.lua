local servers = { "pyright", "html", "cssls", "ts_ls", "intelephense", "clangd" }

return {
  {
    "williamboman/mason.nvim",
    tag = "v1.11.0",
    opts = {},
  },
  {
    "neovim/nvim-lspconfig",
    tag = "v1.8.0",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "williamboman/mason.nvim",
    },
    config = function()
      local lsp = require("lspconfig")
      local caps = require("cmp_nvim_lsp").default_capabilities()

      -- Auto-install missing servers via Mason
      local mason_map = {
        pyright = "pyright",
        html = "html-lsp",
        cssls = "css-lsp",
        ts_ls = "typescript-language-server",
        intelephense = "intelephense",
        clangd = "clangd",
      }
      local mr = require("mason-registry")
      local function ensure(pkg)
        if not mr.is_installed(pkg) then
          local p = mr.get_package(pkg)
          p:install()
        end
      end
      mr.refresh(function()
        for _, pkg in pairs(mason_map) do ensure(pkg) end
      end)

      for _, s in ipairs(servers) do
        lsp[s].setup({ capabilities = caps })
      end

      vim.keymap.set("n", "gd",         vim.lsp.buf.definition)
      vim.keymap.set("n", "K",          vim.lsp.buf.hover)
      vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename)
      vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action)
      vim.keymap.set("n", "[d",         vim.diagnostic.goto_prev)
      vim.keymap.set("n", "]d",         vim.diagnostic.goto_next)
    end,
  },
}
