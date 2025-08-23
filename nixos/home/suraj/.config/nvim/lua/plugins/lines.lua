-- lua/plugins/lsp-lines.lua
return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  event = "LspAttach",
  config = function()
    require("lsp_lines").setup()
    -- lsp_lines conflicts with virtual_text, so disable it:
    vim.diagnostic.config({ virtual_text = false })
  end,
  keys = {
    {
      "<leader>ll",
      function()
        require("lsp_lines").toggle()
      end,
      desc = "Toggle LSP lines",
    },
  },
}
