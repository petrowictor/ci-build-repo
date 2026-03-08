# ---------- Stage 1 : build ----------
FROM gradle:8.7-jdk24 AS builder

WORKDIR /build

COPY . .

RUN gradle bootJar --no-daemon


# ---------- Stage 2 : runtime ----------
FROM eclipse-temurin:24-jdk

WORKDIR /app

COPY --from=builder /build/build/libs/*.jar app.jar

EXPOSE 8080

ENTRYPOINT ["java", "-jar", "/app/app.jar"]