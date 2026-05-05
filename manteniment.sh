#!/usr/bin/env bash
set -Eeuo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_NAME="pagila"
LOG_FILE="$BASE_DIR/manteniment-pagila.log"

GREEN="\e[32m"
BLUE="\e[34m"
RED="\e[31m"
RESET="\e[0m"

exec > >(tee "$LOG_FILE") 2>&1

info() {
    echo -e "${BLUE}[INFO]${RESET} $1"
}

ok() {
    echo -e "${GREEN}[OK]${RESET} $1"
}

fail() {
    echo -e "${RED}[ERROR]${RESET} $1"
}

trap 'fail "Error en la línea $LINENO. Revisa $LOG_FILE"; exit 1' ERR

run_maintenance() {
    local sql="$1"
    info "Ejecutando: $sql"
    (cd /tmp && sudo -u postgres psql -v ON_ERROR_STOP=1 -d "$DB_NAME" -c "$sql")
}

sudo -v

info "Inicio del mantenimiento de Pagila"

run_maintenance "VACUUM ANALYZE rental;"
run_maintenance "VACUUM ANALYZE payment;"
run_maintenance "VACUUM ANALYZE inventory;"
run_maintenance "VACUUM ANALYZE film;"
run_maintenance "REINDEX TABLE rental;"
run_maintenance "REINDEX TABLE payment;"
run_maintenance "REINDEX TABLE inventory;"
run_maintenance "REINDEX TABLE film;"

ok "Mantenimiento finalizado correctamente"
info "Log guardado en $LOG_FILE"
