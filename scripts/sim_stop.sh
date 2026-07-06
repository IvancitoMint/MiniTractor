#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

banner

info "Deteniendo procesos de simulación..."
pkill -f gzserver || true
pkill -f gzclient || true
pkill -f gazebo || true
pkill -f spawn_entity || true

echo
success "Procesos de simulación detenidos."
info "Para detener contenedores Docker usa: ./scripts/docker_stop.sh"
