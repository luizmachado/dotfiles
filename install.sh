#!/bin/bash

# TENHA MUITO CUIDADO COM ESSE SCRIPT, ELE NÃO VAI TE PERDOAR.

# Funções para printar mensagens coloridas de forma legível
loginfo() {
	local BLUE='\033[1;34m'
	local RESET='\033[0m'
	printf "🔵 ${BLUE}%s${RESET}\n" "$1"
}

logsuccess() {
	local GREEN='\033[1;32m'
	local RESET='\033[0m'
	printf "🟢 ${GREEN}%s${RESET}\n" "$1"
}

logerror() {
	local RED='\033[1;31m'
	local RESET='\033[0m'
	printf "🔴 ${RED}%s${RESET}\n" "$1"
}

logwarning() {
	local YELLOW='\033[1;33m'
	local RESET='\033[0m'
	printf "🟡 ${YELLOW}%s${RESET}\n" "$1"
}

_setup_dotfiles_local() {
	if [[ -f "${HOME}/.dotfiles.local" ]]; then
		loginfo "~/.dotfiles.local já existe, pulando."
		return
	fi
	cp "${HOME}/dotfiles/.dotfiles.local.example" "${HOME}/.dotfiles.local"
	logwarning "Preencha ~/.dotfiles.local com seus valores pessoais antes de continuar."
	printf "Pressione Enter quando pronto... "
	read -r _
}

_setup_git_identity() {
	if [[ -f "${HOME}/.gitconfig.local" ]]; then
		loginfo "~/.gitconfig.local já existe, pulando."
		return
	fi
	loginfo "Configurando identidade git..."
	printf "Nome completo para commits git: "
	read -r GIT_NAME
	printf "Email para commits git: "
	read -r GIT_EMAIL
	printf '[user]\n\tname = %s\n\temail = %s\n[credential]\n\thelper = store\n' \
		"$GIT_NAME" "$GIT_EMAIL" > "${HOME}/.gitconfig.local"
	logsuccess "~/.gitconfig.local criado."
	loginfo "Configurando git para o root..."
	sudo git config --global user.name "$GIT_NAME"
	sudo git config --global user.email "$GIT_EMAIL"
	sudo git config --global core.editor "nvim"
	sudo git config --global color.ui auto
	sudo git config --global credential.helper store
}

# garante que o script pare em caso de erro
set -e

# Vamos tentar descobrir o sistema operacional
OP_SYSTEM=""

if [ "$(uname -s)" == "Linux" ]; then
	echo "This system is Linux."
	if [ -f /etc/os-release ]; then
		# shellcheck disable=SC1091
		. /etc/os-release
		if [ "$ID" == "ubuntu" ] || [ "$ID" == "debian" ]; then
			OP_SYSTEM="ubuntu" # ubuntu ou debian
		else
			# Aqui não sei qual sistema é, mas é Linux
			logerror "This is another Linux distribution: $PRETTY_NAME"
		fi
	elif command -v lsb_release &>/dev/null; then
		if lsb_release -d | grep -qE "Ubuntu|Debian"; then
			OP_SYSTEM="ubuntu" # ubuntu ou debian
		fi
	fi
else
	logerror "It is not safe to run this script on your system."
	exit 1
fi

