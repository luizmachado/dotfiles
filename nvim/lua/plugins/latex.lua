-- LaTeX: base vem do extra `lang.tex` do LazyVim (vimtex, texlab, parsers
-- latex/bibtex e desativação do highlight treesitter, que o vimtex substitui).
-- Aqui ficam só os ajustes pessoais. Atalhos do vimtex: <localleader>l… (\ll, \lv…).
return {
  {
    "lervag/vimtex",
    init = function()
      vim.g.vimtex_view_method = "zathura" -- forward search requer xdotool
      vim.g.vimtex_compiler_method = "latexmk"
      -- Arquivos auxiliares e PDF em build/ (mantém o diretório do projeto limpo)
      vim.g.vimtex_compiler_latexmk = { out_dir = "build", aux_dir = "build" }
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        texlab = {
          settings = {
            texlab = {
              -- Mesmo diretório do vimtex, para o texlab achar labels e citações
              auxDirectory = "build",
              chktex = { onOpenAndSave = true },
            },
          },
        },
      },
    },
  },
}
