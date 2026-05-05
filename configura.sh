#!/usr/bin/env bash
set -Eeuo pipefail

BASE_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOG_FILE="$BASE_DIR/configuracio-pagila.log"
SQL_DIR="$BASE_DIR/scripts-sql"
DB_NAME="pagila"

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

run_sql() {
    local file="$1"
    info "Ejecutando $file"
    (cd /tmp && sudo -u postgres psql -v ON_ERROR_STOP=1 -d "$DB_NAME" < "$file")
    ok "Ejecutado correctamente: $file"
}

sudo -v

info "Inicio de la configuración de Pagila"
info "Activando PostgreSQL"
sudo systemctl enable --now postgresql
sudo systemctl status postgresql --no-pager

info "Fase 0: preparación de Pagila"
bash "$SQL_DIR/00-prepara-pagila.sh"

info "Fase SQL"
run_sql "$SQL_DIR/01-rols.sql"
run_sql "$SQL_DIR/02-permisos.sql"
run_sql "$SQL_DIR/03-vistes.sql"
run_sql "$SQL_DIR/04-triggers.sql"

ok "Configuración completa finalizada correctamente"
info "Log guardado en $LOG_FILE"
