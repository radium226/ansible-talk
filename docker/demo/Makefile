# Build the Postgres image
build-postgres:
	docker build \
		--pull \
		--tag "demo-postgres:latest" \
		"./postgres"

build: build-postgres

debug-postgres: build-postgres
	docker run \
		--interactive --tty \
		--entrypoint "/bin/bash" \
		--hostname "postgres" \
		--name "postgres" \
		--rm \
		"demo-postgres:latest"

# Debug the Postgres image
run-postgres: build-postgres
	docker run \
		--interactive --publish-all \
		--env POSTGRES_USER="demo" \
		--env POSTGRES_PASSWORD="demo" \
		--hostname "postgres" \
		--name "postgres" \
		--volume "$(CURDIR)/postgres-data:/var/lib/postgresql/data" \
		--rm \
		"demo-postgres:latest"

exec-node:
	docker exec -i -t "postgres" "/bin/bash"

# Build the Node image
build-node:
	docker build \
		--pull \
		--tag "demo-node:latest" \
		"./node"

# Debug the Node image
debug-node: build-node
	docker run \
		--interactive --tty \
		--hostname "node" \
		--name "node" \
		--rm \
		--entrypoint="/bin/bash" \
		"demo-node:latest"

exec-node:
	docker exec -i -t "node" "/bin/bash"

# Run the Node image
run-node: build-node
	mkdir -p "postgres-data/"
	docker run \
		--interactive \
		--publish "3000:3000" \
		--hostname "node" \
		--name "node" \
		--link "postgres" \
		--rm \
		"demo-node:latest"
