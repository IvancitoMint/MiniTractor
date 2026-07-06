#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

banner

check_docker
check_docker_context

COMPOSE_FILE="${PROJECT_ROOT}/docker/docker-compose.yml"

info "Construyendo imagen Docker..."

USER_UID=$(id -u) USER_GID=$(id -g) \
docker compose -f "${COMPOSE_FILE}" build

echo
success "Imagen construida correctamente."