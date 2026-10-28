# CLAUDE.md — Contexto para o Claude Code

Este repositório contém os dotfiles pessoais de Luiz Machado, exclusivamente
para Linux (Ubuntu 24.04 / Debian 12).

---

## Estrutura do projeto

```
dotfiles/
├── i3/               # i3wm: theme.conf, i3status.conf, luiz.conf, rofi/
├── nvim/             # Neovim (LazyVim)
├── tmux/             # Tmux + TPM + scripts
├── zsh/              # Zsh + Oh My Zsh
├── ghostty/          # Terminal Ghostty
├── git/              # .gitconfig
├── fabric/           # Padrões customizados do fabric (LLM CLI)
├── fastfetch/        # Configuração do fastfetch
├── zathura/          # Visualizador de PDF (vimtex) + temas dark/light
├── scripts/          # toggle-theme.sh, notes-popup.sh, install-{go,nvim,tools}.sh, zsh_history_sync.py
├── docs/             # Documentação por ferramenta
└── install.sh        # Script de instalação completo
```

---

## Princípios de design

- **Linux only** — Ubuntu 24.04 e Debian 12. Sem suporte a macOS.
- **Idempotente** — `install.sh` pode ser rodado múltiplas vezes sem efeitos colaterais.
- **Não-destrutivo** — configs do sistema são modificadas de forma aditiva (includes, patches via sed). O `~/.config/i3/config` original nunca é substituído.
- **Tema** — Tokyo Night em Neovim, tmux, i3wm, rofi e Zathura; Ghostty, prompt zsh e FZF usam a paleta própria `omtheme`.
  Modo dark/light alternado por `scripts/toggle-theme.sh` (estado em `~/.theme-mode`).
- **Sem Homebrew** — pacotes via apt; Go via tarball oficial (`scripts/install-go.sh`).
- **Nerd Fonts** — JetBrainsMono Nerd Font instalada em `~/.local/share/fonts/NerdFonts/` para ícones no i3bar, rofi e terminal.

---

## Convenções de código (install.sh)

- Funções de log: `loginfo`, `logsuccess`, `logwarning`, `logerror`
- Symlinks: sempre `rm -f destino && ln -sf origem destino` (nunca usar `-n`)
- Includes do i3: padrão **remove + re-adiciona** (não "verifica + appenda") para garantir idempotência
- Patches no `~/.config/i3/config`: via `sed -i` aditivo — nunca substituir o arquivo inteiro
- Variáveis de ambiente sensíveis: carregadas de `~/.dotfiles.local` (não versionado)

---

## i3wm — estratégia de configuração

O `~/.config/i3/config` original (gerado pelo `i3-config-wizard`) **não é substituído**.
As customizações entram via `include`:

| Arquivo | Conteúdo |
|---------|----------|
| `~/.config/i3/luiz_dotfiles.conf` → `i3/luiz.conf` | Keybindings customizados |
| `~/.config/i3/theme.conf` → `i3/theme.conf` | Fonte, cores Tokyo Night, bordas, gaps, picom |

O `install.sh` também aplica dois patches no config principal:
1. Cores Tokyo Night no bloco `bar {}` (font + `colors {}`)
2. Substituição do `dmenu_run` por `rofi -show drun` no binding `$mod+d`

**Atenção:** o i3 usa vírgula como separador de múltiplos comandos no parser IPC.
Nunca usar vírgulas em argumentos de `exec` no config (ex.: `-modi drun,run` causa parse error).

---

## Armadilhas conhecidas

| Problema | Causa | Solução |
|----------|-------|---------|
| Duplicate keybinding no i3 | `include` adicionado duas vezes ao config | Padrão remove+re-add no install.sh |
| Parse error no `exec` do i3 | Vírgula em args interpretada como separador | Usar `rofi -show drun` (sem `-modi`) |
| `go install fabric` falha | Main package movido para `cmd/fabric` | `go install github.com/danielmiessler/fabric/cmd/fabric@latest` |
| Nerd Font sem ícones | Fonte não instalada ou nome errado no pango | Nome correto: `JetBrainsMono Nerd Font` |
| install.sh apaga ~/.pyenv ou ~/.nvm | `command -v pyenv/nvm` falha no script (fora do PATH / nvm é função) | Testar diretório/arquivo (`[ -d ~/.pyenv ]`, `[ -s ~/.nvm/nvm.sh ]`) |
| `fd` não encontrado | Debian/Ubuntu instalam como `fdfind` | install.sh cria `~/.local/bin/fd → fdfind` |
| `VimTeX does not support your version of Vim` | vimtex atualizado exige Neovim mais novo | `scripts/install-nvim.sh` (também no `updateall`) |
| nvim-treesitter não compila parsers | `tree-sitter` CLI do apt/npm antigo (precisa ≥ 0.26.1) | `scripts/install-tools.sh` (binário em `~/.local/bin`, que vem antes no PATH) |
| `<leader>ca` (Code Action) demora | calendar-vim (dependência do Telekasten) mapeia `<leader>cal`/`<leader>caL` | Intencional: mantido para acessar o calendário |
| Nota do Telekasten sem render/LSP ou sem cores de `[[link]]`/`#tag` | ft `telekasten` não tem parser; o `treesitter.start` desliga o syntax regex | `telekasten.lua`: `language.register("markdown", "telekasten")` + reativa `syntax=telekasten` no FileType; marksman com `get_language_id` → markdown |

