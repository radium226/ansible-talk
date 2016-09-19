#!/bin/bash

export SUCCESS=0
export FAILURE=1

# Postgres ne se lance pas si les droits ne sont pas bons
chmod -R 700 "${PGDATA}"
chown -R "postgres" "${PGDATA}"

# Si la base de donnée n'a pas été initialisée...
if [[ -z "$( ls "${PGDATA}" )" ]]; then
  # ... Alors on l'initialise
  sudo -E -u "postgres" initdb
  sed -ri "s/^#(listen_addresses\s*=\s*)\S+/\1'*'/" "${PGDATA}/postgresql.conf"
  { echo; echo "host all all 0.0.0.0/0 md5"; } >> "${PGDATA}/pg_hba.conf"

  POSTGRES_DATABASE="${POSTGRES_USER}" # C'est plus simple
  echo "CREATE DATABASE ${POSTGRES_DATABASE};" | sudo -E -u "postgres" postgres --single -jE # On créé la base de données
  echo "CREATE USER ${POSTGRES_USER} WITH SUPERUSER PASSWORD '${POSTGRES_PASSWORD}';" | sudo -E -u "postgres" postgres --single -jE # On créé l'utilisateur
fi

exec sudo -E -u "postgres" "${@}" # On lance la base de données
