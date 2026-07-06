#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

banner

check_ros
check_workspace
check_install

info "Iniciando teleoperación por teclado..."
echo
info "Usa estas teclas:"
echo "  i  avanzar"
echo "  ,  retroceder"
echo "  j  girar izquierda"
echo "  l  girar derecha"
echo "  k  detener"
echo "  u  avanzar girando izquierda"
echo "  o  avanzar girando derecha"
echo

load_workspace

ros2 run teleop_twist_keyboard teleop_twist_keyboard \
    --ros-args --remap cmd_vel:=/cmd_vel_raw