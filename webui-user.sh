#!/bin/bash
# shellcheck disable=SC2034
install_dir=/opt
clone_dir=a1111
venv_dir=-
python_cmd=python3.10

COMMANDLINE_ARGS="--xformers --listen --loglevel=ERROR --disable-console-progressbars --data-dir /data"

if [ -n "$API_AUTH" ]; then
    # shellcheck disable=SC2089
    COMMANDLINE_ARGS="${COMMANDLINE_ARGS} --api --api-auth '${API_AUTH}'"
fi
if [ -n "$NO_PROMPT_HISTORY" ]; then
    COMMANDLINE_ARGS="${COMMANDLINE_ARGS} --no-prompt-history"
fi
if [ -n "$SERVER_NAME" ]; then
    # shellcheck disable=SC2089
    COMMANDLINE_ARGS="${COMMANDLINE_ARGS} --server-name '${SERVER_NAME}'"
fi
if [ -n "$UI_AUTH" ]; then
    # shellcheck disable=SC2089
    COMMANDLINE_ARGS="${COMMANDLINE_ARGS} --gradio-auth '${UI_AUTH}'"
elif [ -n "$UI_AUTH_FILE" ]; then
    # shellcheck disable=SC2089
    COMMANDLINE_ARGS="${COMMANDLINE_ARGS} --gradio-auth-path '${UI_AUTH_FILE}'"
fi

# shellcheck disable=SC2090
export COMMANDLINE_ARGS
export SD_WEBUI_LOG_LEVEL=ERROR
