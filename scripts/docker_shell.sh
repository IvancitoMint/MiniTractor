#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

banner

allow_xhost_if_available

check_docker
check_docker_context
check_compose_file
check_docker_image

info "Entrando al contenedor..."
echo

docker_compose run --rm minitractor
