#!/usr/bin/env bash

source "$(dirname "$0")/lib/common.sh"

banner

check_ros
check_workspace

cd "${WORKSPACE}"

info "Compilando workspace..."

source /opt/ros/humble/setup.bash

colcon build --symlink-install

echo

success "Compilación finalizada."