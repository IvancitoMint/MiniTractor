#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

banner

check_ros
check_workspace

cd "${WORKSPACE}"

info "Compilando workspace..."

source /opt/ros/humble/setup.bash

colcon build --symlink-install

echo

success "Compilación finalizada."