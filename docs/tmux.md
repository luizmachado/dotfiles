# Tmux

Prefix padrão: `Ctrl+b`.

---

## Keybindings

| Atalho | Ação |
|---|---|
| `<prefix> r` | Recarrega `tmux.conf` |
| `<prefix> C-l` | Fuzzy finder de janelas (fzf) |
| `<prefix> C-w` | Alterna popup flutuante (sessão `float_popup`) |
| `<prefix> C-n` | Popup: nvim para anotação rápida (60%×60%) |
| `<prefix> C-p` | Popup: REPL Python (60%×60%) |
| `<prefix> C-h` | Popup: htop (80%×80%) |
| `<prefix> C-t` | Popup: terminal (80%×80%) |
| `<prefix> C-x` | Popup: `just` recipe runner (80%×80%) |

---

## Copy mode (vi)

| Tecla | Ação |
|---|---|
| `v` | Iniciar seleção |
| `y` | Copiar seleção para clipboard |
| `Enter` | Copiar e sair do copy mode |

Clipboard: `pbcopy` no macOS, OSC 52 no Linux/SSH.

---

## Popups

Todos os popups são janelas flutuantes centralizadas que podem ser fechadas com `q` ou `Ctrl+c`.

| Atalho | Ferramenta | Tamanho |
|---|---|---|
| `C-n` | nvim (`/tmp/quicknote.tmp`) | 60%×60% |
| `C-p` | Python REPL | 60%×60% |
| `C-h` | htop | 80%×80% |
| `C-t` | Terminal (shell) | 80%×80% |
| `C-x` | just (task runner) | 80%×80% |
| `C-w` | Sessão flutuante persistente | 95%×95% |

---

## Scripts

### `fzf.sh` — seletor de janelas

Listagem de todas as janelas abertas em todas as sessões com fzf. Exibe `SESSAO:ID NOME PID PANE`. Ativado por `<prefix> C-l`.

### `make_note.sh` — anotação rápida

Abre o nvim em `/tmp/quicknote.tmp`. Ao salvar e fechar, o conteúdo é processado pelo Claude (claude-opus-4-6), que lê instruções em `$PROJECTS_DIR/notes/AGENTS.md` e commita automaticamente no repositório de notas.

### `popup.sh` — terminal flutuante persistente

Cria (ou reutiliza) a sessão `float_popup:term`. Abre em 95%×95% centralizado. Ao fechar, a sessão permanece em background para ser reutilizada. Ativado por `<prefix> C-w`.

---

## Plugins (TPM)

| Plugin | Função |
|---|---|
| `tmux-sensible` | Defaults sensatos (resize, escape-time, etc.) |
| `tmux-resurrect` | Salva e restaura sessões/janelas/panes |
| `tmux-continuum` | Salva automaticamente a cada 5 min e restaura ao iniciar |

Para instalar: `<prefix> I`. Para atualizar: `<prefix> U`.

---

## Configurações notáveis

| Opção | Valor | Efeito |
|---|---|---|
| `history-limit` | 30000 | Linhas de scrollback por pane |
| `base-index` | 1 | Janelas começam em 1 (não 0) |
| `pane-base-index` | 1 | Panes começam em 1 |
| `renumber-windows` | on | Renumera janelas ao fechar uma |
| `allow-rename` | off | Não renomeia janelas automaticamente |
| `mouse` | off | Mouse desabilitado |
| `mode-keys` | vi | Vi mode no copy-mode |
| `default-shell` | `/bin/zsh` | Shell padrão para todos os panes |
| `@continuum-save-interval` | 5 | Salva sessão a cada 5 minutos |

---

## Status bar

- Esquema de cores: ciano/preto
- Esquerda: nome da sessão + indicador `[SSH]` quando conectado via SSH
- Direita: hostname + data
- Janela ativa: fundo preto, texto branco
- Indicador de prefix ativo: `✼` no título do terminal
