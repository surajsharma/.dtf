return {
  {
    {
      "everviolet/nvim",
      name = "evergarden",
      priority = 1000, -- Colorscheme plugin is loaded first before any other plugins
      opts = {
        theme = {
          variant = "spring", -- 'winter'|'fall'|'spring'|'summer'
          accent = "green",
        },
        editor = {
          transparent_background = true,
          sign = { color = "none" },
          float = {
            color = "mantle",
            invert_border = false,
          },
          completion = {
            color = "surface0",
          },
        },
      },
    },
    {
      "nyoom-engineering/oxocarbon.nvim",
    },
    {
      "folke/tokyonight.nvim",
      style = "night",
      opts = {
        transparent = true,
        styles = {
          sidebars = "transparent",
          floats = "transparent",
        },
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
        theme = "wave", -- Load "wave" theme
        background = { -- map the value of 'background' option to a theme
          dark = "dragon", -- try "dragon" !
          light = "lotus",
        },
      },
    },
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "oxocarbon",
        transparent = true,
      },
    },
    {
      "xiyaowong/transparent.nvim",
      lazy = false, -- make sure we load this during startup
      priority = 1000, -- make sure to load this before all the other start plugins
      config = function()
        --vim.cmd("TransparentEnable")
        vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
        vim.api.nvim_set_hl(0, "NormalNC", { bg = "none" })
      end,
    },
  },
}
