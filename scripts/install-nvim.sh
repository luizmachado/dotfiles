#!/bin/bash
# Compila e instala (como .deb) a última release estável do Neovim.
# Idempotente: só compila quando a versão instalada difere da mais recente.
# (Os repositórios do Ubuntu/Debian não têm versão recente.)
# Requer as dependências de build instaladas pelo install.sh (cmake, ninja-build, gettext…).

set -euo pipefail

release_json=$(curl -fsSL "https://api.github.com/repos/neovim/neovim/releases/latest")
latest=$(grep -m1 '"tag_name"' <<<"$release_json" | cut -d '"' -f4)
current=""
if command -v nvim &>/dev/null; then
	current=$(nvim --version | head -n1 | awk '{print $2}')
fi

if [ "$current" = "$latest" ]; then
	echo "Neovim $current já é a versão mais recente."
	exit 0
fi

tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

echo "Compilando Neovim $latest (atual: ${current:-nenhum})..."
git clone --depth 1 --branch "$latest" https://github.com/neovim/neovim.git "$tmp/neovim"
cd "$tmp/neovim"
make CMAKE_BUILD_TYPE=Release
cd build
cpack -G DEB
sudo dpkg -i nvim-linux*.deb
echo "$(nvim --version | head -n1) instalado."
