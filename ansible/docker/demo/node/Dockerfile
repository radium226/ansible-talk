# Flème d'installer Node à la main, on va partir d'une image existante
FROM  mhart/alpine-node:latest
MAINTAINER Adrien

# On met à jour les différents packages pour être sur d'avoir les dernières
# versions
RUN apk update && \
    apk upgrade

# On install sudo et on le configure pour ignore TTY, et on ajoute l'utilisateur
# système pour Node
RUN apk add "sudo" "sed" "bash" "nmap" && \
    sed -i "1s/^/Defaults !requiretty\n/" "/etc/sudoers" && \
    adduser -S "node"

# On prépare le dossier qui va accueillir l'application et on se place dedans

RUN mkdir "/docker" && \
    mkdir "/docker/src" && \
    mkdir "/docker/dist" && \
    chown -R "node" "/docker"
USER "node"
WORKDIR "/docker"

# On profite du cache de Docker pour éviter de retélécharger tout les packages
# à chaque fois
COPY ["package.json", "/docker/package.json"]
RUN npm install

# On lance la compilation
COPY ["src/", "/docker/src/"]
RUN npm run "build"

EXPOSE 3000
ENTRYPOINT ["node"]
CMD ["dist"]
