#!/usr/bin/env bash
# ==============================================================================
# STM32MP1 Development Environment Setup
# Usage:
#       source ./scripts/setup_env.sh
# ==============================================================================

if [ -n "${BASH_SOURCE[0]:-}" ]; then
    _SCRIPT_PATH="${BASH_SOURCE[0]}"
elif [ -n "${ZSH_VERSION:-}" ]; then
    _SCRIPT_PATH="${(%):-%N}"
else
    _SCRIPT_PATH="$0"
fi
_SCRIPT_DIR="$(cd "$(dirname "${_SCRIPT_PATH}")" && pwd)"
_WORKSPACE_ROOT="$(dirname "${_SCRIPT_DIR}")"


source "${_SCRIPT_DIR}/common.sh"

mpu_load_env "${_WORKSPACE_ROOT}"

if [[ ! -f "${MPU_SDK_ENV_SETUP}" ]]; then
    mpu_log_warn "SDK not installed at: ${MPU_SDK_DIR}"
    echo "Please run:"
    echo "  bash ${MPU_SCRIPTS_DIR}/install_sdk.sh"
    echo ""
    mpu_log_info "Workspace variables loaded only. Cross-compilation is unavailable."
else
    mpu_log_step "Loading SDK environment"
    source "${MPU_SDK_ENV_SETUP}"
fi


if [[ -n "${CC:-}" ]]; then
    _CC_BIN="${CC%% *}"
    _CC_VER="$("${_CC_BIN}" --version 2>/dev/null | head -1 || echo 'N/A')"
else
    _CC_BIN=""
    _CC_VER="N/A"
fi

echo "============================================================"
echo " STM32MP1 Development Environment"
echo "------------------------------------------------------------"
echo " Board       : ${MPU_BOARD}"
echo " SDK         : ${OECORE_SDK_VERSION:-N/A}"
echo " CC          : ${_CC_VER}"
echo " Workspace   : ${MPU_WORKSPACE}"
echo " Target      : ${MPU_TARGET_USER}@${MPU_TARGET_IP}"
echo "============================================================"

unset _SCRIPT_PATH _SCRIPT_DIR _WORKSPACE_ROOT _CC_BIN _CC_VER
