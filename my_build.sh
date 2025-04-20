#!/bin/bash

CURRENT_DIR=$(
    cd $(dirname ${BASH_SOURCE:-$0})
    pwd
)
readonly CURRENT_DIR

# Build parameters
readonly SOC_VERSION="Ascend910B4"
readonly RUN_MODE="sim"
readonly BUILD_TYPE="Debug"
readonly INSTALL_PREFIX="${CURRENT_DIR}/out"

# Ascend Toolkit parameters
readonly _ASCEND_INSTALL_PATH="${HOME}/Ascend/ascend-toolkit/latest"
export ASCEND_TOOLKIT_HOME="${_ASCEND_INSTALL_PATH}"
export ASCEND_HOME_PATH="${_ASCEND_INSTALL_PATH}"
source "${_ASCEND_INSTALL_PATH}/bin/setenv.bash"

# Simulator parameters
export LD_LIBRARY_PATH=${_ASCEND_INSTALL_PATH}/tools/simulator/${SOC_VERSION}/lib:$LD_LIBRARY_PATH
export CAMODEL_LOG_PATH="${CURRENT_DIR}/sim_log"
if [ -d "$CAMODEL_LOG_PATH" ]; then
    rm --recursive --force "$CAMODEL_LOG_PATH"
fi
mkdir --parent "$CAMODEL_LOG_PATH"

# Do build
rm --recursive --force ./build ./out
mkdir --parent ./build
cmake -B build \
    -DRUN_MODE=${RUN_MODE} \
    -DSOC_VERSION=${SOC_VERSION} \
    -DCMAKE_BUILD_TYPE=${BUILD_TYPE} \
    -DCMAKE_INSTALL_PREFIX=${INSTALL_PREFIX} \
    -DASCEND_CANN_PACKAGE_PATH=${_ASCEND_INSTALL_PATH} \
    -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE

cmake --build build --parallel

# Repair compile_commands.json by merging the main and sub files
readonly MAIN_COMPILE_COMMANDS="${CURRENT_DIR}/build/compile_commands.json"
readonly SUB_COMPILE_COMMANDS="${CURRENT_DIR}/build/ascendc_kernels_sim_precompile-prefix/src/ascendc_kernels_sim_precompile-build/compile_commands.json"
jq --slurp '.[0] + .[1]' "${MAIN_COMPILE_COMMANDS}" "${SUB_COMPILE_COMMANDS}" > "${MAIN_COMPILE_COMMANDS}.tmp"
mv "${MAIN_COMPILE_COMMANDS}.tmp" "${MAIN_COMPILE_COMMANDS}"

# Install
cmake --install build
