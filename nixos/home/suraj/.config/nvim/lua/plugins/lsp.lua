return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    -- Your existing config
    local lspconfig = require("lspconfig")

    -- This will override Mason's setup
    lspconfig.lua_ls.setup({
      cmd = { "/run/current-system/sw/bin/lua-language-server" },
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = { globals = { "vim" } },
          workspace = { checkThirdParty = false },
          telemetry = { enable = false },
          format = { enable = false },
        },
      },
    })

    lspconfig.rust_analyzer.setup({
      on_attach = function(_, bufnr)
        -- your keymaps here
        -- format on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.format({ bufnr = bufnr })
          end,
        })
      end,
    })

    lspconfig.gopls.setup({
      settings = {
        gopls = {
          buildFlags = { "-tags=integration" },
        },
      },
    })
  end,
}
