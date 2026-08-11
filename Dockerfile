FROM tomcat:9.0

COPY target/java-app-1.0.war /usr/local/tomcat/webapps/app.war
