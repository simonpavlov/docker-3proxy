#!/bin/bash

if [ "$1" = "start_proxy" ]; then
    if [ ! -f /etc/3proxy/cfg/3proxy.cfg ]; then
        if [ ! -f /etc/3proxy/cfg/passwords ] && ( [ -z "$PROXY_LOGIN" ] || [ -z "$PROXY_PASSWORD" ] ); then
            echo >&2 'error: proxy is uninitialized, variables is not specified '
            echo >&2 '  You need to specify PROXY_LOGIN and PROXY_PASSWORD'
            exit 1
        fi

    echo "writable" > /etc/3proxy/main.cfg
        echo "nserver 1.1.1.1" >> /etc/3proxy/main.cfg
        echo "nserver 8.8.8.8" >> /etc/3proxy/main.cfg
        echo "nserver 8.8.4.4" >> /etc/3proxy/main.cfg
        echo "nscache 65536" >> /etc/3proxy/main.cfg
        echo "nsrecord www.porno.com 127.0.0.1" >> /etc/3proxy/main.cfg
        echo "" >> /etc/3proxy/main.cfg
        echo 'counter "/etc/3proxy/cfg/3proxy.3cf" D "/etc/3proxy/cfg/traf"' >> /etc/3proxy/main.cfg
        echo "log" >> /etc/3proxy/main.cfg
        echo 'logformat "L%t.%. %N.%p %E %U %C:%c %R:%r %O %I %h %T"' >> /etc/3proxy/main.cfg
        echo "" >> /etc/3proxy/main.cfg
        echo "monitor /etc/3proxy/main.cfg" >> /etc/3proxy/main.cfg
        echo "" >> /etc/3proxy/main.cfg
        if [ -f /etc/3proxy/cfg/passwords ]; then
            echo "Using passwords config"
            echo "users \$/etc/3proxy/cfg/passwords" >> /etc/3proxy/main.cfg
        else
            echo "Using PROXY_LOGIN PROXY_PASSWORD envs"
            echo "users $PROXY_LOGIN:CL:$PROXY_PASSWORD" >> /etc/3proxy/main.cfg
        fi
        echo "" >> /etc/3proxy/main.cfg
        echo "auth strong" >> /etc/3proxy/main.cfg
        echo "proxy -p3128" >> /etc/3proxy/main.cfg
        echo "socks -p1080" >> /etc/3proxy/main.cfg
        echo "admin -p8080" >> /etc/3proxy/main.cfg
        echo "" >> /etc/3proxy/main.cfg
        echo "flush" >> /etc/3proxy/main.cfg

    else
        cp /etc/3proxy/cfg/3proxy.cfg /etc/3proxy/main.cfg
    fi

        echo "Proxy process started!"
        /etc/3proxy/3proxy /etc/3proxy/main.cfg
else
    exec "$@"
fi
