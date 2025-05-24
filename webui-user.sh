#!/bin/bash
# shellcheck disable=SC2034
install_dir=/opt
clone_dir=a1111
venv_dir=-
python_cmd=python3.10

COMMANDLINE_ARGS="--data-dir /data --listen --enable-insecure-extension-access --hide-ui-dir-config --disable-console-progressbars --skip-version-check --skip-python-version-check"

if [ -n "$API_AUTH" ]; then
    # shellcheck disable=SC2089
    COMMANDLINE_ARGS="${COMMANDLINE_ARGS} --api --api-auth '${API_AUTH}'"
    if [ -n "$NO_WEB_UI" ]; then
        COMMANDLINE_ARGS="${COMMANDLINE_ARGS} --nowebui"
    fi
fi

if [ -n "$CPU" ]; then
    COMMANDLINE_ARGS="${COMMANDLINE_ARGS} --use-cpu all --precision full --no-half --skip-torch-cuda-test"
fi

if [ -n "$CONSOLE_PROMPTS" ]; then
    COMMANDLINE_ARGS="${COMMANDLINE_ARGS} --enable-console-prompts"
fi

if [ -n "$CORS_ORIGINS" ]; then
    COMMANDLINE_ARGS="${COMMANDLINE_ARGS} --cors-allow-origins '${CORS_ORIGINS}'"
fi

if [ -n "$CUSTOM_CODE" ]; then
    COMMANDLINE_ARGS="${COMMANDLINE_ARGS} --allow-code"
fi

if [ -n "$LOG_LEVEL" ]; then
    COMMANDLINE_ARGS="${COMMANDLINE_ARGS} --loglevel ${LOG_LEVEL}"
else
    COMMANDLINE_ARGS="${COMMANDLINE_ARGS} --loglevel INFO"
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

if [ -n "${XFORMERS}" ]; then
    COMMANDLINE_ARGS="${COMMANDLINE_ARGS} --xformers"
fi

# shellcheck disable=SC2090
export COMMANDLINE_ARGS
export SD_WEBUI_LOG_LEVEL=ERROR
