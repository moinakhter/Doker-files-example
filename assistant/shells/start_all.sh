#!/usr/bin/env bash
cd "$(dirname "$0")"
PIPENV=~/.local/bin/pipenv


script=${0}
script=${script##*/}
cd -P "$( dirname "$SOURCE" )"
DIR="$( pwd )"


_module=""
function name-to-script-path() {
    case ${1} in
        "assistant_main")    _module="-m assistant" ;;
        "nlp")            _module="./assistant/nlp/__main__.py" ;;
        *)
            echo "Error: Unknown name '${1}'"
            exit 1
    esac
}

function launch-background() {
    # Check if given module is running and start (or restart if running)
    name-to-script-path ${1}
    if pgrep -f "python3 ${_module}" > /dev/null ; then
        if ($_force_restart) ; then
            echo "Restarting: ${1}"
            "${DIR}/stop_service.sh" ${1}
        else
            echo "$1 is already running, continuing..."
            return
        fi
    else
        echo "Starting background service $1"
    fi

    # Create log file if not exists
    if [[ ! -e ./log/${1}.log ]]; then
        mkdir -p ./log
        touch ./log/${1}.log
    fi
    # Launch process in background, sending logs to standard location
    if test -f "$PIPENV"; then
        ~/.local/bin/pipenv run python3 ${_module} > ./log/${1}.log 2>&1 &
        echo ${_module}
    else
        python3 ${_module} > ./log/${1}.log 2>&1 &
    fi
}

function launch-foreground() {
    name-to-script-path ${1}
    
    # Check if given module is running and start (or restart if running)
    if pgrep -f "python3 ${_module}" > /dev/null ; then
        if ($_force_restart) ; then
            echo "Restarting: ${1}"
            "${DIR}/stop_service.sh" ${1}
        else
            echo "$1 is already running, continuing..."
            return
        fi
    else
        echo "Starting foreground service $1"
    fi
    # Launch process in foreground
    if test -f "$PIPENV"; then
        ~/.local/bin/pipenv run python3 ${_module} $_params ;
    else
        python3 ${_module} $_params ;
    fi
}

function launch-all() {
    echo "Starting all assistant services"
    # redis-server & redis_pid="$!" &
    launch-background nlp
    launch-foreground assistant_main
}

_opt=$1
_force_restart=false
shift
if [[ "${1}" == "restart" ]] || [[ "${_opt}" == "restart" ]] ; then
    _force_restart=true
    if [[ "${_opt}" == "restart" ]] ; then
        # Support "start-all.sh restart all" as well as "start-all.sh all restart"
        _opt=$1
    fi
    shift
fi
_params=$@
echo "params ${_params}"
launch-all