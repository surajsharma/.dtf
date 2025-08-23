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

    -- C/C++: clangd (uses system clangd from Nix)
    do
      local lspconfig = require("lspconfig")
      local util = require("lspconfig.util")

      -- Capabilities: add cmp if present and set offsetEncoding to avoid warnings
      local caps = vim.lsp.protocol.make_client_capabilities()
      local ok_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if ok_cmp then
        caps = cmp_lsp.default_capabilities(caps)
      end
      caps.offsetEncoding = { "utf-16" }

      lspconfig.clangd.setup({
        cmd = { "clangd" }, -- or "/run/current-system/sw/bin/clangd" if you prefer absolute
        capabilities = caps,
        root_dir = util.root_pattern("compile_commands.json", "compile_flags.txt", ".git"),
        on_attach = function(_, bufnr)
          -- format on save (clangd respects your .clang-format)
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr })
            end,
          })
          -- quick LSP mappings (optional)
          local map = function(mode, lhs, rhs, desc)
            vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
          end
          map("n", "gd", vim.lsp.buf.definition, "Go to Definition")
          map("n", "K", vim.lsp.buf.hover, "Hover")
        end,

        -- If your compile_commands.json lives in ./build, uncomment:
        -- cmd = { "clangd", "--compile-commands-dir=build" },
      })
    end
    lspconfig.gopls.setup({
      settings = {
        gopls = {
          buildFlags = { "-tags=integration" },
        },
      },
    })
  end,
}
