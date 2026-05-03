#!/bin/bash
# Alterna entre tema escuro e claro em todo o stack: i3, rofi, tmux, Ghostty.
# Estado persistido em ~/.theme-mode (dark|light).

STATE_FILE="$HOME/.theme-mode"
DOTFILES="$HOME/dotfiles"

current=$(cat "$STATE_FILE" 2>/dev/null || echo "dark")

if [ "$current" = "dark" ]; then
  new="light"
else
  new="dark"
fi

echo "$new" > "$STATE_FILE"

# i3: alterna symlink de tema
rm -f "$HOME/.config/i3/theme.conf"
if [ "$new" = "dark" ]; then
  ln -sf "$DOTFILES/i3/theme.conf" "$HOME/.config/i3/theme.conf"
else
  ln -sf "$DOTFILES/i3/theme-light.conf" "$HOME/.config/i3/theme.conf"
fi
i3-msg reload >/dev/null 2>&1

# rofi: alterna symlink de tema
rm -f "$HOME/.config/rofi/config.rasi"
if [ "$new" = "dark" ]; then
  ln -sf "$DOTFILES/i3/rofi/config.rasi" "$HOME/.config/rofi/config.rasi"
else
  ln -sf "$DOTFILES/i3/rofi/config-light.rasi" "$HOME/.config/rofi/config.rasi"
fi

# tmux: copia arquivo de tema e recarrega se tmux estiver ativo
cp "$DOTFILES/tmux/theme-${new}.conf" "$HOME/.tmux-theme.conf"
if command -v tmux &>/dev/null && tmux info &>/dev/null 2>&1; then
  tmux source-file "$HOME/.tmux-theme.conf" 2>/dev/null || true
fi

# Ghostty: copia arquivo de tema e envia SIGHUP para hot reload
cp "$DOTFILES/ghostty/themes/${new}.conf" "$HOME/.theme-active-ghostty.conf"
pkill -SIGHUP -x ghostty 2>/dev/null || true

notify-send "Tema" "Modo ${new} ativado" --icon=display 2>/dev/null || true
