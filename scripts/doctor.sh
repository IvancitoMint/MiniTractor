#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE="${PROJECT_ROOT}/workspace"

echo "MiniTractor - Doctor"
echo

check_ok() {
    printf "%-45s OK\n" "$1"
}

check_fail() {
    printf "%-45s ERROR\n" "$1"
}

#############################################
# ROS
#############################################

if [ -f "/opt/ros/humble/setup.bash" ]; then
    check_ok "ROS 2 Humble"
else
    check_fail "ROS 2 Humble"
    exit 1
fi

#############################################
# Workspace
#############################################

if [ -d "${WORKSPACE}" ]; then
    check_ok "Workspace"
else
    check_fail "Workspace"
    exit 1
fi

#############################################
# install
#############################################

if [ -f "${WORKSPACE}/install/setup.bash" ]; then
    check_ok "Workspace compilado"
else
    check_fail "Workspace compilado"
fi

#############################################
# Gazebo
#############################################

if command -v gazebo >/dev/null; then
    check_ok "Gazebo"
else
    check_fail "Gazebo"
fi

#############################################
# xacro
#############################################

if command -v xacro >/dev/null; then
    check_ok "xacro"
else
    check_fail "xacro"
fi

#############################################
# colcon
#############################################

if command -v colcon >/dev/null; then
    check_ok "colcon"
else
    check_fail "colcon"
fi

#############################################
# Paquetes
#############################################

source /opt/ros/humble/setup.bash

if [ -f "${WORKSPACE}/install/setup.bash" ]; then
    source "${WORKSPACE}/install/setup.bash"
fi

PACKAGES=(
    tractor_description
    tractor_bringup
    tractor_safety
)

echo
echo "Paquetes:"
echo

for PKG in "${PACKAGES[@]}"; do

    if ros2 pkg prefix "$PKG" >/dev/null 2>&1; then
        check_ok "$PKG"
    else
        check_fail "$PKG"
    fi

done

echo
echo "Diagnóstico finalizado."