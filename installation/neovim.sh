#!/usr/bin/env bash

LINE='export PATH="$PATH:/opt/nvim-linux-x86_64/bin"'

define_shell_rc() {
    if [[ "$SHELL" == *"zsh"* ]]; then
        echo "$HOME/.zshrc"
    else
        echo "$HOME/.bashrc"
    fi
}

RC_FILE=$(define_shell_rc)

if [ $(uname) = "Linux" ]; then
    curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim-linux-x86_64.tar.gz
    sudo rm -rf /opt/nvim
    sudo tar -C /opt -xzf nvim-linux-x86_64.tar.gz


    if ! grep -Fxq "$LINE" "$RC_FILE"; then
        echo "$LINE" >> "$RC_FILE"
        echo "Linha adicionada ao $RC_FILE"
	source "$RC_FILE"
    else
        echo "A linha já existe em $RC_FILE"
    fi

    rm -rf nvim-linux-x86_64.tar.gz
fi
