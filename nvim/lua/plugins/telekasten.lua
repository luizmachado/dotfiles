-- Telekasten.nvim: notas Zettelkasten em markdown, com busca via Telescope
-- Atalhos em <leader>z…; o calendar-vim mantém <leader>cal/<leader>caL
-- (por isso <leader>ca, Code Action, espera o timeoutlen)

local md = { "markdown", "telekasten" }
local home = vim.fn.expand("~/notes")

-- Nova nota de reunião em reunioes/AAAA-MM-DD-<título>.md, a partir de templates/reuniao.md
local function new_meeting()
  vim.ui.input({ prompt = "Reunião: " }, function(title)
    if not title or vim.trim(title) == "" then
      return
    end
    title = vim.trim(title):gsub("/", "-")
    local dir = home .. "/reunioes"
    local path = ("%s/%s-%s.md"):format(dir, os.date("%Y-%m-%d"), title)

    if vim.fn.filereadable(path) == 0 then
      -- Mesma substituição de variáveis ({{title}}, {{date}}…) que o Telekasten usa
      local subst = require("telekasten.templates").subst_templated_values
      local lines = {}
      for _, line in ipairs(vim.fn.readfile(home .. "/templates/reuniao.md")) do
        table.insert(lines, subst(line, title, nil, nil, 1))
      end
      vim.fn.mkdir(dir, "p")
      vim.fn.writefile(lines, path)
    end
    vim.cmd.edit(vim.fn.fnameescape(path))
  end)
end

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
    -- Carrega também ao abrir uma nota direto, para ela já receber ft=telekasten
    event = { "BufReadPre " .. home .. "/*.md", "BufNewFile " .. home .. "/*.md" },
    init = function()
      -- Parser markdown nas notas (ft=telekasten): habilita render-markdown e treesitter
      vim.treesitter.language.register("markdown", "telekasten")

      -- O treesitter.start do LazyVim desliga o syntax regex; reativa o do Telekasten
      -- (tkLink, tkTag, tkBrackets) por cima do highlight treesitter
      vim.api.nvim_create_autocmd("FileType", {
        group = vim.api.nvim_create_augroup("luiz_telekasten_syntax", { clear = true }),
        pattern = "telekasten",
        callback = function(ev)
          vim.schedule(function()
            if vim.api.nvim_buf_is_valid(ev.buf) then
              vim.bo[ev.buf].syntax = "telekasten"
            end
          end)
        end,
      })
    end,
    opts = {
      home = home,
      dailies = home .. "/diario",
      templates = home .. "/templates",
      template_new_daily = home .. "/templates/diaria.md",
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
      { "<leader>zm", new_meeting,                           desc = "Notas: nova reunião" },
      -- Só em markdown: nos outros arquivos o [ fica com o mini.pairs, sem atraso
      { "[[", "<cmd>Telekasten insert_link<cr>", mode = "i", ft = md, desc = "Notas: inserir link" },
    },
  },
}
