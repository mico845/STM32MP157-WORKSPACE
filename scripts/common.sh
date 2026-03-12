#!/usr/bin/env bash

# ==============================================================================
# STM32MP1 Workspace Common Helpers
# ==============================================================================


if [[ -t 1 ]]; then
    COLOR_GREEN=$'\033[32m'
    COLOR_YELLOW=$'\033[33m'
    COLOR_RED=$'\033[31m'
    COLOR_BLUE=$'\033[34m'
    COLOR_RESET=$'\033[0m'
else
    COLOR_GREEN=""
    COLOR_YELLOW=""
    COLOR_RED=""
    COLOR_BLUE=""
    COLOR_RESET=""
fi

# -----------------------------------------------------------------------------
# logging helpers
# -----------------------------------------------------------------------------

mpu_log_info() {
    printf "%s[INFO]%s %s\n" "$COLOR_GREEN" "$COLOR_RESET" "$*"
}

mpu_log_warn() {
    printf "%s[WARN]%s %s\n" "$COLOR_YELLOW" "$COLOR_RESET" "$*" >&2
}

mpu_log_error() {
    printf "%s[ERROR]%s %s\n" "$COLOR_RED" "$COLOR_RESET" "$*" >&2
}

mpu_log_step() {
    printf "%s[STEP]%s %s\n" "$COLOR_BLUE" "$COLOR_RESET" "$*"
}

mpu_die() {
    mpu_log_error "$*"

    if [[ "${BASH_SOURCE[0]}" != "${0}" ]]; then
        return 1
    else
        exit 1
    fi
}


mpu_get_script_path() {
    if [ -n "${BASH_SOURCE[0]:-}" ]; then
        printf '%s\n' "${BASH_SOURCE[0]}"
    elif [ -n "${ZSH_VERSION:-}" ]; then
        printf '%s\n' "${(%):-%N}"
    else
        printf '%s\n' "$0"
    fi
}

mpu_get_script_dir() {
    local script_path
    script_path="$(mpu_get_script_path)"
    cd "$(dirname "${script_path}")" && pwd
}

mpu_get_workspace_root() {
    local script_dir
    script_dir="$(mpu_get_script_dir)"
    dirname "${script_dir}"
}

mpu_load_env() {
    local workspace_root

    if [[ -n "${1:-}" ]]; then
        workspace_root="$1"
    else
        workspace_root="$(mpu_get_workspace_root)"
    fi

    if [[ -f "${workspace_root}/.env" ]]; then
        source "${workspace_root}/.env"
    else
        mpu_die ".env not found at ${workspace_root}/.env"
    fi
}

mpu_require_file() {
    local f="$1"
    [[ -f "${f}" ]] || mpu_die "Required file not found: ${f}"
}

mpu_require_dir() {
    local d="$1"
    [[ -d "${d}" ]] || mpu_die "Required directory not found: ${d}"
}

