# Zsh

Configuração modular carregada pelo `.zshrc`. Os módulos ficam em `zsh/config/`.

---

## Estrutura de arquivos

| Arquivo | Responsabilidade |
|---|---|
| `.zshrc` | Carrega todos os módulos |
| `.zshenv` | PATH para Homebrew (macOS e Linux) |
| `.zprofile` | Inicialização do ambiente Homebrew |
| `config/config` | Opções do shell, histórico, plugins |
| `config/exports` | Variáveis de ambiente |
| `config/aliases` | Aliases |
| `config/functions` | Funções customizadas |
| `config/keybinds` | Keybindings e vi mode |
| `config/omtheme.zsh-theme` | Tema do prompt |

---

## Vi mode

Habilitado com `bindkey -v`.

| Tecla | Modo | Ação |
|---|---|---|
| `jj` | insert | Sair para o modo normal |
| `h` | menu de completion | Mover cursor para trás |
| `l` | menu de completion | Mover cursor para frente |
| `k` | menu de completion | Mover para cima |
| `j` | menu de completion | Mover para baixo |

**Cursor visual por modo:**
- Normal (VICMD): cursor block (`█`), símbolo `❮` em vermelho
- Insert: cursor line (`|`), símbolo `❯` em verde

---

## Aliases

| Alias | Expansão | Descrição |
|---|---|---|
| `gitlog` | `git log --oneline --graph ...` | Log bonito com grafo |
| `gitreset` | `git add . && git reset --hard` | Descarta todas as mudanças |
| `pipupgrade` | `pip list --outdated \| ... pip install -U` | Atualiza todos os pacotes pip |
| `pipdeleteall` | `pip freeze \| xargs pip uninstall -y` | Remove todos os pacotes pip |
| `killcode` | `pkill -f "Visual Studio Code"` | Mata o VS Code |
| `killchrome` | `pkill -f "Google Chrome"` | Mata o Chrome |
| `killnode` | `pkill -f node` | Mata processos node |
| `killpython` | `pkill -f python` | Mata processos python |
| `killffmpeg` | `pkill -f ffmpeg` | Mata processos ffmpeg |
| `killadobe` | `pkill -f Adobe` | Mata todos os processos Adobe |
| `nano` | `nvim` | Redireciona nano para nvim |
| `brewupdate` | update + upgrade + omz update + cleanup + Brewfile | Atualização completa do Homebrew |
| `cleanmacos` | purge + flush DNS + clear logs + empty trash | Limpeza do macOS |
| `zs` | `source ~/.zshrc` | Recarrega a configuração do shell |
| `brewcheck` | `brew leaves \| sort` | Lista pacotes Homebrew top-level |
| `tre` | `tree` ignorando .git, node_modules, __pycache__, .venv, dist | Tree limpo |
| `j` | `just` | Atalho para o task runner just |
| `makenote` | `tmux new-window ...make_note.sh` | Abre nota rápida no tmux |
| `s` | `sudo` | Atalho para sudo |

---

## Funções

### Output e logging

| Função | Descrição |
|---|---|
| `log msg` | Imprime mensagem em ciano |
| `loginfo msg` | Imprime com marcador azul |
| `logsuccess msg` | Imprime com marcador verde |
| `logwarning msg` | Imprime com marcador amarelo |
| `logerror msg` | Imprime com marcador vermelho |

### Criação de arquivos e componentes

| Função | Descrição | Uso |
|---|---|---|
| `dtouch path` | Cria diretório e arquivo em um comando | `dtouch src/components/Button.tsx` |
| `componentTs name` | Cria componente React TypeScript (index.tsx, spec.tsx, test.tsx, stories.tsx, module.css) | `componentTs Button` |
| `componentJs name` | Cria componente React JavaScript | `componentJs Button` |

### Vídeo e mídia

| Função | Descrição | Uso |
|---|---|---|
| `aula_c filename` | Comprime vídeo para 1080p H.264 com lanczos | `aula_c aula01.mp4` |
| `convert_for_youtube -i input -o output [-s]` | Converte para YouTube (H.264, AAC 48kHz, 192kbps); `-s` adiciona lofi de fundo | `convert_for_youtube -i raw.mp4 -o final.mp4` |

### Sistema e utilitários