---

## Pacotes instalados pelo install.sh

**apt:** git, build-essential, ripgrep, fzf, bat, tmux, zsh, tree, htop, ffmpeg,
fonts-firacode, fonts-jetbrains-mono, rofi, picom, fontconfig, fd-find, flameshot, libnotify-bin,
p7zip-full, lua5.4, unzip, xclip,
texlive-latex-extra, texlive-fonts-recommended, texlive-lang-portuguese, texlive-bibtex-extra, biber, chktex,
latexmk, zathura, zathura-pdf-poppler, xdotool

**Go:** tarball oficial em `/usr/local/go` (`scripts/install-go.sh`, também chamado pelo `updateall`)

**Neovim:** última release compilada do source e instalada como .deb via cpack (`scripts/install-nvim.sh`)

**Plugins do Neovim:** `nvim --headless "+Lazy! sync" +qa` no `install.sh` e no `updateall` (versões em `nvim/lazy-lock.json`, versionado). Picker: Telescope (`vim.g.lazyvim_picker`), exigido pelo Telekasten.

**~/.local/bin (GitHub Releases, `scripts/install-tools.sh`):** tree-sitter CLI, lazygit,
videobay (GUI do yt-dlp, só x86_64; versão em `~/.local/share/videobay/version`, atalho `$mod+y` no i3, `.desktop` para o rofi)

**Spell:** `pt.utf-8.spl` em `~/.local/share/nvim/site/spell/`

**Fontes:** JetBrainsMono Nerd Font (GitHub Releases → `~/.local/share/fonts/NerdFonts/`)

**Go (go install):** `fabric` (`github.com/danielmiessler/fabric/cmd/fabric@latest`)

**Node (manual pós-install):** prettier

**Python (manual pós-install):** pyright, ruff (via uv tool)

---

## Symlinks gerenciados

| Symlink | Origem |
|---------|--------|
| `~/.zshrc` | `dotfiles/zsh/.zshrc` |
| `~/.zprofile` | `dotfiles/zsh/.zprofile` |
| `~/.zshenv` | `dotfiles/zsh/.zshenv` |
| `~/.gitconfig` | `dotfiles/git/.gitconfig` |
| `~/.tmux.conf` | `dotfiles/tmux/.tmux.conf` |
| `~/.vimrc` | `dotfiles/vim/.vimrc` |
| `~/.config/nvim` | `dotfiles/nvim/` |
| `~/.config/ghostty` | `dotfiles/ghostty/` |
| `~/.config/i3/luiz_dotfiles.conf` | `dotfiles/i3/luiz.conf` |
| `~/.config/i3/theme.conf` | `dotfiles/i3/theme.conf` ou `theme-light.conf` (conforme `~/.theme-mode`) |
| `~/.config/i3status/config` | `dotfiles/i3/i3status.conf` |
| `~/.config/rofi/config.rasi` | `dotfiles/i3/rofi/config.rasi` ou `config-light.rasi` |
| `~/.config/fastfetch/config.jsonc` | `dotfiles/fastfetch/config.jsonc` |
| `~/.config/zathura/zathurarc` | `dotfiles/zathura/zathurarc` |
| `~/.config/fabric/patterns/*` | `dotfiles/fabric/patterns/*` |

Cópias (não symlinks), reescritas pelo `toggle-theme.sh`: `~/.tmux-theme.conf` ← `tmux/theme-{mode}.conf`,
`~/.theme-active-ghostty.conf` ← `ghostty/themes/{mode}.conf`, `~/.config/zathura/theme-active` ← `zathura/themes/{mode}`.
