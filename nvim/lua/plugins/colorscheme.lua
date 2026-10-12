local theme_file = vim.fn.expand("~/.theme-mode")

local function read_mode()
  return vim.fn.filereadable(theme_file) == 1 and vim.fn.readfile(theme_file)[1] == "light" and "light" or "dark"
end

-- Nomes explícitos: "tokyonight" puro herda o `style` do setup e não troca de modo
local function apply(mode)
  local name = mode == "light" and "tokyonight-day" or "tokyonight-night"
  if vim.g.colors_name ~= name then
    vim.cmd.colorscheme(name)
  end
end

return {
  {
    "folke/tokyonight.nvim",
    priority = 1000,
    opts = function()
      return { style = read_mode() == "light" and "day" or "night" }
    end,
    config = function(_, opts)
      require("tokyonight").setup(opts)
      apply(read_mode())

      -- Acompanha o scripts/toggle-theme.sh sem precisar reiniciar o nvim
      vim.api.nvim_create_autocmd("FocusGained", {
        group = vim.api.nvim_create_augroup("luiz_theme_sync", { clear = true }),
        callback = function()
          apply(read_mode())
        end,
      })

      vim.api.nvim_create_autocmd("User", {
        pattern = "VeryLazy",
        once = true,
        callback = function()
          Snacks.toggle
            .new({
              name = "Light Mode",
              get = function()
                return vim.o.background == "light"
              end,
              set = function(state)
                local mode = state and "light" or "dark"
                vim.fn.writefile({ mode }, theme_file)
                apply(mode)
              end,
            })
            :map("<leader>ut")
        end,
      })
    end,
  },
}
