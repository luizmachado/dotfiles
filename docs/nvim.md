# Neovim

Configuração baseada no [LazyVim](https://lazyvim.org). Leader: `<Space>`. Local leader: `\`.

---

## Extras habilitados

| Extra | Recurso |
|---|---|
| `yanky` | Histórico de yanks com ring de clipboard |
| `dial` | Incrementa/decrementa números, datas e valores especiais |
| `json` | LSP, schema validation e Treesitter para JSON/JSON5/JSONC |
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
| blink.cmp | Engine de completion com integração LSP |
| bufferline.nvim | Tabs de buffers na parte superior |
| lualine.nvim | Status bar inferior |
| noice.nvim | UI melhorada para mensagens e command line |
| snacks.nvim | Notificações, animações, bufdelete, picker |
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
