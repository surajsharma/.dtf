return {
  "stevearc/conform.nvim",
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
    },
    formatters = {
      stylua = {
        command = "/run/current-system/sw/bin/stylua",
      },
    },
  },
}
