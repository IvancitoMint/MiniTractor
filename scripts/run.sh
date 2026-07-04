#!/usr/bin/env bash

source "$(dirname "$0")/lib/common.sh"

banner

check_ros
check_workspace
check_install

cd "${WORKSPACE}"

load_workspace

info "Iniciando simulación..."

ros2 launch tractor_bringup sim_with_safety.launch.py