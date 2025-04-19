return {
  {
    {
      "folke/tokyonight.nvim",
      style = "night",
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
    },
    {
      "rebelot/kanagawa.nvim",
      styles = {
        sidebars = "transparent",
        floats = "transparent",
      },
      opts = {
        undercurl = true,
        transparent = true,
        colors = {
          theme = { all = { ui = { bg_gutter = "none", float = "none" } } },
        },
        theme = "dragon", -- Load "wave" theme
        background = { -- map the value of 'background' option to a theme
          dark = "dragon", -- try "dragon" !
          light = "lotus",
        },
      },
    },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "kanagawa",
      },
    },
  },
}
