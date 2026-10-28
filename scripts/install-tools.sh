#!/bin/bash
# Instala/atualiza binários de GitHub Releases em ~/.local/bin (sem sudo):
#   - tree-sitter CLI (o nvim-treesitter exige ≥ 0.26.1; o apt traz 0.22 e o npm não é suportado)
#   - lazygit (não está no apt do Debian 12 / Ubuntu 24.04)
#   - videobay (GUI do yt-dlp, fork luizmachado/videobay; só x86_64)
# Idempotente: só baixa quando a versão instalada difere da mais recente.

set -euo pipefail

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

case "$(dpkg --print-architecture)" in
amd64) TS_ARCH="x64" LG_ARCH="x86_64" VB_ASSET="videobay-gui-linux-x86_64" ;;
arm64) TS_ARCH="arm64" LG_ARCH="arm64" VB_ASSET="" ;;
*)
	echo "Arquitetura não suportada: $(dpkg --print-architecture)" >&2
	exit 1
	;;
esac

latest_tag() {
	local json
	json=$(curl -fsSL "https://api.github.com/repos/$1/releases/latest")
	grep -m1 '"tag_name"' <<<"$json" | cut -d '"' -f4
}

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# ── tree-sitter CLI ───────────────────────────────────────────────────────────
ts_latest=$(latest_tag tree-sitter/tree-sitter)
ts_current=""
[ -x "$BIN_DIR/tree-sitter" ] && ts_current="v$("$BIN_DIR/tree-sitter" --version | awk '{print $2}')"
if [ "$ts_current" = "$ts_latest" ]; then
	echo "tree-sitter $ts_current já é a versão mais recente."
else
	echo "Instalando tree-sitter $ts_latest (atual: ${ts_current:-nenhum})..."
	curl -fsSL "https://github.com/tree-sitter/tree-sitter/releases/download/${ts_latest}/tree-sitter-linux-${TS_ARCH}.gz" |
		gunzip >"$tmp/tree-sitter"
	install -m 755 "$tmp/tree-sitter" "$BIN_DIR/tree-sitter"
fi

# ── lazygit ───────────────────────────────────────────────────────────────────
lg_latest=$(latest_tag jesseduffield/lazygit)
lg_current=""
[ -x "$BIN_DIR/lazygit" ] && lg_current="v$("$BIN_DIR/lazygit" --version | sed -n 's/.*, version=\([^,]*\),.*/\1/p')"
if [ "$lg_current" = "$lg_latest" ]; then
	echo "lazygit $lg_current já é a versão mais recente."
else
	echo "Instalando lazygit $lg_latest (atual: ${lg_current:-nenhum})..."
	curl -fsSL "https://github.com/jesseduffield/lazygit/releases/download/${lg_latest}/lazygit_${lg_latest#v}_linux_${LG_ARCH}.tar.gz" |
		tar -xz -C "$tmp" lazygit
	install -m 755 "$tmp/lazygit" "$BIN_DIR/lazygit"
fi

# ── videobay ──────────────────────────────────────────────────────────────────
# O binário não informa a versão: a tag instalada fica registrada em VB_STATE.
VB_STATE="$HOME/.local/share/videobay/version"
if [ -z "$VB_ASSET" ]; then
	echo "VideoBay sem binário para $(dpkg --print-architecture), pulando."
else
	vb_latest=$(latest_tag luizmachado/videobay)
	vb_current=""
	[ -x "$BIN_DIR/videobay" ] && [ -f "$VB_STATE" ] && vb_current=$(cat "$VB_STATE")
	if [ "$vb_current" = "$vb_latest" ]; then
		echo "videobay $vb_current já é a versão mais recente."
	else
		echo "Instalando videobay $vb_latest (atual: ${vb_current:-nenhum})..."
		curl -fsSL -o "$tmp/videobay" "https://github.com/luizmachado/videobay/releases/download/${vb_latest}/${VB_ASSET}"
		install -m 755 "$tmp/videobay" "$BIN_DIR/videobay"
		mkdir -p "$(dirname "$VB_STATE")"
		echo "$vb_latest" >"$VB_STATE"
	fi

	# Lançador para o rofi (-show drun)
	mkdir -p "$HOME/.local/share/applications"
	cat >"$HOME/.local/share/applications/videobay.desktop" <<EOF
[Desktop Entry]
Type=Application
Name=VideoBay
Comment=Baixar vídeos e áudios (yt-dlp)
Exec=$BIN_DIR/videobay
Icon=video-x-generic
Terminal=false
Categories=AudioVideo;Network;
EOF
fi
