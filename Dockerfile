FROM maven:3.8-openjdk-16-slim as mvn
COPY . /opt/blocklist-api
RUN cd /opt/blocklist-api \
    && mvn clean package \
    && mv /opt/blocklist-api/target/blocklist-api*.jar /opt/blocklist-api/app.jar


FROM openjdk:16-jdk-buster
ARG JAR_FILE=target/*.jar
WORKDIR /opt/blocklist-api
COPY --from=mvn /opt/blocklist-api/app.jar /opt/blocklist-api/app.jar
ENTRYPOINT ["java","-jar","/opt/blocklist-api/app.jar"]
EXPOSE 8080

