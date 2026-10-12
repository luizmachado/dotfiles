#!/bin/bash
# Instala/atualiza binários de GitHub Releases em ~/.local/bin (sem sudo):
#   - tree-sitter CLI (o nvim-treesitter exige ≥ 0.26.1; o apt traz 0.22 e o npm não é suportado)
#   - lazygit (não está no apt do Debian 12 / Ubuntu 24.04)
# Idempotente: só baixa quando a versão instalada difere da mais recente.

set -euo pipefail

BIN_DIR="$HOME/.local/bin"
mkdir -p "$BIN_DIR"

case "$(dpkg --print-architecture)" in
amd64) TS_ARCH="x64" LG_ARCH="x86_64" ;;
arm64) TS_ARCH="arm64" LG_ARCH="arm64" ;;
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
