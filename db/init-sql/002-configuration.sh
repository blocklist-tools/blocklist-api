#!/bin/bash
set -e

echo "shared_preload_libraries = 'pg_stat_statements'" >> "${PGDATA}/postgresql.conf"
echo "pg_stat_statements.track = all" >> "${PGDATA}/postgresql.conf"

