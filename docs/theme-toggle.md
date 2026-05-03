# Toggle de Tema (Escuro/Claro)

Sistema unificado de alternância de tema escuro/claro em todo o stack: i3wm, rofi, tmux, Ghostty e Neovim.

---

## Visão geral

O estado do tema é persistido em `~/.theme-mode` (contém `dark` ou `light`).
Um script central (`scripts/toggle-theme.sh`) coordena a alternância em todas as ferramentas.

| Ferramenta | Tema escuro | Tema claro |
|---|---|---|
| i3wm | Tokyo Night padrão | Tokyo Night adaptado |
| rofi | Tokyo Night padrão | Tokyo Night adaptado |
| tmux | `~/.tmux-theme.conf` dinâmico | `~/.tmux-theme.conf` dinâmico |
| Ghostty | `~/.theme-active-ghostty.conf` | `~/.theme-active-ghostty.conf` |
| Neovim | `tokyonight` | `tokyonight` (com ajustes de background) |

---

## Atalhos

| Contexto | Atalho | Ação |
|---|---|---|
| **i3wm** | `$mod+t` | Toggle tema sistema (i3 + rofi + tmux + Ghostty) |
| **Neovim** | `<leader>ut` | Toggle tema Neovim (escreve `~/.theme-mode`, recarrega) |
| **REPL** | `<leader>ro` | Toggle layout REPL (vertical ↔ horizontal) — não afeta tema |

---

## Como funciona

### Sistema (i3 + rofi + tmux + Ghostty)

1. Pressione `$mod+t` em i3wm
2. Script `scripts/toggle-theme.sh` é executado:
   - Lê `~/.theme-mode` (dark ou light)
   - Alterna para o oposto
   - Troca symlinks em `~/.config/i3/theme.conf` e `~/.config/rofi/config.rasi`
   - Copia temas para `~/.tmux-theme.conf` e `~/.theme-active-ghostty.conf`
   - Envia `SIGHUP` ao i3 para recarregar config
3. Todas as ferramentas refletem o novo tema imediatamente

### Neovim

1. Pressione `<leader>ut` (toggle via Snacks.toggle)
2. Plugin `nvim/lua/plugins/colorscheme.lua`:
   - Lê `~/.theme-mode` no startup
   - Ao toggle, escreve novo estado em `~/.theme-mode`
   - Recarrega o colorscheme com ajustes via `vim.g.tokyonight_transparent`

---

## Arquivos de tema

```
i3/
├── theme.conf              # Symlink para theme-dark.conf ou theme-light.conf
├── theme-dark.conf         # Cores Tokyo Night (escuro)
└── theme-light.conf        # Cores Tokyo Night adaptadas (claro)

i3/rofi/
├── config.rasi             # Symlink para config-dark.rasi ou config-light.rasi
├── config-dark.rasi        # Rofi Tokyo Night (escuro)
└── config-light.rasi       # Rofi Tokyo Night adaptado (claro)

tmux/
├── .tmux.conf              # Include ~/.tmux-theme.conf
├── theme-dark.conf         # Tema tmux escuro
└── theme-light.conf        # Tema tmux claro

ghostty/
├── config                  # Include ~/.theme-active-ghostty.conf
├── themes/dark.conf        # Tema Ghostty escuro
└── themes/light.conf       # Tema Ghostty claro

nvim/lua/plugins/
└── colorscheme.lua         # Detecção e toggle de tema
```

---

## Estado persistido

**`~/.theme-mode`** (criado por `install.sh`, padrão: `dark`)
```
dark
```

**`~/.tmux-theme.conf`** (criado dinamicamente)
- Inclusão do `~/.tmux.conf` durante startup
- Atualizado por `scripts/toggle-theme.sh` e `install.sh`

**`~/.theme-active-ghostty.conf`** (criado dinamicamente)
- Inclusão de `ghostty/config` durante startup
- Atualizado por `scripts/toggle-theme.sh` e `install.sh`

---

## Integração com install.sh

O `install.sh` é responsável por:
1. Criar `~/.theme-mode` com valor padrão `dark` (se não existir)
2. Criar symlinks iniciais para theme-dark.conf e config-dark.rasi
3. Copiar tema inicial para `~/.tmux-theme.conf` e `~/.theme-active-ghostty.conf`
4. Criar o binding `$mod+t` no i3 que chama `scripts/toggle-theme.sh`

Execução idempotente: sempre remove + recria symlinks para garantir estado correto.

---

## Caso de uso: alternância durante o dia

1. **Manhã (tema claro):**
   - Pressione `$mod+t` em i3wm
   - Todos os painéis e apps se ajustam imediatamente
   - Fácil de ler em local com muita luz natural

2. **Noite (tema escuro):**
   - Pressione `$mod+t` novamente
   - Volta ao padrão Tokyo Night escuro

3. **Dentro do Neovim:**
   - Pressione `<leader>ut` se quiser ajustar independentemente
   - O arquivo `.theme-mode` é sincronizado
   - Na próxima reabertura de outro terminal/app, o novo tema é refletido

---

## Troubleshooting

| Problema | Causa | Solução |
|---|---|---|
| Tema não muda em i3 | `scripts/toggle-theme.sh` não é executado | Verificar binding `$mod+t` em `i3/luiz.conf` |
| Ghostty não muda | `~/.theme-active-ghostty.conf` não foi criado | Rodar `install.sh` |
| tmux não muda | Arquivo `~/.tmux-theme.conf` fora de sincronismo | Executar `scripts/toggle-theme.sh` manualmente |
| Neovim não acompanha | Arquivo `~/.theme-mode` não sincronizado | Pressionar `<leader>ut` novamente ou reabrir Neovim |

