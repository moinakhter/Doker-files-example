#!/usr/bin/env bash
cd "$(dirname "$0")"
FILE=~/.local/bin/pipenv
if test -f "$FILE"; then
    pipenv run python3 assistant/nlp/bert_nlu_basic_api.py --model=assistant/nlp/saved_models/joint_albert_model --type=albert
fi

