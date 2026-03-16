FROM openjdk:17 AS build

WORKDIR /app
COPY . .

RUN apt-get update && apt-get install -y ant
RUN ant

FROM tomcat:9.0

COPY --from=build /app/dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
