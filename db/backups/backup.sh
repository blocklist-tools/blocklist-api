#!/bin/sh
set -e

pg_dump --username=blocklist --file=backup-data-only-$(date +%s).sql --data-only --no-owner --no-privileges

