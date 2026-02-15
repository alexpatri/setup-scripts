#!/usr/bin/env bash

GO_VERSION=1.26.0
GO_TAR=go$GO_VERSION.linux-amd64.tar.gz

if [ $(uname) = "Linux" ]; then
	sudo apt update
	sudo apt install wget
	wget https://golang.org/dl/$GO_TAR
	sudo rm -rf /usr/local/go
	sudo tar -C /usr/local -xzf $GO_TAR
	rm $GO_TAR index.html
	echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.profile
	source ~/.profile
elif [ $(uname) = "Darwin" ]; then
    curl -O https://golang.org/dl/go$(GO_VERSION).darwin-amd64.pkg
    installer -pkg go$(GO_VERSION).darwin-amd64.pkg -target /
    rm go$(GO_VERSION).darwin-amd64.pk
fi

echo "go instalado com sucesso."
go version
