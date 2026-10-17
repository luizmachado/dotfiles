# Neovim

Configuração baseada no [LazyVim](https://lazyvim.org). Leader: `<Space>`. Local leader: `\`.

---

## Extras habilitados

| Extra | Recurso |
|---|---|
| `yanky` | Histórico de yanks com ring de clipboard |
| `dial` | Incrementa/decrementa números, datas e valores especiais |
| `telescope` | Telescope como picker do LazyVim (no lugar do Snacks; exigido pelo Telekasten) |
| `json` | LSP, schema validation e Treesitter para JSON/JSON5/JSONC |
| `python` | LSP (basedpyright), DAP (debugpy), ruff, Treesitter python+toml |
| `mini-hipatterns` | Destaca cores hex e classes Tailwind inline |

---

## Keymaps

### Navegação — janelas e buffers

| Atalho | Modo | Ação |
|---|---|---|
| `<C-h>` | n | Janela à esquerda |
| `<C-j>` | n | Janela abaixo |
| `<C-k>` | n | Janela acima |
| `<C-l>` | n | Janela à direita |
| `<S-h>` | n | Buffer anterior |
| `<S-l>` | n | Próximo buffer |
| `<leader>-` | n | Split horizontal |
| `<leader>\|` | n | Split vertical |
| `<leader>wd` | n | Fechar janela |
| `<leader>bd` | n | Fechar buffer |
| `<leader>bo` | n | Fechar outros buffers |

### Arquivos e busca

| Atalho | Modo | Ação |
|---|---|---|
| `<leader><space>` | n | Buscar arquivos (root) |
| `<leader>ff` | n | Buscar arquivos (cwd) |
| `<leader>fr` | n | Arquivos recentes |
| `<leader>fb` | n | Buffers abertos |
| `<leader>/` | n | Grep (root) |
| `<leader>fg` | n | Live grep |
| `<leader>f*` | n | Grep pela palavra sob o cursor |
| `<leader>gc` | n | Commits do git |
| `<leader>s/` | n | Histórico de buscas |
| `<leader>so` | n | Opções do Vim |

O picker é o Telescope (`vim.g.lazyvim_picker = "telescope"` em `options.lua`). Dentro dele: `s`/`<C-s>`
pula com o flash, `<C-t>` manda para o Trouble, `<A-h>`/`<A-i>` mostram arquivos ocultos/ignorados e
`<C-/>` (insert) ou `?` (normal) listam os atalhos. O `<Esc>` vai para o modo normal do prompt, e um
segundo `<Esc>` fecha.

Atalhos que existiam só com o Snacks picker e **não** estão disponíveis: `<leader>fp`, `<leader>gd`/`gD`,
`<leader>gi`/`gI`, `<leader>gp`/`gP`, `<leader>sB`, `<leader>si`, `<leader>sp`, `<leader>su`.

### Notas (Telekasten)

Notas em `~/zettelkasten`. Configuração em `lua/plugins/telekasten.lua`.

| Atalho | Modo | Ação |
|---|---|---|
| `<leader>zp` | n | Painel de comandos |
| `<leader>zf` | n | Buscar notas por título |
| `<leader>zg` | n | Buscar no conteúdo das notas |
| `<leader>zd` | n | Nota de hoje |
| `<leader>zz` | n | Seguir link |
| `<leader>zn` | n | Nova nota |
| `<leader>zc` | n | Calendário |
| `<leader>zb` | n | Backlinks |
| `<leader>zI` | n | Inserir link de imagem |
| `<leader>zl` | n | Inserir link |
| `[[` | i | Inserir link (só em markdown) |
| `<leader>cal` / `<leader>caL` | n | Calendário vertical / horizontal (calendar-vim) |

Por causa do `<leader>cal`/`<leader>caL`, o `<leader>ca` (Code Action) espera o `timeoutlen`. Isso é intencional.

### Python e virtualenv

| Atalho | Modo | Ação |
|---|---|---|
| `<leader>cv` | n | Selecionar virtualenv (venv-selector) |

Configurado pelo extra `lang.python` do LazyVim. O venv-selector encontra os virtualenvs do pyenv em `~/.pyenv/versions` (busca padrão do plugin, requer `fd`) e reativa automaticamente o último venv usado no projeto.

### REPL (iron.nvim + NotebookNavigator)

Documentação completa: [`docs/repl.md`](repl.md)

| Atalho | Modo | Ação |
|---|---|---|
| `<leader>rs` | n | Abrir REPL (detecta filetype: python, julia…) |
| `<leader>rr` | n | Reiniciar REPL |
| `<leader>rf` | n | Focar janela do REPL |
| `<leader>rh` | n | Ocultar REPL |
| `<leader>rl` | n | Enviar linha atual |
| `<leader>rp` | n | Enviar parágrafo atual |
| `<leader>rc` | n, v | Enviar motion / seleção visual |
| `<leader>rF` | n | Enviar arquivo inteiro |
| `<leader>ru` | n | Enviar até o cursor |
| `<leader>rm` | v | Marcar seleção como região |
| `<leader>rM` | n | Enviar região marcada |
| `<leader>r<space>` | n | Interromper execução |
| `<leader>rx` | n | Limpar REPL |
| `<leader>rq` | n | Fechar REPL |

#### Code Cells (`# %%`)

| Atalho | Modo | Ação |
|---|---|---|
| `]c` | n | Próxima célula |
| `[c` | n | Célula anterior |
| `<leader>rn` | n | Executar célula atual |
| `<leader>ra` | n | Executar células acima do cursor |
| `<leader>rA` | n | Executar todas as células |

O REPL é detectado automaticamente pelo `filetype`. Para Julia, usa
`julia --startup-file=no --color=yes`. Para Python, usa `python3`.

### LaTeX (vimtex + texlab)

Base no extra `lang.tex` do LazyVim (vimtex, LSP `texlab`, parsers treesitter `latex`/`bibtex`
com highlight do treesitter desativado em favor do vimtex). Ajustes em `lua/plugins/latex.lua`:

- Compilação com `latexmk`; PDF e arquivos auxiliares em `build/` (o texlab lê labels/citações de lá)
- Visualizador Zathura (`zathura/zathurarc`, tema dark/light seguindo o `toggle-theme.sh`)
- `chktex` como linter via texlab
- Spell `pt_br,en_us`, `wrap` e `linebreak` em arquivos `tex`/`bib` (`lua/config/autocmds.lua`)

| Atalho | Modo | Ação |
|---|---|---|
| `\ll` | n | Compilar documento (toggle) |
| `\lk` | n | Parar compilação |
| `\lv` | n | Visualizar PDF / forward search |
| `\lc` | n | Limpar arquivos auxiliares |
| `\lC` | n | Limpar tudo (incluindo PDF) |
| `\lt` | n | Tabela de conteúdo |
| `\le` | n | Lista de erros |
| `\lq` | n | Log do compilador |
| `K` | n | Hover do LSP (texlab) |
| `<leader>K` | n | Documentação do pacote sob o cursor (vimtex) |

Forward search abre/foca o Zathura na linha atual (requer `xdotool`). Reverse search: `Ctrl+clique` no Zathura volta ao cursor no Neovim.

**Requisitos:** o vimtex atual exige Neovim ≥ 0.12.4 (`scripts/install-nvim.sh`). Bibliografia com
biblatex usa `biber` + `texlive-bibtex-extra`. Os parsers treesitter exigem o `tree-sitter` CLI ≥ 0.26.1
(binário do GitHub em `~/.local/bin`, instalado por `scripts/install-tools.sh` — **não** via npm).

### LSP e código

| Atalho | Modo | Ação |
|---|---|---|
| `gd` | n | Ir para definição |
| `gr` | n | Referências |
| `gI` | n | Ir para implementação |
| `gy` | n | Ir para definição de tipo |
| `K` | n | Hover (documentação) |
| `gK` | n | Assinatura da função |
| `<leader>ca` | n, v | Code actions |
| `<leader>cf` | n, v | Formatar arquivo/seleção |
| `<leader>cR` | n | Renomear símbolo |
| `<leader>cd` | n | Diagnóstico da linha |
| `<leader>cl` | n | Diagnósticos do workspace (Trouble) |
| `]d` / `[d` | n | Próximo/anterior diagnóstico |
| `]e` / `[e` | n | Próximo/anterior erro |
| `]w` / `[w` | n | Próximo/anterior warning |

### Git (gitsigns)

| Atalho | Modo | Ação |
|---|---|---|
| `]h` / `[h` | n | Próximo/anterior hunk |
| `<leader>ghs` | n, v | Stage hunk |
| `<leader>ghr` | n, v | Reset hunk |
| `<leader>ghS` | n | Stage buffer |
| `<leader>ghR` | n | Reset buffer |
| `<leader>ghu` | n | Unstage hunk |
| `<leader>ghp` | n | Preview hunk |
| `<leader>ghb` | n | Blame da linha |
| `<leader>ghB` | n | Blame do buffer |
| `<leader>ghd` | n | Diff do arquivo |

### Edição

| Atalho | Modo | Ação |
|---|---|---|
| `<C-a>` | n, v | Incrementar valor (dial) |
| `<C-x>` | n, v | Decrementar valor (dial) |
| `g<C-a>` | v | Incrementar seleção (dial) |
| `g<C-x>` | v | Decrementar seleção (dial) |
| `p` / `P` | n, v | Colar (yanky — com histórico) |
| `[y` / `]y` | n | Navegar no histórico de yanks |
| `<leader>p` | n | Abrir histórico de yanks (picker) |
| `s` | n, v, o | Flash: pular para qualquer lugar |
| `S` | n, v, o | Flash: pular por Treesitter |
| `r` | o | Flash: seleção remota |
| `R` | o, v | Flash: seleção Treesitter remota |

### UI e toggles

| Atalho | Modo | Ação |
|---|---|---|
| `<leader>us` | n | Toggle spell check |
| `<leader>uw` | n | Toggle word wrap |
| `<leader>ud` | n | Toggle diagnósticos |
| `<leader>ul` | n | Toggle números de linha |
| `<leader>un` | n | Toggle número relativo |
| `<leader>uo` | n | Toggle indent guides |
| `<leader>uf` | n | Toggle autoformat |
| `<leader>ut` | n | Toggle tema (escuro/claro) |
| `<C-/>` | n | Toggle terminal |

### Sessão

| Atalho | Modo | Ação |
|---|---|---|
| `<leader>qs` | n | Salvar sessão |
| `<leader>ql` | n | Restaurar última sessão |
| `<leader>qd` | n | Parar de salvar sessão |

### TODO e busca global

| Atalho | Modo | Ação |
|---|---|---|
| `<leader>st` | n | Buscar TODOs |
| `<leader>sT` | n | TODO/FIX/FIXME |
| `<leader>xt` | n | TODOs no Trouble |
| `<leader>sr` | n | Busca e substituição global (grug-far) |

---

## Plugins instalados

| Plugin | Propósito |
|---|---|
| venv-selector.nvim | Detecção e seleção de virtualenv pyenv para o LSP |
| vimtex | Compilação LaTeX, visualização Zathura e navegação estrutural |
| iron.nvim | REPL interativo para Python, Julia, Lua e Shell |
| NotebookNavigator.nvim | Navegação e execução de code cells `# %%` via iron |
| blink.cmp | Engine de completion com integração LSP |
| bufferline.nvim | Tabs de buffers na parte superior |
| lualine.nvim | Status bar inferior |
| noice.nvim | UI melhorada para mensagens e command line |
| snacks.nvim | Notificações, animações, bufdelete, toggles |
| telescope.nvim | Picker (arquivos, grep, LSP, git…) com fzf-native |
| telekasten.nvim | Notas Zettelkasten em markdown (+ calendar-vim) |
| flash.nvim | Navegação rápida por caracteres/treesitter |
| grug-far.nvim | Busca e substituição multi-arquivo |
| todo-comments.nvim | Destaque de TODO/FIXME/HACK no código |
| gitsigns.nvim | Sinais de git, blame e diff inline |
| trouble.nvim | Painel de diagnósticos, referências e TODOs |
| nvim-treesitter | Parsing e highlight baseado em sintaxe |
| nvim-ts-autotag | Fecha tags HTML/JSX automaticamente |
| nvim-lspconfig | Configuração de servidores LSP |
| mason.nvim | Instalador de LSP, formatadores e linters |
| conform.nvim | Formatação de código |
| nvim-lint | Linting |
| yanky.nvim | Histórico de yanks (extra) |
| dial.nvim | Incremento/decremento avançado (extra) |
| mini.ai | Text objects adicionais |
| mini.pairs | Fechamento automático de pares |
| mini.icons | Ícones |
| mini.hipatterns | Destaque de padrões inline (extra) |
| persistence.nvim | Salvar e restaurar sessões |
| friendly-snippets | Biblioteca de snippets |
| lazydev.nvim | Suporte a desenvolvimento Lua |
| tokyonight.nvim | Colorscheme Tokyo Night |
| catppuccin | Colorscheme Catppuccin |

---

## LSP, formatadores e linters

Instalados e gerenciados automaticamente via Mason.

| Ferramenta | Tipo | Linguagem |
|---|---|---|
| `lua_ls` | LSP | Lua |
| `jsonls` | LSP | JSON/JSONC |
| `basedpyright` | LSP | Python |
| `texlab` | LSP | LaTeX |
| `ruff` | Formatador/Linter | Python |
| `debugpy` | DAP | Python |
| `stylua` | Formatador | Lua |
| `shfmt` | Formatador | Shell |
| `shellcheck` | Linter | Shell |

---

## Colorscheme

- **Padrão:** tokyonight
- **Fallback:** habamax
- **Disponível:** catppuccin (instalar via `:Lazy`)

---

## Opções de formatação (stylua.toml)

- Indentação: 2 espaços
- Largura de coluna: 120 caracteres
