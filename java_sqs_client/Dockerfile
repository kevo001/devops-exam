# Stage 1: Build the Java application
FROM maven:3.8.4-openjdk-17 AS build
WORKDIR /app
COPY . .
RUN mvn package -DskipTests

# Stage 2: Run the application with JRE 17
FROM openjdk:17-slim
WORKDIR /app
COPY --from=build /app/target/imagegenerator-0.0.1-SNAPSHOT.jar app.jar

# Environment variables and entry point
ENV SQS_QUEUE_URL=""
ENTRYPOINT ["java", "-jar", "app.jar"]