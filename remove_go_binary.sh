#!/usr/bin/env /bin/sh

remove_go_binary() {
    if [ -d "$GOSRCPATH" ]; then
        GOPATH=$(command -v go)
        GOFMTPATH=$(command -v gofmt)
        if [ -x "$GOPATH" ]; then
            echo "Removing go executable..."
            rm -f "$GOPATH"
        fi
        if [ -x "$GOFMTPATH" ]; then
            echo "Removing gofmt executable..."
            rm -f "$GOFMTPATH"
        fi
        echo "Removing go binaries..."
        rm -rf "$GOSRCPATH"
        echo "Go binaries removed from the system"
    fi
}

remove_go_binary