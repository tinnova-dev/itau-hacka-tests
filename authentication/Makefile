# Makefile para backend-kotlin (Spring Boot + Kotlin)

APP_NAME=backend-kotlin
JAR_FILE=build/libs/*.jar

.PHONY: help build run test clean docker-build docker-run docker-stop compose-up compose-down lint

help:
	@echo "Comandos disponíveis:"
	@echo "  build         - Build local do projeto (Gradle)"
	@echo "  run           - Roda a aplicação localmente (Gradle)"
	@echo "  test          - Executa os testes (Gradle)"
	@echo "  clean         - Limpa arquivos de build (Gradle)"
	@echo "  docker-build  - Build da imagem Docker local"
	@echo "  docker-run    - Roda o container Docker localmente"
	@echo "  docker-stop   - Para o container Docker"
	@echo "  compose-up    - Sobe tudo com Docker Compose (API + DB)"
	@echo "  compose-down  - Para tudo do Docker Compose"
	@echo "  lint          - (Opcional) Lint no código Kotlin"

build:
	./gradlew build

run:
	./gradlew bootRun

test:
	./gradlew test

clean:
	./gradlew clean

docker-build:
	docker build -t $(APP_NAME):latest .

docker-run:
	docker run --rm -p 8080:8080 --name $(APP_NAME) $(APP_NAME):latest

docker-stop:
	docker stop $(APP_NAME) || true

compose-up:
	docker-compose up --build

compose-down:
	docker-compose down

lint:
	./gradlew ktlintCheck || echo "ktlint não está configurado. Adicione o plugin se desejar lint." 