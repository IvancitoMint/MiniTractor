#!/usr/bin/env bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
source "${SCRIPT_DIR}/lib/common.sh"

banner

check_workspace

warning "Se eliminarán los directorios generados por colcon:"
echo
echo "  build/"
echo "  install/"
echo "  log/"
echo

if ! confirm "¿Continuar?"; then
    echo
    info "Operación cancelada."
    exit 0
fi

cd "${WORKSPACE}"

rm -rf build install log

echo
success "Workspace limpiado correctamente."
