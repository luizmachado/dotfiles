return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = function()
      local f = vim.fn.expand("~/.theme-mode")
      local is_light = vim.fn.filereadable(f) == 1
        and vim.fn.readfile(f)[1] == "light"
      return { style = is_light and "day" or "night" }
    end,
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd("colorscheme tokyonight")
      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          Snacks.toggle.new({
            name = "Light Mode",
            get = function() return vim.o.background == "light" end,
            set = function(state)
              vim.cmd("colorscheme " .. (state and "tokyonight-day" or "tokyonight"))
              vim.fn.writefile({ state and "light" or "dark" }, vim.fn.expand("~/.theme-mode"))
            end,
          }):map("<leader>ut")
        end,
      })
    end,
  },
}
