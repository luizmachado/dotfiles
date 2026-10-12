#!/bin/bash
# Instala ou atualiza o Go a partir do tarball oficial em /usr/local/go.
# Idempotente: só baixa quando a versão instalada difere da mais recente.
# (O apt do Debian 12 traz o Go 1.19, velho demais para o fabric.)

set -euo pipefail

GO_ROOT="/usr/local/go"

latest=$(curl -fsSL "https://go.dev/VERSION?m=text" | head -n1)
current=""
if [ -x "$GO_ROOT/bin/go" ]; then
	current=$("$GO_ROOT/bin/go" env GOVERSION)
fi

if [ "$current" = "$latest" ]; then
	echo "Go $current já é a versão mais recente."
	exit 0
fi

arch=$(dpkg --print-architecture)
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Instalando $latest (atual: ${current:-nenhum})..."
curl -fsSL "https://go.dev/dl/${latest}.linux-${arch}.tar.gz" -o "$tmp/go.tar.gz"
sudo rm -rf "$GO_ROOT"
sudo tar -C /usr/local -xzf "$tmp/go.tar.gz"
echo "$("$GO_ROOT/bin/go" version) instalado em $GO_ROOT"
