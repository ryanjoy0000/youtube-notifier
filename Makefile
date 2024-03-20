PRODUCER_BINARY=producerBinary
# ----------------------------
# up: stops docker-compose, builds all projects and starts docker-compose
up: build_producer
	@echo "Stopping docker containers if any..."
	docker-compose -f ./kafka.yml down
	@echo "Building & starting all services ..."
	docker-compose -f ./kafka.yml up --build

# up_kafka: starts all containers related to kafka
up_kafka:
	@echo "Building & starting all kafka services ..."
	docker-compose -f ./kafka.yml up zookeeper kafka-broker kafka-schema-registry ksqldb-server ksqldb-cli --build

# up_producer: start producer-service
up_producer: down_producer
	docker-compose -f ./kafka.yml up producer-service --build

# down_producer: stop producer-service
down_producer:
	docker-compose -f ./kafka.yml down producer-service

# down : stop docker-compose
down:
	@echo "Stopping docker-compose..."
	docker-compose -f ./kafka.yml down

# build_producer: Build the producer service -> binary as a linux executable
build_producer:
	# @echo "Removing old executable..."
	# rm -f ./producer/producerBinary
	# @echo "Building the producer service -> binary..."
	# cd ./producer && env CGO_ENABLED=1 GOARCH=arm64 go build -o ${PRODUCER_BINARY} .
	# @echo "Setting permissions on executable..."
	# chmod +x ./producer/producerBinary
	# @echo "executable file type:"
	# file ./producer/producerBinary
	# ls -l ./producer/producerBinary
