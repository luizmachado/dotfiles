# REPL e Execução de Código

Ambiente de desenvolvimento interativo para Python, Julia e outras linguagens,
baseado em [iron.nvim](https://github.com/Vigemus/iron.nvim) e
[NotebookNavigator.nvim](https://github.com/GCBallesteros/NotebookNavigator.nvim).

---

## Visão geral

| Plugin | Papel |
|---|---|
| **iron.nvim** | Abre e gerencia o REPL; envia código via keymaps e motions |
| **NotebookNavigator.nvim** | Navega e executa células `# %%` integrado ao iron |

O REPL abre como split vertical à direita (40% da tela). O filetype do buffer
determina qual REPL é iniciado automaticamente: Python → `python3`, Julia → `julia`.

---

## Iniciando e controlando o REPL

| Atalho | Ação |
|---|---|
| `<leader>rs` | Abrir REPL (detecta filetype) |
| `<leader>rr` | Reiniciar REPL (preserva split) |
| `<leader>rf` | Focar janela do REPL |
| `<leader>rh` | Ocultar REPL (mantém sessão ativa) |
| `<leader>ro` | Alternar layout: vertical (direita) ↔ horizontal (inferior) |
| `<leader>r<space>` | Interromper execução em andamento (KeyboardInterrupt) |
| `<leader>rx` | Limpar saída do REPL |
| `<leader>rq` | Fechar REPL |

> Dica: `<leader>rh` oculta sem encerrar — variáveis e estado são preservados.
> Use `<leader>rs` de novo para reabrir o mesmo REPL.

---

## Enviando código ao REPL

### Linha e parágrafo

| Atalho | Ação |
|---|---|
| `<leader>rl` | Enviar linha atual |
| `<leader>rp` | Enviar parágrafo atual (bloco separado por linhas vazias) |
| `<leader>ru` | Enviar do início do arquivo até o cursor |
| `<leader>rF` | Enviar arquivo inteiro |
| `<leader>r<cr>` | Enviar `Enter` para o REPL (útil em prompts interativos) |

### Motions e seleção visual

`<leader>rc` funciona como **operador**: aceita qualquer motion do Vim após ele.

| Exemplo | O que faz |
|---|---|
| `<leader>rcip` | Envia o parágrafo interno (`ip`) |
| `<leader>rc3j` | Envia as próximas 3 linhas |
| `<leader>rcG` | Envia do cursor até o fim do arquivo |
| Visual + `<leader>rc` | Envia a seleção visual |

### Marks (regiões arbitrárias)

Útil para marcar um bloco de interesse e enviá-lo repetidamente.

| Atalho | Ação |
|---|---|
| Visual + `<leader>rm` | Marca a seleção atual como região |
| `<leader>rM` | Envia a região marcada ao REPL |

---

## Code Cells (`# %%`)

Divida o arquivo em células com o marcador `# %%` (Python) ou `# %%` (Julia).
Cada célula é um bloco de código que pode ser executado independentemente.

```python
# %%
x = 10
y = 20

# %%
resultado = x + y
print(resultado)

# %% Análise de resultado
print(f"Resultado: {resultado}")
```

### Navegação entre células

| Atalho | Ação |
|---|---|
| `]c` | Mover para a próxima célula |
| `[c` | Mover para a célula anterior |

### Execução de células

| Atalho | Ação |
|---|---|
| `<leader>rn` | Executar célula atual |
| `<leader>ra` | Executar todas as células acima do cursor (reproduzir estado) |
| `<leader>rA` | Executar todas as células do arquivo em sequência |

### Text objects de células

Com `mini.ai` (já instalado):

| Atalho | O que seleciona |
|---|---|
| `vac` | Seleciona célula inteira (incluindo `# %%`) |
| `vic` | Seleciona conteúdo da célula (excluindo marcador) |
| `dac` | Apaga célula inteira |
| `<leader>rcac` | Envia célula inteira ao REPL via motion |

---

## Linguagens suportadas

| Linguagem | Comando | Observações |
|---|---|---|
| Python | `python3` | Padrão do sistema |
| Julia | `julia --startup-file=no --color=yes` | Startup rápido, saída colorida |
| Lua | `lua` | Para scripts Lua |
| Shell | `zsh` | Para scripts de shell |

---

## Workflow recomendado

### Desenvolvimento iterativo

1. Abra o REPL com `<leader>rs`
2. Escreva o código em blocos separados por `# %%`
3. Use `<leader>rn` para executar célula a célula
4. Ajuste o código e re-execute com `<leader>rn`
5. Quando o arquivo estiver pronto: `<leader>rF` para rodar tudo

### Exploração de dados / depuração

1. Posicione o cursor em uma variável ou expressão
2. `<leader>rl` — avalia a linha
3. `<leader>rp` — avalia o bloco completo
4. `<leader>ra` — reconstrói o estado do REPL executando tudo acima

### Trabalho com funções longas

1. Selecione a função em modo visual (`Vip` ou `V}`)
2. `<leader>rc` — envia a seleção
3. No REPL, chame a função com os argumentos desejados

### Verificar mapa de atalhos

`<leader>r?` abre o which-key com todos os atalhos do namespace `r`.

---

## Referência completa de keymaps

| Atalho | Modo | Ação |
|---|---|---|
| `<leader>rs` | n | REPL: abrir |
| `<leader>rr` | n | REPL: reiniciar |
| `<leader>rf` | n | REPL: focar |
| `<leader>rh` | n | REPL: ocultar |
| `<leader>ro` | n | REPL: alternar layout vertical/horizontal |
| `<leader>rl` | n | Enviar linha atual |
| `<leader>rp` | n | Enviar parágrafo atual |
| `<leader>rc` | n, v | Enviar motion / seleção visual |
| `<leader>rF` | n | Enviar arquivo inteiro |
| `<leader>ru` | n | Enviar até o cursor |
| `<leader>rm` | v | Marcar seleção como região |
| `<leader>rM` | n | Enviar região marcada |
| `<leader>rn` | n | Executar célula atual (`# %%`) |
| `<leader>ra` | n | Executar células acima |
| `<leader>rA` | n | Executar todas as células |
| `<leader>r<space>` | n | Interromper execução |
| `<leader>rx` | n | Limpar REPL |
| `<leader>rq` | n | Fechar REPL |
| `]c` | n | Próxima célula |
| `[c` | n | Célula anterior |
