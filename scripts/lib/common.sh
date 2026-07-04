#!/usr/bin/env bash

############################################################
# MiniTractor
# Common Library
############################################################

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
WORKSPACE="${PROJECT_ROOT}/workspace"

#############################################
# Colores
#############################################

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

#############################################
# Mensajes
#############################################

info() {
    echo -e "${BLUE}[INFO]${NC} $1"
}

success() {
    echo -e "${GREEN}[ OK ]${NC} $1"
}

warning() {
    echo -e "${YELLOW}[WARN]${NC} $1"
}

error() {
    echo -e "${RED}[FAIL]${NC} $1"
}

#############################################
# Banner
#############################################

banner() {

echo
echo "=============================================="
echo " MiniTractor"
echo "=============================================="
echo

}

#############################################
# Verificaciones
#############################################

check_ros() {

    if [ ! -f "/opt/ros/humble/setup.bash" ]; then

        error "ROS 2 Humble no encontrado."

        exit 1

    fi

}

check_workspace() {

    if [ ! -d "${WORKSPACE}" ]; then

        error "Workspace no encontrado."

        exit 1

    fi

}

check_install() {

    if [ ! -f "${WORKSPACE}/install/setup.bash" ]; then

        error "Workspace no compilado."

        info "Ejecuta primero:"
        echo "./scripts/build.sh"

        exit 1

    fi

}

#############################################
# Cargar entorno
#############################################

load_workspace() {

    source /opt/ros/humble/setup.bash
    source "${WORKSPACE}/install/setup.bash"

}