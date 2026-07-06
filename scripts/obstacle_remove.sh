#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

banner

check_ros
check_workspace
check_install

OBSTACLE_NAME="${OBSTACLE_NAME:-${DEFAULT_OBSTACLE_NAME}}"

info "Quitando obstáculo dinámico: ${OBSTACLE_NAME}"

load_workspace

ros2 service call /delete_entity gazebo_msgs/srv/DeleteEntity \
    "{name: '${OBSTACLE_NAME}'}"

echo
success "Solicitud de eliminación enviada."
