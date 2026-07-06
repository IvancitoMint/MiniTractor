#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

banner

info "Revisando entorno de desarrollo..."

if [ -f /opt/ros/humble/setup.bash ]; then
    check_ok "ROS 2 Humble"
else
    check_fail "ROS 2 Humble"
    exit 1
fi

if [ -d "${WORKSPACE}" ]; then
    check_ok "Workspace"
else
    check_fail "Workspace"
    exit 1
fi

if [ -f "${WORKSPACE}/install/setup.bash" ]; then
    check_ok "Workspace compilado"
else
    check_warn "Workspace compilado"
fi

check_command gazebo "Gazebo" || true
check_command xacro "xacro" || true
check_command colcon "colcon" || true
check_command ros2 "ros2 CLI" || true

echo
info "Revisando paquetes ROS..."

source /opt/ros/humble/setup.bash

if [ -f "${WORKSPACE}/install/setup.bash" ]; then
    source "${WORKSPACE}/install/setup.bash"
fi

PACKAGES=(
    tractor_description
    tractor_bringup
    tractor_safety
    gazebo_ros2_control
    controller_manager
    diff_drive_controller
    joint_state_broadcaster
)

for PKG in "${PACKAGES[@]}"; do

    if ros2 pkg prefix "$PKG" >/dev/null 2>&1; then
        check_ok "$PKG"
    else
        check_fail "$PKG"
    fi

done

echo
success "Diagnóstico finalizado."
