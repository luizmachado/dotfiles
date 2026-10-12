-- NotebookNavigator.nvim: navegação e execução de code cells delimitadas por # %%
-- Integra com iron.nvim para enviar células ao REPL sem seleção manual

-- Só em Python/Julia: fora deles, ]c/[c mantêm a navegação nativa do modo diff
local ft = { "python", "julia" }

return {
  {
    "GCBallesteros/NotebookNavigator.nvim",
    ft = ft,
    dependencies = {
      "Vigemus/iron.nvim",
      "nvim-mini/mini.ai",
    },
    keys = {
      { "]c",         function() require("notebook-navigator").move_cell("d") end,      desc = "Célula: próxima", ft = ft },
      { "[c",         function() require("notebook-navigator").move_cell("u") end,      desc = "Célula: anterior", ft = ft },
      { "<leader>rn", function() require("notebook-navigator").run_cell() end,          desc = "REPL: executar célula", ft = ft },
      { "<leader>rA", function() require("notebook-navigator").run_all_cells() end,     desc = "REPL: executar todas as células", ft = ft },
      { "<leader>ra", function() require("notebook-navigator").run_cells_above() end,   desc = "REPL: executar células acima", ft = ft },
    },
    opts = {
      repl_provider = "iron",
      cell_markers  = { python = "# %%", julia = "# %%" },
      activate_repl = true,
    },
  },
}
