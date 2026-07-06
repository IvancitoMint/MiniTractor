#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="${PROJECT_ROOT}/docker/docker-compose.yml"
IMAGE_NAME="minitractor:humble"

echo "MiniTractor - Docker"
echo

if command -v xhost >/dev/null 2>&1; then
    xhost +local: >/dev/null
fi

if ! command -v docker >/dev/null 2>&1; then
    echo "Error: Docker no está instalado."
    exit 1
fi

if [ "$(docker context show)" != "default" ]; then
    echo "Cambiando Docker context a default..."
    docker context use default
fi

if ! docker info >/dev/null 2>&1; then
    echo "Error: no se puede acceder al daemon de Docker."
    echo
    echo "Prueba:"
    echo "  newgrp docker"
    echo "o cierra sesión y vuelve a entrar."
    exit 1
fi

if [ ! -f "${COMPOSE_FILE}" ]; then
    echo "Error: no se encontró docker-compose.yml."
    echo "Ruta esperada: ${COMPOSE_FILE}"
    exit 1
fi

if ! docker image inspect "${IMAGE_NAME}" >/dev/null 2>&1; then
    echo "La imagen ${IMAGE_NAME} no existe. Construyendo..."
    USER_UID="$(id -u)" USER_GID="$(id -g)" \
        docker compose -f "${COMPOSE_FILE}" build
fi

echo "Entrando al contenedor..."
echo

USER_UID="$(id -u)" USER_GID="$(id -g)" \
    docker compose -f "${COMPOSE_FILE}" run --rm minitractor