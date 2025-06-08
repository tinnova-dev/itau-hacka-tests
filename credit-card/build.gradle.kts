import org.jetbrains.kotlin.gradle.tasks.KotlinCompile

plugins {
    id("org.springframework.boot") version "3.2.6"
    id("io.spring.dependency-management") version "1.1.4"
    kotlin("jvm") version "1.9.23"
    kotlin("plugin.spring") version "1.9.23"
    id("org.jlleitschuh.gradle.ktlint") version "12.1.1"
    // id("jacoco") // Descomente se quiser cobertura de testes
    // id("org.liquibase.gradle") version "2.2.0" // Descomente se for usar Liquibase
}

group = "com.hackathon"
version = "0.0.1-SNAPSHOT"
java.sourceCompatibility = JavaVersion.VERSION_21

val mapstructVersion = "1.5.5.Final"
val springdocVersion = "2.5.0"
val jjwtVersion = "0.11.5"
val retrofitVersion = "2.11.0"
val converterGsonVersion = "2.11.0"
val azureBlobSdkVersion = "12.25.0"

repositories {
    mavenCentral()
}

dependencies {
    // --- Core ---
    implementation("org.springframework.boot:spring-boot-starter-web")
//    implementation("org.springframework.boot:spring-boot-starter-data-jpa")
    implementation("org.springframework.boot:spring-boot-starter-validation")
    implementation("org.springframework.boot:spring-boot-starter-actuator")
    implementation("org.springdoc:springdoc-openapi-starter-webmvc-ui:$springdocVersion")
    implementation("com.fasterxml.jackson.module:jackson-module-kotlin")
    implementation("org.jetbrains.kotlin:kotlin-reflect")
    implementation("org.jetbrains.kotlin:kotlin-stdlib-jdk8")
//    implementation("io.r2dbc:r2dbc-spi:1.0.0.RELEASE")
    implementation("org.springframework.cloud:spring-cloud-starter-openfeign")
    implementation("org.springframework.cloud:spring-cloud-commons")

//    // --- Infraestrutura ---
//    runtimeOnly("org.postgresql:postgresql")
//    // implementation("org.liquibase:liquibase-core") // Descomente se for usar Liquibase
//    implementation("com.squareup.retrofit2:retrofit:$retrofitVersion")
//    implementation("com.squareup.retrofit2:converter-gson:$converterGsonVersion")
//    implementation("com.azure:azure-storage-blob:$azureBlobSdkVersion")
//
//    // --- Segurança ---
//    implementation("org.springframework.boot:spring-boot-starter-oauth2-resource-server")
//    implementation("io.jsonwebtoken:jjwt-api:$jjwtVersion")
//    runtimeOnly("io.jsonwebtoken:jjwt-impl:$jjwtVersion")
//    runtimeOnly("io.jsonwebtoken:jjwt-jackson:$jjwtVersion")

    // --- Modularidade/Observabilidade (opcional) ---
    // implementation("org.springframework.modulith:spring-modulith-starter-core")
    // implementation("org.springframework.modulith:spring-modulith-starter-jpa")
    // runtimeOnly("org.springframework.modulith:spring-modulith-actuator")
    // runtimeOnly("org.springframework.modulith:spring-modulith-observability")

    // --- Desenvolvimento ---
    developmentOnly("org.springframework.boot:spring-boot-devtools")
    implementation("org.glassfish.jersey.core:jersey-server:3.1.3") // ou a versão mais recente
    implementation("org.glassfish.jersey.containers:jersey-container-servlet-core:3.1.3")

    // --- Testes ---
    testImplementation("org.springframework.boot:spring-boot-starter-test")
    // testImplementation("org.springframework.modulith:spring-modulith-starter-test")
    // testRuntimeOnly("org.junit.platform:junit-platform-launcher")
    // testImplementation("org.testcontainers:junit-jupiter") // Para testes com containers
    // testImplementation("org.testcontainers:postgresql")
}

dependencyManagement {
    imports {
        mavenBom("org.springframework.cloud:spring-cloud-dependencies:2023.0.0")
    }
}

tasks.withType<KotlinCompile> {
    kotlinOptions {
        freeCompilerArgs = listOf("-Xjsr305=strict")
        jvmTarget = "21"
    }
}

tasks.withType<Test> {
    useJUnitPlatform()
}

// Jacoco e Liquibase podem ser configurados aqui se necessário
// Consulte o build.gradle do food-core-api para exemplos avançados
