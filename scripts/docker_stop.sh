#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

banner

check_docker
check_docker_context
check_compose_file

info "Deteniendo contenedores activos..."

stop_project_containers

info "Eliminando contenedores detenidos..."

docker container prune -f >/dev/null

echo
success "Docker limpio."
