#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

banner

check_ros
check_workspace
check_install

OBSTACLE_NAME="${OBSTACLE_NAME:-${DEFAULT_OBSTACLE_NAME}}"
OBSTACLE_X="${OBSTACLE_X:-7.0}"
OBSTACLE_Y="${OBSTACLE_Y:-0.0}"
OBSTACLE_Z="${OBSTACLE_Z:-0.35}"
OBSTACLE_YAW="${OBSTACLE_YAW:-0.0}"

load_workspace

BRINGUP_PREFIX="$(ros2 pkg prefix tractor_bringup)"
OBSTACLE_MODEL="${BRINGUP_PREFIX}/share/tractor_bringup/models/caja_obstaculo/model.sdf"

if [ ! -f "${OBSTACLE_MODEL}" ]; then
    error "No se encontró el modelo del obstáculo."
    info "Ruta esperada: ${OBSTACLE_MODEL}"
    exit 1
fi

info "Agregando obstáculo dinámico: ${OBSTACLE_NAME}"
info "Posición: x=${OBSTACLE_X}, y=${OBSTACLE_Y}, z=${OBSTACLE_Z}, yaw=${OBSTACLE_YAW}"

ros2 run gazebo_ros spawn_entity.py \
    -entity "${OBSTACLE_NAME}" \
    -file "${OBSTACLE_MODEL}" \
    -x "${OBSTACLE_X}" \
    -y "${OBSTACLE_Y}" \
    -z "${OBSTACLE_Z}" \
    -Y "${OBSTACLE_YAW}"

echo
success "Obstáculo agregado."
