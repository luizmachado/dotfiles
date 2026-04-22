-- NotebookNavigator.nvim: navegação e execução de code cells delimitadas por # %%
-- Integra com iron.nvim para enviar células ao REPL sem seleção manual

return {
  {
    "GCBallesteros/NotebookNavigator.nvim",
    dependencies = {
      "Vigemus/iron.nvim",
      "echasnovski/mini.ai",
    },
    keys = {
      { "]c",         function() require("notebook-navigator").move_cell("d") end,      desc = "Célula: próxima" },
      { "[c",         function() require("notebook-navigator").move_cell("u") end,      desc = "Célula: anterior" },
      { "<leader>rn", function() require("notebook-navigator").run_cell() end,          desc = "REPL: executar célula" },
      { "<leader>rA", function() require("notebook-navigator").run_all_cells() end,     desc = "REPL: executar todas as células" },
      { "<leader>ra", function() require("notebook-navigator").run_cells_above() end,   desc = "REPL: executar células acima" },
    },
    opts = {
      repl_provider = "iron",
      cell_markers  = { python = "# %%", julia = "# %%" },
      activate_repl = true,
    },
  },
}
