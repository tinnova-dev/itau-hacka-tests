# syntax=docker/dockerfile:1

# Etapa 1: Build
FROM gradle:8.7.0-jdk21-alpine AS build
WORKDIR /app
COPY . .
RUN gradle build --no-daemon

# Etapa 2: Imagem final
FROM eclipse-temurin:21-jre-alpine
WORKDIR /app
COPY --from=build /app/build/libs/*.jar app.jar
EXPOSE 8080
HEALTHCHECK --interval=10s --timeout=5s --retries=3 CMD wget --spider -q http://localhost:8080/actuator/health || exit 1
ENTRYPOINT ["java","-jar","app.jar"] 