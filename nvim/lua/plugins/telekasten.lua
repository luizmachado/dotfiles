-- Telekasten.nvim: notas Zettelkasten em markdown, com busca via Telescope
-- Atalhos em <leader>z…; o calendar-vim mantém <leader>cal/<leader>caL
-- (por isso <leader>ca, Code Action, espera o timeoutlen)

local md = { "markdown", "telekasten" }

return {
  {
    "folke/which-key.nvim",
    opts = { spec = { { "<leader>z", group = "notes" } } },
  },

  {
    -- Não lazy: os mapeamentos são criados em plugin/calendar.vim ao carregar
    "renerocksai/calendar-vim",
    lazy = false,
  },

  {
    "nvim-telekasten/telekasten.nvim",
    dependencies = {
      "nvim-telescope/telescope.nvim",
      "renerocksai/calendar-vim",
    },
    cmd = "Telekasten",
    opts = {
      home = vim.fn.expand("~/zettelkasten"),
    },
    keys = {
      { "<leader>zp", "<cmd>Telekasten panel<cr>",           desc = "Notas: painel de comandos" },
      { "<leader>zf", "<cmd>Telekasten find_notes<cr>",      desc = "Notas: buscar por título" },
      { "<leader>zg", "<cmd>Telekasten search_notes<cr>",    desc = "Notas: buscar no conteúdo" },
      { "<leader>zd", "<cmd>Telekasten goto_today<cr>",      desc = "Notas: nota de hoje" },
      { "<leader>zz", "<cmd>Telekasten follow_link<cr>",     desc = "Notas: seguir link" },
      { "<leader>zn", "<cmd>Telekasten new_note<cr>",        desc = "Notas: nova nota" },
      { "<leader>zc", "<cmd>Telekasten show_calendar<cr>",   desc = "Notas: calendário" },
      { "<leader>zb", "<cmd>Telekasten show_backlinks<cr>",  desc = "Notas: backlinks" },
      { "<leader>zI", "<cmd>Telekasten insert_img_link<cr>", desc = "Notas: inserir imagem" },
      { "<leader>zl", "<cmd>Telekasten insert_link<cr>",     desc = "Notas: inserir link" },
      -- Só em markdown: nos outros arquivos o [ fica com o mini.pairs, sem atraso
      { "[[", "<cmd>Telekasten insert_link<cr>", mode = "i", ft = md, desc = "Notas: inserir link" },
    },
  },
}
