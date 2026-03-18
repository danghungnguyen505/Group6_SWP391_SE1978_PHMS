# --- Giai đoạn 1: Build bằng Ant ---
FROM eclipse-temurin:17-jdk AS builder

# Cài đặt Ant và wget
RUN apt-get update && apt-get install -y --no-install-recommends ant wget

WORKDIR /app

# TẢI THƯ VIỆN COPYLIBS (Sửa lỗi 404: Chuyển từ folder 'external' sang 'api')
RUN wget https://repo1.maven.org/maven2/org/netbeans/api/org-netbeans-modules-java-j2seproject-copylibstask/RELEASE126/org-netbeans-modules-java-j2seproject-copylibstask-RELEASE126.jar -O /app/copylibstask.jar

# Copy toàn bộ code vào
COPY . .

# Tự động tải servlet-api (Để biên dịch code Servlet không bị lỗi)
RUN mkdir -p PHMS/lib && \
    wget https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.jar -O PHMS/lib/servlet-api.jar

# Giới hạn RAM cho Ant (Tránh Render bị crash 512MB)
ENV ANT_OPTS="-Xmx256m"

# Chạy lệnh build của Ant với CopyLibs vừa tải
RUN cd PHMS && ant -f build.xml dist -Dlibs.CopyLibs.classpath=/app/copylibstask.jar

# --- Giai đoạn 2: Chạy bằng Tomcat ---
FROM tomcat:9.0-jdk17-temurin

# Xóa các app mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file .war vào Tomcat và đổi tên thành ROOT.war
COPY --from=builder /app/PHMS/dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
