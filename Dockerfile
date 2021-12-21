FROM maven:3.8-openjdk-17-slim as mvn
COPY . /opt/blocklist-api
RUN cd /opt/blocklist-api \
    && mvn clean package \
    && mv /opt/blocklist-api/target/blocklist-api*.jar /opt/blocklist-api/app.jar


FROM openjdk:17-jdk-buster
ARG JAR_FILE=target/*.jar
WORKDIR /opt/blocklist-api
COPY --from=mvn /opt/blocklist-api/app.jar /opt/blocklist-api/app.jar
RUN curl --output /tmp/newrelic.zip https://download.newrelic.com/newrelic/java-agent/newrelic-agent/current/newrelic-java.zip \
    && unzip /tmp/newrelic.zip -d / \
    && rm /tmp/newrelic.zip
COPY newrelic.yml /newrelic/newrelic.yml
ENTRYPOINT ["java","-javaagent:/newrelic/newrelic.jar","-jar","/opt/blocklist-api/app.jar"]
EXPOSE 8080

