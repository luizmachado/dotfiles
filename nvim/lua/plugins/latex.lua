return {
  {
    "lervag/vimtex",
    lazy = false,
    init = function()
      vim.g.vimtex_view_method = "zathura"
      vim.g.vimtex_compiler_method = "latexmk"
      vim.g.vimtex_mappings_prefix = "\\"
      -- Desativa o atalho <localleader>li que conflita com o LazyVim
      vim.g.vimtex_mappings_disable = { n = { "\\li" } }
    end,
  },
}
