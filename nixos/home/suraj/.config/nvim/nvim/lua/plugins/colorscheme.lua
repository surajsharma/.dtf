return {
  {
    {
      "LazyVim/LazyVim",
      opts = {
        colorscheme = "oxocarbon",
      },
    },
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
      lazy = false,
      priority = 1000,
      config = function()
        vim.o.termguicolors = true
        vim.opt.background = "dark"

        local aug = vim.api.nvim_create_augroup("OxocarbonTransparentUI", { clear = true })
        vim.api.nvim_create_autocmd("ColorScheme", {
          group = aug,
          pattern = "oxocarbon",
          callback = function()
            local function hl(name, opts)
              opts = opts or {}
              opts.bg = "none"
              opts.ctermbg = "none"
              opts.reverse = false -- some themes use reverse for StatusLine
              pcall(vim.api.nvim_set_hl, 0, name, opts)
            end
            -- Divider/border colors (adjust fg to your taste)
            for _, g in ipairs({
              "SignColumn",
              "SignColumnSB",
              "FoldColumn",
              "LineNr",
              "LineNrAbove",
              "LineNrBelow",
              "CursorLineNr",
              "CursorLineSign",
              "CursorLineFold",
              "EndOfBuffer",
              "CursorLine",
            }) do
              hl(g)
            end

            -- Status bars and tabs
            for _, g in ipairs({
              "StatusLine",
              "StatusLineNC",
              "WinBar",
              "WinBarNC",
              "TabLine",
              "TabLineFill",
              "TabLineSel",
            }) do
              hl(g)
            end

            -- Optional: window separators/borders
            hl("WinSeparator")
            hl("FloatBorder")

            -- Optional: full window transparency
            hl("Normal")
            hl("NormalNC")
            hl("NormalFloat")
          end,
        })

        vim.cmd("colorscheme oxocarbon")
      end,
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