if [[ "$OP_SYSTEM" == "ubuntu" ]]; then

	# Ubuntu ou Debian, usamos apt
	loginfo "Your system is Ubuntu/Debian, updating packages..."
	sudo apt update -y
	sudo apt upgrade -y

	loginfo "Installing apps..."
	sudo apt-get install git build-essential libssl-dev zlib1g-dev \
		libbz2-dev libreadline-dev libsqlite3-dev wget curl \
		llvm gettext tk-dev tcl-dev blt-dev libgdbm-dev \
		git python3-dev aria2 lzma liblzma-dev \
		cmake ninja-build pkg-config libtool \
		libtool-bin autoconf automake gettext curl \
		-y

	loginfo "Installing apps..."
	sudo apt install \
		openssl bat cmake ffmpeg fzf htop nano \
		p7zip pkgconf sqlite3 tcl tk tcl-dev tk-dev tmux \
		tree watch wget fonts-firacode fonts-jetbrains-mono vim \
		rofi picom fontconfig \
		-y

	sudo apt install lua5.4 liblua5.4-dev unzip make build-essential luarocks ripgrep xclip
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
	eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
	brew install gcc

	if ! command -v go &>/dev/null; then
		loginfo "Installing Go..."
		brew install go
	else
		loginfo "Go já instalado..."
	fi

	# Infelizmente vamos ter que buildar o neovim do zero
	# os repositórios do Ubuntu/Debian não têm versão recente
	if ! command -v nvim &>/dev/null; then
		loginfo "Compiling and Installing nvim..."
		git clone https://github.com/neovim/neovim.git ~/neovim
		cd ~/neovim
		git checkout stable
		make CMAKE_BUILD_TYPE=Release
		sudo make install
		cd build
		sudo cpack -G DEB
		sudo dpkg -i nvim-linux*.deb
		cd ~
		sudo rm -Rf ~/neovim
	else
		loginfo "nvim já instalado..."
	fi

	if ! command -v zsh &>/dev/null; then
		loginfo "Installing ZSH..."
		sudo apt install zsh -y
		chsh -s $(which zsh)
	else
		loginfo "zsh já instalado..."
	fi

	loginfo "Installing Ghostty..."
	/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/mkasberg/ghostty-ubuntu/HEAD/install.sh)"

	# JetBrainsMono Nerd Font — habilita ícones no i3bar, rofi e terminal
	NERD_FONT_DIR="$HOME/.local/share/fonts/NerdFonts"
	if ! fc-list | grep -qi "JetBrainsMono Nerd"; then
		loginfo "Instalando JetBrainsMono Nerd Font..."
		mkdir -p "$NERD_FONT_DIR"
		_NF_TMP=$(mktemp -d)
		curl -fsSL "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/JetBrainsMono.zip" \
			-o "$_NF_TMP/JetBrainsMono.zip"
		unzip -q "$_NF_TMP/JetBrainsMono.zip" -d "$NERD_FONT_DIR"
		rm -rf "$_NF_TMP"
		fc-cache -f "$NERD_FONT_DIR"
		logsuccess "JetBrainsMono Nerd Font instalada em $NERD_FONT_DIR"
	else
		loginfo "JetBrainsMono Nerd Font já instalada, pulando."
	fi

else
	# Eu tenho medo de rodar isso noutro sistema que não testei
	# Mas lendo aqui você pode fazer tudo manualmente
	logerror "Wrong system, sorry!"
	exit 1
fi

# --- Zsh e Oh My Zsh ---
loginfo "Configurando Zsh e Oh My Zsh..."
if [ ! -d "$HOME/.oh-my-zsh" ]; then
	loginfo "Instalando Oh My Zsh..."
	/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
	loginfo "Oh My Zsh já está instalado."
fi

# Instala plugins do Zsh
ZSH_CUSTOM="$HOME/.oh-my-zsh/custom"
loginfo "🔌 Instalando plugins do Zsh..."
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-autosuggestions" ]; then
	git clone https://github.com/zsh-users/zsh-autosuggestions "${ZSH_CUSTOM}/plugins/zsh-autosuggestions"
fi
if [ ! -d "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting" ]; then
	git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "${ZSH_CUSTOM}/plugins/zsh-syntax-highlighting"
fi

# --- Configuração do Neovim com Lazy.nvim ---
loginfo "🐘 Configurando Neovim e Lazy.nvim..."
LAZY_PATH="$HOME/.local/share/nvim/lazy/lazy.nvim"
if [ ! -d "$LAZY_PATH" ]; then
	loginfo "Instalando o gerenciador de plugins Lazy.nvim..."
	git clone https://github.com/folke/lazy.nvim.git --filter=blob:none "$LAZY_PATH"
fi

# --- Gerenciador de Plugins do Tmux (TPM) ---
loginfo "🔄 Instalando TPM para Tmux..."
if [ ! -d "$HOME/.tmux/plugins/tpm" ]; then
	git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
fi

if ! command -v pyenv &>/dev/null; then
	# Pyenv e uv
	loginfo "Installing Pyenv and uv..."
	rm -Rf "${HOME}/.pyenv"
	curl -fsSL https://pyenv.run | bash
	curl -LsSf https://astral.sh/uv/install.sh | sh
else
	loginfo "Pyenv já instalado..."
fi

if ! command -v uv &>/dev/null; then
	# UV
	loginfo "Installing uv..."
	curl -LsSf https://astral.sh/uv/install.sh | sh
else
	loginfo "UV já instalado..."
fi

if ! command -v fabric &>/dev/null; then
	loginfo "Installing fabric..."
	go install github.com/danielmiessler/fabric/cmd/fabric@latest
else
	loginfo "fabric já instalado..."
fi

if ! command -v nvm &>/dev/null; then
	# NVM
	rm -Rf "${HOME}/.nvm"
	curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.3/install.sh | bash
