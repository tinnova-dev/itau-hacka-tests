# syntax=docker/dockerfile:1

# Etapa 1: Build
FROM golang:1.21-alpine AS build
WORKDIR /app

# Copiar arquivos de dependências
COPY go.mod go.sum ./
RUN go mod download

# Copiar código fonte
COPY . .

# Compilar a aplicação
RUN CGO_ENABLED=0 GOOS=linux go build -o transaction-credit-auth

# Etapa 2: Imagem final
FROM alpine:3.19
WORKDIR /app

# Instalar ferramentas para healthcheck
RUN apk --no-cache add curl

# Copiar o binário compilado
COPY --from=build /app/transaction-credit-auth .

# Expor a porta que a aplicação utiliza
EXPOSE 8085

# Configurar healthcheck
HEALTHCHECK --interval=10s --timeout=5s --retries=3 CMD curl -X POST -H "Content-Type: application/json" -d '{"amount": 100}' http://localhost:8084/transaction || exit 1

# Executar a aplicação
ENTRYPOINT ["./transaction-credit-auth"]
