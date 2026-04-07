return {
  -- Detecção e seleção de virtualenv pyenv para o LSP
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    dependencies = { "neovim/nvim-lspconfig", "nvim-telescope/telescope.nvim" },
    opts = {
      settings = {
        options = {
          notify_user_on_venv_activation = true,
        },
        search = {
          pyenv_venvs = {
            command = "fd 'python$' "
              .. vim.fn.expand("~/.pyenv/versions")
              .. " --full-path -L",
          },
        },
      },
    },
    keys = {
      { "<leader>cv", "<cmd>VenvSelect<cr>", desc = "Select VirtualEnv" },
      { "<leader>cV", "<cmd>VenvSelectCached<cr>", desc = "Select Cached VirtualEnv" },
    },
    ft = "python",
  },

  -- Auto-ativa o venv ao abrir arquivo Python quando .python-version existe
  {
    "linux-cultist/venv-selector.nvim",
    branch = "regexp",
    init = function()
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "python",
        callback = function()
          local venv_file = vim.fn.findfile(".python-version", ".;")
          if venv_file ~= "" then
            vim.defer_fn(function()
              require("venv-selector").retrieve_from_cache()
            end, 500)
          end
        end,
      })
    end,
  },
}
