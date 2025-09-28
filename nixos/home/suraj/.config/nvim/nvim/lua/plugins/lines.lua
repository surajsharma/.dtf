return {
  "https://git.sr.ht/~whynothugo/lsp_lines.nvim",
  -- or just "whynothugo/lsp_lines.nvim", both work
  event = "LspAttach", -- can be "VeryLazy" if you want immediate keymaps
  config = function()
    require("lsp_lines").setup()
    -- Disable the default virtual_text to avoid overlap:
    vim.diagnostic.config({
      virtual_text = false,
    })
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
