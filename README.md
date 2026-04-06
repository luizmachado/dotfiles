# dotfiles

Fiz os testes no Ubuntu 24.04 e no macOS Sequoia (ARM). Todos os testes foram
feitos com uma instalação limpa dos sistemas operacionais.

Mesmo assim, recomendo que você abra o arquivo `install.sh` e execute os
comandos linha a linha observando o que cada linha vai fazer. Se você executar
esse script no seu sistema, ele vai rodar direto e não para mais, então ele
sairá sobrescrevendo, apagando, criando e instalando tudo de uma vez (pra mim é
mais fácil assim).

Se mesmo com o aviso ainda quer rodar, faça isso com o git instalado:

```bash
git clone git@github.com:luizomf/dotfiles.git ~/dotfiles
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
- `brewupdate`, `updateall` — atualiza tudo de uma vez
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
- `commit_dotfiles` — sincroniza dotfiles entre máquinas via git + SSH
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
- Clipboard: `pbcopy` no macOS, OSC 52 no Linux

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

### Homebrew (`homebrew/Brewfile`)

Instalação completa com:

- **CLI**: fzf, ripgrep, fd, bat, tree, htop, btop, watch, gh, just, shellcheck
- **Editores**: neovim, vim
- **Mídia**: ffmpeg, auto-editor, sox, vhs
- **Build**: cmake, ninja-build, pkgconf, automake
- **Rede**: wireguard-tools, wrk
- **LLM local**: ollama
- **Compressão**: p7zip, unzip
- **macOS (casks)**: Ghostty, Docker Desktop, VS Code, Alfred, alt-tab, OBS, CapCut, VLC, AltDente, Keycastr

**Extensões VS Code instaladas:**
- ruff, ESLint, Prettier, shellcheck, shell-format, Even Better TOML
- Python, Pylance, Debugpy
- Tailwind CSS, IntelliCode, EditorConfig
- Code Spell Checker (EN + PT-BR)

**Ferramentas Python via `uv`:**
- mypy, pyright, ruff, langgraph-cli

---

### Scripts utilitários (`scripts/`)

- **`wg_generator.sh`** — gera configs WireGuard para múltiplos nós da rede
- **`zsh_history_sync.py`** — deduplica e sincroniza histórico do Zsh entre máquinas

---

### Fastfetch

Exibe informações do sistema ao abrir o terminal. Configurado em
`fastfetch/config.jsonc` para mostrar: OS, kernel, uptime, shell, CPU, GPU,
memória, disco, bateria e paleta de cores.

---

## Pós-instalação (passos manuais)

Após rodar o `install.sh`, ainda é necessário:

1. Abrir o Neovim e aguardar o Lazy.nvim instalar os plugins
2. No tmux: `prefix + I` para instalar os plugins do TPM
3. Instalar versão do Python via pyenv: `pyenv install <versão>`
4. Instalar ferramentas Python via uv: `uv tool install ruff mypy pyright`
5. Instalar Prettier globalmente: `npm install -g prettier`
6. Reiniciar o terminal

---

Feito com ódio, café e um toque de amor.
