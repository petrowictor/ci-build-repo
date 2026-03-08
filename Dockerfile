# ---------- build stage ----------
FROM gradle:8.7-jdk24 AS builder

WORKDIR /build

# 1. Копируем только файлы зависимостей
COPY build.gradle settings.gradle gradle.properties ./
COPY gradle gradle

# 2. Скачиваем зависимости (этот слой будет кешироваться)
RUN gradle dependencies --no-daemon || true

# 3. Теперь копируем исходники
COPY src src

# 4. Собираем jar
RUN gradle bootJar --no-daemon


# ---------- runtime stage ----------
FROM eclipse-temurin:24-jdk

WORKDIR /app

COPY --from=builder /build/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java","-jar","/app/app.jar"]