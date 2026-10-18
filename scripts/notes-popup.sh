#!/usr/bin/env bash
# Abre o nvim de notas numa janela flutuante (Ghostty + sessão tmux "notas" em ~/notes).
# Chamado pelo i3 ($mod+n / $mod+Shift+n); a regra de flutuação está em i3/luiz.conf.
# Uso: notes-popup.sh diaria|reuniao
set -euo pipefail

case "${1:-diaria}" in
diaria) nvim_cmd="Telekasten goto_today" ;;
reuniao) nvim_cmd="NotaReuniao" ;;
*)
	echo "uso: $0 diaria|reuniao" >&2
	exit 1
	;;
esac

SESSION="notas"
NOTES_DIR="$HOME/notes"
CLASS="com.dotfiles.notas" # precisa ser um application ID válido do GTK

# Cada chamada abre o nvim numa janela nova do tmux; a sessão é criada se não existir
if tmux has-session -t "$SESSION" 2>/dev/null; then
	tmux new-window -t "$SESSION:" -c "$NOTES_DIR" "nvim -c '$nvim_cmd'"
else
	tmux new-session -d -s "$SESSION" -c "$NOTES_DIR" "nvim -c '$nvim_cmd'"
fi

# Janela flutuante já aberta: só traz o foco. Senão, abre o Ghostty preso à sessão
if ! i3-msg -q "[class=\"$CLASS\"] focus" 2>/dev/null; then
	ghostty --class="$CLASS" -e tmux attach -t "$SESSION" &
	disown
fi
