# On part de la dernière image disponible d'Alpine Linux
FROM alpine:latest
MAINTAINER Adrien

# On met à jour les différents packages pour être sur d'avoir les dernières
# versions
RUN apk update && \
    apk upgrade

# On install sudo et on le configure
RUN apk add "sudo" "sed" "bash" && \
    sed -i "1s/^/Defaults !requiretty\n/" "/etc/sudoers"

# On installe le package PostgreSQL
RUN apk add "postgresql"

# On défini le volume qui contient les données
VOLUME "/var/lib/postgresql/data"

# On configure le point d'entrée
ENV LANG "en_US.utf8"
ENV PGDATA "/var/lib/postgresql/data"
RUN mkdir "/docker"
COPY "entrypoint.sh" "/docker/entrypoint.sh"
EXPOSE 5432
ENTRYPOINT ["/docker/entrypoint.sh"]

# On démarre la base de données (en tant qu'utilisateur postrgres)
CMD ["postgres"]
