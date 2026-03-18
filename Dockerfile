FROM tomcat:9.0-jdk17-temurin

# Xóa app mặc định
RUN rm -rf /usr/local/tomcat/webapps/*

# Chỉ copy file .war bạn đã build sẵn ở máy cá nhân vào
COPY PHMS.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
