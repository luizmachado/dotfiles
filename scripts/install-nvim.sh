#!/bin/bash
# Compila e instala (como .deb) a última release estável do Neovim.
# Idempotente: só compila quando a versão instalada difere da mais recente.
# (Os repositórios do Ubuntu/Debian não têm versão recente.)
# Requer as dependências de build instaladas pelo install.sh (cmake, ninja-build, gettext…).

set -euo pipefail

release_json=$(curl -fsSL "https://api.github.com/repos/neovim/neovim/releases/latest")
latest=$(grep -m1 '"tag_name"' <<<"$release_json" | cut -d '"' -f4)
# Restos de um antigo 'sudo make install' em /usr/local: vêm antes de /usr/bin
# no PATH e escondem o nvim do .deb (o vimtex então recusa a versão antiga)
LEGACY_PATHS=(
	/usr/local/bin/nvim
	/usr/local/lib/nvim
	/usr/local/share/nvim
	/usr/local/share/man/man1/nvim.1
	/usr/local/share/applications/nvim.desktop
	/usr/local/share/icons/hicolor/128x128/apps/nvim.png
)
for path in "${LEGACY_PATHS[@]}"; do
	if [ -e "$path" ]; then
		echo "Removendo instalação antiga via make install: $path"
		sudo rm -rf "$path"
	fi
done
hash -r

# Versão do pacote .deb (não o 'nvim' do PATH, que pode ser outro binário)
current=""
if dpkg-query -W -f='${Status}' neovim 2>/dev/null | grep -q "install ok installed"; then
	current="v$(dpkg-query -W -f='${Version}' neovim)"
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
