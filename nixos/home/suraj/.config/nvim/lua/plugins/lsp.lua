return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "mason-org/mason.nvim",
    "mason-org/mason-lspconfig.nvim",
  },
  config = function()
    -- Your existing config
    local lspconfig = require("lspconfig")
    local util = require("lspconfig.util")

    -- Clojure
    lspconfig.clojure_lsp.setup({
      -- If Mason's PATH isn't picked up (e.g. on Nix), use the absolute Mason binary:
      cmd = { vim.fn.stdpath("data") .. "/mason/bin/clojure-lsp" },
      filetypes = { "clojure", "clojurescript", "cljc", "edn" },
      root_dir = util.root_pattern("deps.edn", "project.clj", "shadow-cljs.edn", "bb.edn", ".git"),
      on_attach = function(client, bufnr)
        -- format on save (cljfmt via clojure-lsp; configure in .lsp/config.edn)
        if client.supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = bufnr,
            callback = function()
              vim.lsp.buf.format({ bufnr = bufnr, timeout_ms = 2000 })
            end,
          })
        end

        -- optional: organize imports/clean-ns on save
        vim.api.nvim_create_autocmd("BufWritePre", {
          buffer = bufnr,
          callback = function()
            vim.lsp.buf.code_action({
              context = { only = { "source.organizeImports" } },
              apply = true,
            })
          end,
        })
      end,
    })

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
    lspconfig.tsserver.setup({})
    lspconfig.gopls.setup({
      settings = {
        gopls = {
          buildFlags = { "-tags=integration" },
        },
      },
    })
  end,
}
