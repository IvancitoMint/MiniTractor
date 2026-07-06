#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

banner

check_ros
check_workspace
check_install

MAP_FILE="${1:-${NAV_MAP:-${DEFAULT_NAV_MAP}}}"

check_map_file "${MAP_FILE}"

info "Iniciando simulación con Navigation2..."
info "Mapa: ${MAP_FILE}"

load_workspace

export MINITRACTOR_WORKSPACE="${WORKSPACE}"

ros2 launch tractor_bringup sim_with_nav2.launch.py \
    map:="${MAP_FILE}"
