#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

banner

check_ros
check_workspace
check_install

TELEOP_SPEED="${TELEOP_SPEED:-0.5}"
TELEOP_TURN="${TELEOP_TURN:-1.8}"

info "Iniciando teleoperación por teclado..."
info "Velocidad lineal inicial: ${TELEOP_SPEED}"
info "Velocidad angular inicial: ${TELEOP_TURN}"
echo
info "Usa estas teclas:"
echo "  i  avanzar"
echo "  ,  retroceder"
echo "  j  girar izquierda"
echo "  l  girar derecha"
echo "  k  detener"
echo "  u  avanzar girando izquierda"
echo "  o  avanzar girando derecha"
echo "  m  retroceder girando"
echo "  .  retroceder girando"
echo

load_workspace

ros2 run teleop_twist_keyboard teleop_twist_keyboard \
    --ros-args \
    --remap cmd_vel:=/cmd_vel_raw \
    -p speed:="${TELEOP_SPEED}" \
    -p turn:="${TELEOP_TURN}"
