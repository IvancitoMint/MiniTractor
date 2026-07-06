#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

banner

check_ros
check_workspace
check_install

MAP_NAME="${1:-${DEFAULT_MAP_NAME}}"

if [ -z "${MAP_NAME}" ]; then
    error "Nombre de mapa inválido."
    exit 1
fi

case "${MAP_NAME}" in
    */*|*.pgm|*.yaml)
        error "Usa solo el nombre base del mapa, sin ruta ni extensión."
        info "Ejemplo: ./scripts/slam_save_map.sh huerto_map"
        exit 1
        ;;
esac

ensure_maps_dir
load_workspace

if ! ros2 topic list | grep -qx "/map"; then
    warning "No se detectó el tópico /map."
    info "Asegúrate de tener SLAM activo con ./scripts/slam_run.sh"
fi

MAP_OUTPUT="${MAPS_DIR}/${MAP_NAME}"

info "Guardando mapa en: ${MAP_OUTPUT}.pgm / ${MAP_OUTPUT}.yaml"

ros2 run nav2_map_server map_saver_cli -f "${MAP_OUTPUT}"

echo
success "Mapa guardado."
