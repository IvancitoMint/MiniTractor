#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

echo "MiniTractor - Stop"
echo

echo "Deteniendo procesos de Gazebo..."
pkill -f gzserver || true
pkill -f gzclient || true
pkill -f gazebo || true
pkill -f spawn_entity || true

echo "Deteniendo contenedores activos del proyecto..."
docker ps --filter "name=minitractor" -q | xargs -r docker stop

echo "Limpiando contenedores detenidos..."
docker container prune -f >/dev/null

echo
echo "Procesos detenidos."