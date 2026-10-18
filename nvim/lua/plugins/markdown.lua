-- Markdown: render-markdown.nvim + LSP marksman (sem o resto do extra `lang.markdown`:
-- nada de markdownlint, prettier ou preview no navegador).
-- Também atua nas notas do Telekasten (ft=telekasten); ver plugins/telekasten.lua.
local ft = { "markdown", "telekasten" }

return {
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = ft,
    opts = {
      file_types = ft,
      -- Mesmos ajustes do extra lang.markdown do LazyVim
      code = { sign = false, width = "block", right_pad = 1 },
      heading = { sign = false, icons = {} },
      checkbox = { enabled = false },
      completions = { lsp = { enabled = true } },
    },
    config = function(_, opts)
      require("render-markdown").setup(opts)
      Snacks.toggle({
        name = "Render Markdown",
        get = require("render-markdown").get,
        set = require("render-markdown").set,
      }):map("<leader>um")
    end,
  },

  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        marksman = {
          filetypes = { "markdown", "markdown.mdx", "telekasten" },
          -- Notas do Telekasten chegam ao servidor como markdown
          get_language_id = function()
            return "markdown"
          end,
        },
      },
    },
  },

  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "markdown", "markdown_inline" } },
  },
}
