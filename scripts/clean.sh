#!/usr/bin/env bash

set -e

PROJECT_ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
WORKSPACE="${PROJECT_ROOT}/workspace"

echo "MiniTractor - Clean"
echo

if [ ! -d "${WORKSPACE}" ]; then
    echo "Error: No existe el workspace."
    exit 1
fi

cd "${WORKSPACE}"

echo "Se eliminarán:"
echo

echo "  build/"
echo "  install/"
echo "  log/"
echo

read -rp "¿Continuar? [y/N]: " RESP

case "$RESP" in
    y|Y)

        rm -rf build install log

        echo
        echo "Workspace limpiado correctamente."
        ;;

    *)

        echo
        echo "Operación cancelada."
        ;;

esac