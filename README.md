# dotfiles

## Documentação

Referência detalhada de atalhos e recursos de cada ferramenta em [`docs/`](docs/index.md).

Contexto para o Claude Code em [`CLAUDE.md`](CLAUDE.md).

Fiz os testes no Ubuntu 24.04 e Debian 12. Todos os testes foram
feitos com uma instalação limpa dos sistemas operacionais.

Mesmo assim, recomendo que você abra o arquivo `install.sh` e execute os
comandos linha a linha observando o que cada linha vai fazer. Se você executar
esse script no seu sistema, ele vai rodar direto e não para mais, então ele
sairá sobrescrevendo, apagando, criando e instalando tudo de uma vez (pra mim é
mais fácil assim).

Se mesmo com o aviso ainda quer rodar, faça isso com o git instalado:

```bash
git clone git@github.com:luizmachado/dotfiles.git ~/dotfiles
cd ~/dotfiles
./install.sh
```

**⚠️ Vai sobrescrever teus arquivos. Tamo junto.**

---

## O que está configurado

### Neovim

Configuração baseada no [LazyVim](https://lazyvim.org) com ajustes pessoais.

**Extras habilitados:**
- `yanky` — ring de clipboard com histórico de yanks
- `dial` — incrementa/decrementa valores com `<C-a>` / `<C-x>`
- `json` — suporte a JSON (schema, formatação)
- `mini-hipatterns` — destaca padrões no código (cores hex, TODOs, etc.)

**Plugins principais instalados:**
- **UI**: bufferline, lualine, noice, snacks, todo-comments
- **Busca**: flash.nvim (navegação rápida), grug-far (busca e substituição global)
- **Completion**: blink.cmp + friendly-snippets
- **LSP**: nvim-lspconfig, mason, mason-lspconfig, lazydev
- **Treesitter**: nvim-treesitter + textobjects + autotag
- **Git**: gitsigns
- **Formatação**: conform.nvim
- **Linting**: nvim-lint
- **REPL**: iron.nvim — envia linhas/seleções para Python/Julia com `<leader>r*`
- **Sessão**: persistence.nvim
- **Utilitários**: mini.ai, mini.pairs, mini.icons, plenary

**Colorscheme:** tokyonight (padrão) + catppuccin disponível.

**Formatadores/LSPs instalados via Mason:**
- Lua: `stylua`
- Shell: `shfmt`, `shellcheck`
- JS/TS: `prettier`, `eslint`
- Python: `ruff`, `pyright`

---

### Zsh

Configuração modular carregada pelo `.zshrc`. Os arquivos ficam em `zsh/config/`.

**`config/config`**
- Histórico de 1.000.000 de linhas com deduplicação
- Vi mode com cursor diferente por modo (block no normal, line no insert)
- Oh-My-Zsh com tema `omtheme` (customizado)
- Plugins: `git`, `zsh-autosuggestions`, `zsh-syntax-highlighting`

**`config/exports`**
- `EDITOR` e `VISUAL` apontam para `nvim`
- FZF com esquema de cores Tokyo Night
- `NVM` para Node.js e `pyenv` para Python
- `OLLAMA_HOST` configurado para servidor LLM local
- `uv`, `Bun`, `PNPM` no PATH

**`config/aliases`**
- `gitlog` — log bonito no terminal
- `killcode`, `killchrome`, `killnode`, `killpython`, `killffmpeg` — mata processos
- `nano` → `nvim`
- `updateall` — atualiza tudo de uma vez
- `makenote` — abre nvim em janela flutuante do tmux para anotações
- `tre` — tree ignorando `node_modules`, `.git`, `__pycache__`
- `j` → `just`, `zs` → `source ~/.zshrc`

**`config/functions`** (arquivo mais complexo, ~522 linhas)
- `componentTs` / `componentJs` — cria estrutura de componente React
- `dtouch` — `mkdir -p` + `touch` em um comando
- `convert_for_youtube` — converte vídeo com FFmpeg para upload no YouTube
- `aula_c` — comprime vídeo de aula com FFmpeg
- `tmuxns` — cria sessão tmux com janelas predefinidas
- `tmux_make_sessions` — cria sessões a partir de diretórios de projetos
- `tmux_respawn_all` — reseta e resincroniza histórico em todos os panes
- `sshc` — wrapper de SSH que indica estado no tmux
- `cleanNeovimLogs` — limpa logs e cache do Neovim
- `updateall` — atualiza Homebrew, pip, npm, nvim, tmux plugins e histórico
- `ollama_stop_all` / `ollama_update_models` — gerencia LLMs locais
- `backup_ssh` — faz backup criptografado (7zip) do diretório SSH

**`config/keybinds`**
- `jj` → ESC no vi mode
- Navegação hjkl no menu de completion
- Prompt com símbolo ❮/❯ conforme modo (normal/insert)

---

### Tmux

**`.tmux.conf`**

- Vi mode no copy-mode (hjkl)
- Numeração de janelas começa em 1
- Histórico de 30.000 linhas
- Auto-renumeração de janelas
- Clipboard: OSC 52 (funciona local, Docker e SSH)

**Keybindings customizados (`prefix` = `Ctrl+b`):**

| Atalho | Ação |
|---|---|
| `prefix + r` | Recarrega config |
| `prefix + C-l` | FZF para trocar janela |
| `prefix + C-n` | Popup com nvim para anotações |
| `prefix + C-p` | Popup com REPL Python |
| `prefix + C-h` | Popup com htop |
| `prefix + C-t` | Popup com terminal |
| `prefix + C-x` | Popup com `just` (task runner) |
| `prefix + C-w` | Alterna popup flutuante (sessões/janelas/panes) |

**Plugins (TPM):**
- `tmux-sensible` — defaults sensatos
- `tmux-resurrect` — salva e restaura sessões
- `tmux-continuum` — restaura automaticamente ao iniciar (salva a cada 5 min)

---

### Ghostty

Terminal com configuração em `ghostty/config`.

- **Tema**: `omtheme` (custom Tokyo Night)
- **Fonte**: JetBrains Mono 28pt, sem ligaduras
- **Janela**: tabs na parte inferior, padding horizontal de 16px
- **Cursor**: block, piscante
- **GTK**: instância única

---

### Git

Configuração em `git/.gitconfig`:

- Branch padrão: `main`
- Editor: `nvim`
- Pull com rebase por padrão
- `ignorecase = true`, `filemode = true`

---

### Scripts utilitários (`scripts/`)

- **`zsh_history_sync.py`** — deduplica e sincroniza histórico do Zsh entre máquinas

---

### i3wm

Ambiente de janelas tiling com tema Tokyo Night. Configuração via `include`
— o config original gerado pelo wizard não é substituído.

Documentação detalhada: [`docs/i3.md`](docs/i3.md)

**Keybindings customizados:**

| Atalho | Ação |
|--------|------|
| `$mod+d` | Rofi — launcher de aplicativos |
| `$mod+p` | Move workspace para monitor da esquerda |
| `$mod+Shift+p` | Captura de tela (Flameshot GUI) |
| `$mod+Shift+d` | Desativa protetor de tela (modo apresentação) |
| `$mod+Shift+a` | Reativa protetor de tela (5 min) |

**Status bar** (i3status com Nerd Font): `󰻠 CPU` `󰍛 MEM` `󰋊 DSK` `󰈀 IP` `󰁹 BAT` `󰥔 dd/mm/yyyy HH:MM`

---

### Fabric

Integração com o [fabric](https://github.com/danielmiessler/fabric) para
pipelines LLM no terminal. Padrões customizados em `fabric/patterns/`.

| Padrão | Descrição |
|--------|-----------|
| `cria_commit` | Gera mensagem de commit no padrão Conventional Commits em PT-BR |
| `corrige_pt` | Corrige texto em português preservando o tom original |

Uso:
```bash
git diff --staged | fabric -p cria_commit
echo "texto com erros" | fabric -p corrige_pt
```

---

### Fastfetch

Exibe informações do sistema ao abrir o terminal. Configurado em
`fastfetch/config.jsonc` para mostrar: OS, kernel, uptime, shell, CPU, GPU,
memória, disco, bateria e paleta de cores.

---

## Pós-instalação (passos manuais)

Após rodar o `install.sh`, o próprio script irá pausar e pedir que esses comandos sejam executados em um novo terminal:

**Node (via nvm):**

```bash
nvm install --lts
nvm install-latest-npm
npm i -g prettier
npm i -g tree-sitter-cli   # necessário para o nvim-treesitter compilar parsers
```

**Python (via pyenv + uv):**

```bash
pyenv install 3.13.5       # ou versão mais recente
pyenv global 3.13.5
uv tool install pyright
uv tool install ruff
```

**Depois de voltar ao script:**

1. Abrir o Neovim e aguardar o Lazy.nvim instalar os plugins
2. No tmux: `prefix + I` para instalar os plugins do TPM
3. Reiniciar o terminal

---

Feito com ódio, café e um toque de amor.
