-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
--
-- Add any additional autocmds here
-- with `vim.api.nvim_create_autocmd`
--
-- Or remove existing autocmds by their group name (which is prefixed with `lazyvim_` for the defaults)
-- e.g. vim.api.nvim_del_augroup_by_name("lazyvim_wrap_spell")

-- LaTeX: correção ortográfica em português + inglês e quebra visual de linha
vim.api.nvim_create_autocmd("FileType", {
  group = vim.api.nvim_create_augroup("luiz_tex_spell", { clear = true }),
  pattern = { "tex", "plaintex", "bib" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.spelllang = { "pt_br", "en_us" }
    vim.opt_local.wrap = true
    vim.opt_local.linebreak = true
  end,
})