| Função | Descrição | Uso |
|---|---|---|
| `memoryUsage pattern` | Mostra uso de memória em MB dos processos que batem com o padrão | `memoryUsage node` |
| `deletePythonCache` | Remove `__pycache__`, `.pytest_cache`, `.tox`, `*.egg-info`, `build`, `dist`, `.pyc`, `.pyo` | `deletePythonCache` |
| `show_colors` | Exibe todas as 256 cores do terminal com seus códigos | `show_colors` |
| `gitconfig name email` | Configura git interativamente (nome, email, autocrlf, eol) | `gitconfig "Luiz" "email@..."` |
| `iterm` | Abre o diretório atual no iTerm2 (macOS) | `iterm` |
| `help [command]` | Ajuda de builtins bash (zsh não tem help nativo) | `help cd` |
| `backup_ssh` | Faz backup criptografado (7z) do diretório .ssh no Desktop | `backup_ssh` |
| `killgui` | Para a interface gráfica (sddm + wayland) | `killgui` |
| `startgui` | Inicia a interface gráfica | `startgui` |

### Tmux

| Função | Descrição | Uso |
|---|---|---|
| `tmuxns name [win1 win2...]` | Cria sessão tmux no PROJECTS_DIR com janelas | `tmuxns myproject code term` |
| `tmux_make_sessions [dir]` | Cria sessões tmux para cada subdiretório do PROJECTS_DIR | `tmux_make_sessions` |
| `tmux_run_all_panes cmd` | Envia comando para todos os panes abertos | `tmux_run_all_panes "git status"` |
| `tmux_respawn_all` | Reseta e resincroniza todos os panes (histórico, zshrc, logs) | `tmux_respawn_all` |
| `sshc host` | Wrapper de SSH com integração tmux (indica estado SSH na barra) | `sshc servidor` |

### Manutenção e atualização

| Função | Descrição |
|---|---|
| `updateall` | Atualiza tudo: Homebrew, Oh-My-Zsh, npm, pyenv, uv tools, histórico |
| `cleanNeovimLogs` | Remove logs e cache do Neovim |
| `restart_terminal` | Salva histórico, recarrega .zshrc e resincroniza tmux |

### Ollama (LLM local)

| Função | Descrição |
|---|---|
| `ollama_stop_all` | Para todos os modelos Ollama em execução |
| `ollama_update_models` | Atualiza todos os modelos instalados |

---

## FZF

Configuração visual com esquema de cores Tokyo Night.

| Opção | Valor |
|---|---|
| Layout | `reverse` (resultados acima do prompt) |
| Prompt | `> ` |
| Pointer | `◆` |
| Marker | `>` |
| Separator | `─` |
| Scrollbar | `│` |
| Preview | bordas arredondadas |

---

## Tema (omtheme)

O que o prompt exibe, da esquerda para a direita:

1. `[SSH]` — visível apenas em sessão SSH
2. Diretório atual em amarelo (`%1~`)
3. Status git: `⭑` verde (clean) ou `✱` vermelho (dirty), entre parênteses ciano
4. Código de saída: `[✔]` verde em sucesso, `[✖ N]` vermelho em falha
5. Nome do virtualenv Python ativo (ciano claro)
6. Hostname da máquina em magenta
7. Símbolo vi mode na linha seguinte: `❮` (normal) ou `❯` (insert)

---

## Variáveis de ambiente relevantes

| Variável | Valor | Efeito |
|---|---|---|
| `EDITOR` / `VISUAL` | `nvim` | Editor padrão do sistema |
| `TABSIZE` | `2` | Tamanho de tab |
| `PROJECTS_DIR` | `~/Desktop/tutoriais_e_cursos` | Usado por funções tmux |
| `OLLAMA_HOST` | `127.0.0.1:11434` | Servidor LLM local |
| `KEYTIMEOUT` | `30` | Timeout de tecla no vi mode (ms) |
| `BAT_STYLE` | `header` | Estilo padrão do `bat` |

---

## Histórico

- 1.000.000 de linhas em memória e no arquivo
- Compartilhado entre sessões (`SHARE_HISTORY`)
- Sem duplicatas (`HIST_IGNORE_ALL_DUPS`)
- Entradas com espaço inicial não são salvas (`HIST_IGNORE_SPACE`)
- Sincronia entre máquinas via `scripts/zsh_history_sync.py`
