return {
  "nvim-lualine/lualine.nvim",
  config = function()
    require("lualine").setup({
      sections = {
        lualine_z = {
          {
            function()
              local ok, wc = pcall(vim.fn.wordcount)
              if not ok or type(wc) ~= "table" or type(wc.words) ~= "number" then
                return ""
              end
              return "[" .. tostring(wc.words) .. " words]"
            end,
            cond = function()
              return vim.bo.filetype == "markdown"
            end,
          },
        },
      },
    })
  end,
}
