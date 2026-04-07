#!/bin/bash
# vim: set filetype=sh :

# Isso aqui carrega todos os outros arquivos de config
# shellcheck disable=SC1091
source "${HOME}/dotfiles/zsh/config/use_this_to_load"



export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
