#!/bin/bash

_repo='https://github.com/sainnhe/whoogle-search.git'

_init() {
    apt update
    apt upgrade -y
    apt install -y python3 python3-venv python3.8 python3.8-dev python3.8-venv libffi-dev || exit 1
    git clone "${_repo}" ~/whoogle-search
    cd ~/whoogle-search || exit 1
    python3.8 -m venv venv
    source venv/bin/activate
    pip install wheel
}

_start() {
    cd ~/whoogle-search || exit 1
    source venv/bin/activate
    pip install -r requirements.txt
    nohup sh -c 'cd /root/whoogle-search && /root/whoogle-search/venv/bin/python3 -um app --host 0.0.0.0 --port 80' > "/root/whoogle-search/log" 2>&1 &
}

_stop() {
    pid="$(ps aux | grep 'sh -c.*whoogle-search' | grep -v grep | sed -e 's/root[[:blank:]]*//' | grep -Eo '^[0-9]*')"
    kill "${pid}"
}

if [ "${1}" = init ]; then
    _init
elif [ "${1}" = start ]; then
    _start
elif [ "${1}" = restart ]; then
    _stop
    sleep 3
    _start
elif [ "${1}" = stop ]; then
    _stop
else
    printf "USAGE:\n\t${0} [SUBCOMMAND]\n\nSUBCOMMANDS:\n\tinit\t\tInitialize\n\tstart\t\tStart application\n\trestart\t\tRestart application\n\tstop\t\tStop application\n"
fi
