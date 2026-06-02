return {
  {
    "milanglacier/minuet-ai.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("minuet").setup({
        provider = "codestral",
        n_completions = 1,
        context_window = 8000,
        throttle = 200,
        debounce = 150,
        notify = "warn",
        request_timeout = 30,
        curl_extra_args = {
          "--http1.1",
          "--no-buffer",
          "--retry", "2",
          "--retry-connrefused",
          "--connect-timeout", "8",
        },
        provider_options = {
          codestral = {
            model = "codestral-latest",
            end_point = "https://codestral.mistral.ai/v1/fim/completions",
            api_key = "CODESTRAL_API_KEY",
            stream = true,
            optional = {
              max_tokens = 256,
              stop = { "\n\n" },
            },
          },
        },
        virtualtext = {
          auto_trigger_ft = { "*" },
          auto_trigger_ignore_ft = { "TelescopePrompt", "NvimTree", "alpha" },
          show_on_completion_menu = true,
          keymap = {
            accept      = "<Tab>",
            accept_line = "<A-a>",
            prev        = "<A-[>",
            next        = "<A-]>",
            dismiss     = "<A-e>",
          },
        },
      })

      local ok, cmp = pcall(require, "cmp")
      if ok then
        local cfg = cmp.get_config()
        table.insert(cfg.sources, 1, { name = "minuet" })
        cmp.setup(cfg)
      end

      vim.api.nvim_create_user_command("MinuetTrigger", function()
        require("minuet.virtualtext").action.next()
      end, {})
    end,
  },
}
