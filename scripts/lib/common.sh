#!/usr/bin/env bash

############################################################
# MiniTractor
# Common Library
############################################################

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
WORKSPACE="${PROJECT_ROOT}/workspace"
MAPS_DIR="${WORKSPACE}/maps"
DEFAULT_MAP_NAME="huerto_map"
DEFAULT_OBSTACLE_NAME="caja_obstaculo"
DEFAULT_NAV_MAP="${MAPS_DIR}/${DEFAULT_MAP_NAME}.yaml"
COMPOSE_FILE="${PROJECT_ROOT}/docker/docker-compose.yml"
IMAGE_NAME="minitractor:humble"
CONTAINER_NAME="minitractor"

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
# Utilidades
#############################################

confirm() {

    local prompt="$1"
    local response

    read -rp "${prompt} [y/N]: " response

    case "${response}" in
        y|Y) return 0 ;;
        *) return 1 ;;
    esac

}

check_ok() {
    printf "%-45s ${GREEN}OK${NC}\n" "$1"
}

check_fail() {
    printf "%-45s ${RED}ERROR${NC}\n" "$1"
}

check_warn() {
    printf "%-45s ${YELLOW}WARN${NC}\n" "$1"
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

check_docker() {

    if ! command -v docker >/dev/null 2>&1; then

        error "Docker no está instalado."

        exit 1

    fi

    if ! docker info >/dev/null 2>&1; then

        error "No se pudo conectar con Docker."

        info "Si acabas de iniciar sesión ejecuta:"
        echo
        echo "    newgrp docker"
        echo

        exit 1

    fi

}

check_docker_context() {

    CURRENT_CONTEXT="$(docker context show)"

    if [ "${CURRENT_CONTEXT}" != "default" ]; then

        warning "Cambiando Docker Context a 'default'..."

        docker context use default >/dev/null

    fi

}

check_compose_file() {

    if [ ! -f "${COMPOSE_FILE}" ]; then

        error "No se encontró docker-compose.yml."
        info "Ruta esperada: ${COMPOSE_FILE}"

        exit 1

    fi

}

check_docker_image() {

    if ! docker image inspect "${IMAGE_NAME}" >/dev/null 2>&1; then

        warning "La imagen ${IMAGE_NAME} no existe."
        info "Construyendo imagen Docker..."

        docker_compose build

    fi

}

check_command() {

    local command_name="$1"
    local label="${2:-$1}"

    if command -v "${command_name}" >/dev/null 2>&1; then
        check_ok "${label}"
    else
        check_fail "${label}"
        return 1
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
        echo "./scripts/ws_build.sh"

        exit 1

    fi

}

ensure_maps_dir() {

    mkdir -p "${MAPS_DIR}"

}

check_map_file() {

    local map_file="$1"

    if [ ! -f "${map_file}" ]; then

        error "Mapa no encontrado."
        info "Ruta esperada: ${map_file}"
        info "Genera un mapa con:"
        echo "./scripts/slam_run.sh"
        echo "./scripts/slam_save_map.sh"

        exit 1

    fi

}

#############################################
# Cargar entorno
#############################################

load_workspace() {

    cd "${WORKSPACE}"

    source /opt/ros/humble/setup.bash
    source install/setup.bash

}

#############################################
# Docker Compose
#############################################

docker_compose() {

    USER_UID="$(id -u)" USER_GID="$(id -g)" \
        docker compose -f "${COMPOSE_FILE}" "$@"

}

allow_xhost_if_available() {

    if command -v xhost >/dev/null 2>&1; then
        xhost +local: >/dev/null
    fi

}

stop_project_containers() {

    local containers

    containers="$(docker ps --filter "name=${CONTAINER_NAME}" -q)"

    if [ -z "${containers}" ]; then
        info "No hay contenedores activos de MiniTractor."
        return 0
    fi

    docker stop ${containers} >/dev/null

}
