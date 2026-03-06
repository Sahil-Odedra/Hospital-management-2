# Stage 1: Build source code
FROM maven:3.9-eclipse-temurin-8 AS build
WORKDIR /app
COPY pom.xml .
COPY src ./src
RUN mvn package -DskipTests

# Stage 2: Deploy to Tomcat
FROM tomcat:9.0
RUN rm -rf /usr/local/tomcat/webapps/*
COPY --from=build /app/target/careconnect.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

# Environment Variable Defaults
ENV DB_HOST=localhost \
    DB_USER=root \
    DB_PASS= \
    DB_NAME=hospital

CMD ["catalina.sh", "run"]