else
	loginfo "NVM já instalado..."
fi

echo -e "
[1;33mATENÇÃO: Passos manuais necessários:[0m"
echo ""
echo "ABRA OUTRO TERMINAL - NÃO USE ESSA INSTÂNCIA"
echo ""
echo "1. Execute 'nvm install --lts'"
echo "2. Execute 'nvm install-latest-npm'"
echo "3. Execute 'npm i -g prettier'"
echo "4. Execute 'npm i -g tree-sitter-cli'  # necessário para o nvim-treesitter compilar parsers"
echo "5. Execute 'pyenv install 3.13.5' (ou versões mais novas)"
echo "6. Execute 'pyenv global 3.13.5' (ou versões mais novas)"
echo "7. Execute 'uv tool install pyright'"
echo "8. Execute 'uv tool install ruff'"
echo "9. Execute 'fabric --setup' e selecione Ollama como provedor"
echo "   (o endpoint já está em OLLAMA_HOST; modelo padrão configurado: gemma4)"
echo ""
echo "Para criar um virtualenv por projeto:"
echo "  pyenv virtualenv 3.13.5 meu-projeto-env"
echo "  cd /caminho/do/projeto && pyenv local meu-projeto-env"
echo "  # O .python-version criado ativa o venv automaticamente ao entrar no dir"
echo ""
read -p "Ao terminar as tarefas acima, pressione qualquer tecla para continuar..."

# --- Criação de Symlinks ---
loginfo "🔗 Criando symlinks para os arquivos de configuração..."

# Cria o diretório ~/.config se não existir
mkdir -p "$HOME/.config"

# Zsh
rm -Rf "$HOME/.zshrc"
ln -sf "$HOME/dotfiles/zsh/.zshrc" "$HOME/.zshrc"

rm -Rf "$HOME/.zprofile"
ln -sf "$HOME/dotfiles/zsh/.zprofile" "$HOME/.zprofile"

rm -Rf "$HOME/.zshenv"
ln -sf "$HOME/dotfiles/zsh/.zshenv" "$HOME/.zshenv"

rm -Rf "$ZSH_CUSTOM/themes/omtheme.zsh-theme"
ln -sf "$HOME/dotfiles/zsh/config/omtheme.zsh-theme" "$ZSH_CUSTOM/themes/omtheme.zsh-theme"

# Git
rm -Rf "$HOME/.gitconfig"
ln -sf "$HOME/dotfiles/git/.gitconfig" "$HOME/.gitconfig"

_setup_dotfiles_local
_setup_git_identity

# Tmux
rm -Rf "$HOME/.tmux.conf"
ln -sf "$HOME/dotfiles/tmux/.tmux.conf" "$HOME/.tmux.conf"

# Vim (para compatibilidade)
rm -Rf "$HOME/.vimrc"
ln -sf "$HOME/dotfiles/vim/.vimrc" "$HOME/.vimrc"

# Neovim
rm -Rf "$HOME/.config/nvim"
ln -sf "$HOME/dotfiles/nvim" "$HOME/.config/nvim"

# Ghostty
rm -Rf "$HOME/.config/ghostty"
ln -sf "$HOME/dotfiles/ghostty" "$HOME/.config/ghostty"

# fabric — patterns customizados
loginfo "Configurando padrões customizados do fabric..."
mkdir -p "$HOME/.config/fabric/patterns"
for pattern_dir in "$HOME/dotfiles/fabric/patterns"/*/; do
    pattern_name=$(basename "$pattern_dir")
    rm -Rf "$HOME/.config/fabric/patterns/$pattern_name"
    ln -sf "$HOME/dotfiles/fabric/patterns/$pattern_name" \
           "$HOME/.config/fabric/patterns/$pattern_name"
done
logsuccess "Padrões fabric configurados: cria_commit, corrige_pt"

# i3wm — tema e keybindings (via include — NÃO substitui o config principal do usuário)
if command -v i3 &>/dev/null; then
    loginfo "Configurando i3wm (tema Tokyo Night + keybindings)..."
    mkdir -p "$HOME/.config/i3"

    I3_CONFIG="$HOME/.config/i3/config"

    # ── keybindings customizadas ──────────────────────────────────────────────
    rm -f "$HOME/.config/i3/luiz_dotfiles.conf"
    ln -sf "$HOME/dotfiles/i3/luiz.conf" "$HOME/.config/i3/luiz_dotfiles.conf"

    # ── tema Tokyo Night (font, cores, bordas, gaps, picom) ───────────────────
    rm -f "$HOME/.config/i3/theme.conf"
    ln -sf "$HOME/dotfiles/i3/theme.conf" "$HOME/.config/i3/theme.conf"

    # ── injeta includes no config principal (idempotente: remove e re-adiciona) ─
    # Abordagem "remove + re-add" evita duplicatas mesmo se o script rodar
    # múltiplas vezes ou se o include foi escrito com caminho absoluto antes.
    if [[ -f "$I3_CONFIG" ]]; then
        sed -i '/include.*luiz_dotfiles\.conf/d' "$I3_CONFIG"
        sed -i '/include.*theme\.conf/d' "$I3_CONFIG"
        printf '\ninclude ~/.config/i3/luiz_dotfiles.conf\n' >> "$I3_CONFIG"
        printf '\ninclude ~/.config/i3/theme.conf\n' >> "$I3_CONFIG"
        logsuccess "includes luiz_dotfiles.conf e theme.conf configurados em ~/.config/i3/config"
    else
        logwarning "~/.config/i3/config não encontrado. Adicione manualmente:"
        logwarning "  include ~/.config/i3/luiz_dotfiles.conf"
        logwarning "  include ~/.config/i3/theme.conf"
    fi

    # ── i3status: config customizado (lido automaticamente pelo i3status) ─────
    mkdir -p "$HOME/.config/i3status"
    rm -f "$HOME/.config/i3status/config"
    ln -sf "$HOME/dotfiles/i3/i3status.conf" "$HOME/.config/i3status/config"
    logsuccess "i3status config symlinked para ~/.config/i3status/config"

    # ── rofi: launcher moderno com tema Tokyo Night ───────────────────────────
    mkdir -p "$HOME/.config/rofi"
    rm -f "$HOME/.config/rofi/config.rasi"
    ln -sf "$HOME/dotfiles/i3/rofi/config.rasi" "$HOME/.config/rofi/config.rasi"
    logsuccess "Rofi config symlinked para ~/.config/rofi/config.rasi"

    # ── patch cirúrgico: injeta cores Tokyo Night no bloco bar{} ─────────────
    # Único toque no config principal — apenas aditivo, nada é removido.
    if [[ -f "$I3_CONFIG" ]] && ! grep -q "background #1a1b26" "$I3_CONFIG"; then
        sed -i \
            's|status_command i3status|status_command i3status\n\tfont pango:JetBrainsMono Nerd Font 9\n\tcolors {\n\t\tbackground #1a1b26\n\t\tstatusline #c0caf5\n\t\tseparator  #3b4261\n\t\tfocused_workspace  #7aa2f7 #3d59a1 #c0caf5\n\t\tactive_workspace   #24283b #24283b #c0caf5\n\t\tinactive_workspace #1a1b26 #1a1b26 #565f89\n\t\turgent_workspace   #f7768e #f7768e #1a1b26\n\t}|' \
            "$I3_CONFIG"
        logsuccess "Cores Tokyo Night injetadas no bloco bar{} do ~/.config/i3/config"
    else
        loginfo "Cores da barra já configuradas ou config não encontrado, pulando patch."
    fi

    # ── patch: substitui dmenu por rofi no binding $mod+d ────────────────────
    if [[ -f "$I3_CONFIG" ]] && grep -q "dmenu_run" "$I3_CONFIG"; then
        sed -i \
            's|bindsym \$mod+d exec --no-startup-id dmenu_run|bindsym $mod+d exec --no-startup-id rofi -modi drun,run -show drun|' \
            "$I3_CONFIG"
        logsuccess "dmenu substituído por rofi no binding \$mod+d"
    else
        loginfo "Binding \$mod+d já configurado ou config não encontrado, pulando."
    fi

    logsuccess "i3wm configurado com tema Tokyo Night."
else
    loginfo "i3wm não encontrado, pulando configuração."
fi

echo -e "
[1;33mATENÇÃO: Passos manuais necessários:[0m"
echo ""
echo "ABRA OUTRO TERMINAL (NOVAMENTE) - NÃO USE ESSA INSTÂNCIA"
echo ""
echo "1. Abra o Neovim ('nvim') para que o Lazy.nvim possa instalar todos os plugins."
echo "2. Inicie o Tmux e pressione 'prefix + I' (Ctrl+b + I) para instalar os plugins do TPM."
echo "3. Reinicie seu terminal para que todas as alterações tenham efeito."
echo ""
read -p "Ao terminar as tarefas acima, pressione qualquer tecla para continuar..."

# --- Finalização ---
echo ""
loginfo "✅ Script de instalação concluído!"
