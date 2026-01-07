# BUILD

FROM maven:3-eclipse-temurin-25-alpine AS build

WORKDIR /app

COPY pom.xml .
RUN mvn -B dependency:go-offline

COPY src ./src
RUN mvn -B clean package -DskipTests

# RUNTIME

FROM eclipse-temurin:25-jre-alpine AS runtime

RUN addgroup -S javaapp && adduser -S -G javaapp javaapp

WORKDIR /app

COPY --from=build /app/target/*.jar app.jar

RUN chown -R javaapp:javaapp /app

USER javaapp

ENTRYPOINT ["java", "-jar", "app.jar"]
