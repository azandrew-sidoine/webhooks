#!/usr/bin/env sh

GOSRCPATH="/usr/lib/go"
WEBHOOKS_DIRECTORY="/etc/webhooks/hooks"

start_webhook_worker() {
    {
        echo "[supervisord]"
        echo "nodaemon=true"
        echo "logfile=/var/log/supervisor/supervisord.log"
        echo "pidfile=/var/run/supervisord.pid"
        echo "user=root"
        echo ""

        echo "[program:webhooks-worker]"
        echo "process_name=%(program_name)s_%(process_num)02d"
        echo "command=/usr/local/bin/webhook -ip 0.0.0.0 -hotreload -port $APP_PORT -logfile /etc/webhooks/logs/webhooks.logs -hooks /etc/webhooks/hooks/config.yml --verbose"
        echo "autostart=true"
        echo "autorestart=true"
        echo "stopasgroup=true"
        echo "killasgroup=true"
        echo "user=root"
        echo "numprocs=1"
        echo "redirect_stderr=true"
        echo "stdout_logfile=/etc/webhooks/logs/webhooks.logs"
        echo "stopwaitsecs=3600"
    } >'/etc/supervisor/conf.d/supervisord.conf'
}

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

make_shell_scripts_executable() {
    if [ -d "$WEBHOOKS_DIRECTORY" ]; then
        entries=$(ls $WEBHOOKS_DIRECTORY)
        for FILE in $entries; do
            # We make any file in the /etc/webhooks/hooks directory executable except
            # for any .yml and .json files
            result=$(echo $FILE | grep -E '(json|yml)$')
            if [ '' == "$result" ]; then
                path="$WEBHOOKS_DIRECTORY/$FILE"
                echo "Making $path executable..."
                chmod +x $path >>/dev/null
                echo "$path successfully converted into an exectable..."
            fi
        done
    fi
}

remove_go_binary

start_webhook_worker

make_shell_scripts_executable

exec /usr/bin/supervisord -c /etc/supervisor/conf.d/supervisord.conf
