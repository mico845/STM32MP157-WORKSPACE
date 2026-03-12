#!/usr/bin/env bash
# ==============================================================================
# STM32MP1 SDK installation script
# Usage:
#       ./scripts/install_sdk.sh
# ==============================================================================

set -euo pipefail

_SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${_SCRIPT_DIR}/common.sh"

mpu_load_env

SDK_TAR="${MPU_DOWNLOADS_DIR}/${MPU_SDK_ARCHIVE}"
SDK_EXTRACT_DIR="${MPU_TMP_DIR}/${MPU_SDK_EXTRACT_DIRNAME}"
SDK_INSTALLER="${SDK_EXTRACT_DIR}/sdk/${MPU_SDK_INSTALLER_NAME}"

mkdir -p "${MPU_TMP_DIR}" "${MPU_SDK_DIR}" "${MPU_DOWNLOADS_DIR}"


if [[ -f "${MPU_SDK_ENV_SETUP}" ]]; then
    mpu_log_step "SDK already installed"
    mpu_log_info "Environment setup file: ${MPU_SDK_ENV_SETUP}"
    exit 0
fi


mpu_require_file "${SDK_TAR}"

mpu_log_step "Extracting SDK archive"
mpu_log_info "Archive: ${SDK_TAR}"
tar xvf "${SDK_TAR}" -C "${MPU_TMP_DIR}"

mpu_require_file "${SDK_INSTALLER}"
chmod +x "${SDK_INSTALLER}"

mpu_log_step "Installing SDK"
mpu_log_info "Installer: ${SDK_INSTALLER}"
mpu_log_info "Destination: ${MPU_SDK_DIR}"

"${SDK_INSTALLER}" -d "${MPU_SDK_DIR}"

if [[ ! -f "${MPU_SDK_ENV_SETUP}" ]]; then
    mpu_die "SDK installation finished, but environment setup file not found: ${MPU_SDK_ENV_SETUP}"
fi

mpu_log_step "SDK installation completed"
mpu_log_info "Environment setup file: ${MPU_SDK_ENV_SETUP}"
echo "Load environment with:"
echo "  source \"${MPU_SCRIPTS_DIR}/setup_env.sh\""

unset _SCRIPT_DIR SDK_TAR SDK_EXTRACT_DIR SDK_INSTALLER