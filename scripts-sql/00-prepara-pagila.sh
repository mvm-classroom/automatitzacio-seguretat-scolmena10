#!/usr/bin/env bash
set -Eeuo pipefail

REPO_URL="https://github.com/devrimgunduz/pagila.git"
REPO_DIR="/tmp/pagila-src"
DB_NAME="pagila"

echo "[INFO] Preparando base de datos Pagila"

if [ -d "$REPO_DIR" ]; then
    echo "[INFO] Eliminando carpeta anterior $REPO_DIR"
    rm -rf "$REPO_DIR"
fi

echo "[INFO] Clonando repositorio oficial de Pagila"
git clone "$REPO_URL" "$REPO_DIR"

echo "[INFO] Eliminando base de datos anterior si existe"
(cd /tmp && sudo -u postgres psql -v ON_ERROR_STOP=1 -d postgres -c "SELECT pg_terminate_backend(pid) FROM pg_stat_activity WHERE datname = '$DB_NAME';")
(cd /tmp && sudo -u postgres psql -v ON_ERROR_STOP=1 -d postgres -c "DROP DATABASE IF EXISTS $DB_NAME;")

echo "[INFO] Creando base de datos $DB_NAME"
(cd /tmp && sudo -u postgres createdb "$DB_NAME")

echo "[INFO] Cargando esquema"
(cd /tmp && sudo -u postgres psql -v ON_ERROR_STOP=1 -d "$DB_NAME" -f "$REPO_DIR/pagila-schema.sql")

echo "[INFO] Cargando datos"
(cd /tmp && sudo -u postgres psql -v ON_ERROR_STOP=1 -d "$DB_NAME" -f "$REPO_DIR/pagila-insert-data.sql")

echo "[OK] Base de datos Pagila preparada correctamente"
