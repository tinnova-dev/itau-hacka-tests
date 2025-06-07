# Backend Kotlin - Boilerplate Hackathon

Este projeto é um ponto de partida para APIs Kotlin/Spring Boot, seguindo as melhores práticas do Hackathon Itaú + Multi-Cloud.

## Stack
- **Kotlin** + **Spring Boot 3.x**
- **Gradle Kotlin DSL**
- **Docker** e **Docker Compose**
- **PostgreSQL** (local/dev)

## Estrutura de Pastas
```
backend-kotlin/
├── Dockerfile
├── docker-compose.yml
├── README.md
├── src/
│   ├── main/
│   │   ├── kotlin/com/hackathon/app/controller/ (.gitkeep)
│   │   ├── kotlin/com/hackathon/app/service/    (.gitkeep)
│   │   ├── kotlin/com/hackathon/app/repository/ (.gitkeep)
│   │   ├── kotlin/com/hackathon/app/model/      (.gitkeep)
│   │   └── resources/application.yml
│   └── test/kotlin/com/hackathon/app/controller/ (.gitkeep)
├── .gitignore
└── .env.example
```

## Como Usar

1. **Gerar o projeto base:**
   - Use o [Spring Initializr](https://start.spring.io/) com as dependências:
     - Spring Web
     - Spring Data JPA
     - PostgreSQL Driver
     - Spring Boot DevTools (opcional)
     - Springdoc OpenAPI (Swagger)
   - Extraia o conteúdo para `src/` conforme a estrutura acima.

2. **Build e Run com Docker Compose:**
   ```bash
   docker-compose up --build
   ```
   A API estará disponível em [http://localhost:8080](http://localhost:8080)
   
3. **Documentação da API:**
   - Swagger UI: [http://localhost:8080/swagger-ui.html](http://localhost:8080/swagger-ui.html)

4. **Variáveis de Ambiente:**
   - Veja `.env.example` para exemplos de configuração.

## Dicas
- Use o script `./gradlew build` para build local.
- O healthcheck do container depende do endpoint `/actuator/health`.
- Adapte os pacotes conforme o domínio do seu app.

## Links Úteis
- [Spring Boot](https://spring.io/projects/spring-boot)
- [Spring Initializr](https://start.spring.io/)
- [Springdoc OpenAPI](https://springdoc.org/)
- [Documentação Docker Compose](https://docs.docker.com/compose/) 