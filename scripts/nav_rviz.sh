#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

banner

check_ros
check_workspace
check_install

info "Abriendo RViz2 para navegación..."

load_workspace

RVIZ_CONFIG="$(ros2 pkg prefix tractor_bringup)/share/tractor_bringup/rviz/nav2.rviz"

if [ ! -f "${RVIZ_CONFIG}" ]; then
    error "No se encontró la configuración de RViz2."
    info "Ruta esperada: ${RVIZ_CONFIG}"
    exit 1
fi

rviz2 -d "${RVIZ_CONFIG}"
