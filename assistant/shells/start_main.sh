#!/usr/bin/env bash
cd "$(dirname "$0")"
FILE=~/.local/bin/pipenv
if test -f "$FILE"; then
    ~/.local/bin/pipenv run python3 -m assistant "$@";
else
    python3 -m assistant "$@";
fi