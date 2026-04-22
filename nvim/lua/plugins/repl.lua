return {
  {
    "Vigemus/iron.nvim",
    config = function()
      local iron = require("iron.core")

      iron.setup({
        config = {
          scratch_repl = true,
          repl_definition = {
            python = { command = { "python3" } },
            julia  = { command = { "julia", "--startup-file=no", "--color=yes" } },
            lua    = { command = { "lua" } },
            sh     = { command = { "zsh" } },
          },
          repl_open_cmd = require("iron.view").right("40%"),
        },
        keymaps = {
          send_motion       = "<leader>rc",
          visual_send       = "<leader>rc",
          send_file         = "<leader>rF",
          send_line         = "<leader>rl",
          send_paragraph    = "<leader>rp",
          send_until_cursor = "<leader>ru",
          mark_visual       = "<leader>rm",
          send_mark         = "<leader>rM",
          cr                = "<leader>r<cr>",
          interrupt         = "<leader>r<space>",
          exit              = "<leader>rq",
          clear             = "<leader>rx",
        },
        highlight = { italic = true },
        ignore_blank_lines = true,
      })

      require("which-key").add({ { "<leader>r", group = "repl" } })
    end,
    cmd = { "IronRepl", "IronRestart", "IronFocus", "IronHide" },
    keys = {
      { "<leader>rs", "<cmd>IronRepl<cr>",    desc = "REPL: abrir" },
      { "<leader>rr", "<cmd>IronRestart<cr>", desc = "REPL: reiniciar" },
      { "<leader>rf", "<cmd>IronFocus<cr>",   desc = "REPL: focar" },
      { "<leader>rh", "<cmd>IronHide<cr>",    desc = "REPL: ocultar" },
    },
  },
}
