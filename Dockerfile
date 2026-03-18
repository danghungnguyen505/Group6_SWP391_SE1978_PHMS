# --- Giai đoạn 1: Build bằng Ant ---
FROM eclipse-temurin:17-jdk AS builder

# Cài đặt Ant và wget
RUN apt-get update && apt-get install -y --no-install-recommends ant wget

WORKDIR /app

# Tải thư viện CopyLibs (Sử dụng bản RELEASE110 ổn định hơn, tránh lỗi 404)
RUN wget https://repo1.maven.org/maven2/org/netbeans/external/org-netbeans-modules-java-j2seproject-copylibstask/RELEASE110/org-netbeans-modules-java-j2seproject-copylibstask-RELEASE110.jar -O /app/copylibstask.jar

# Copy toàn bộ code vào
COPY . .

# MẸO QUAN TRỌNG: Tự tạo thư mục lib và tải servlet-api nếu bạn chưa push lên GitHub
# Việc này giúp tránh lỗi "package javax.servlet does not exist"
RUN mkdir -p PHMS/lib && \
    wget https://repo1.maven.org/maven2/javax/servlet/javax.servlet-api/3.1.0/javax.servlet-api-3.1.0.jar -O PHMS/lib/servlet-api.jar

# Giới hạn RAM cho Ant để tránh Render bị crash (Gói Free chỉ có 512MB RAM)
ENV ANT_OPTS="-Xmx256m"

# Chạy lệnh build của Ant
RUN cd PHMS && ant -f build.xml dist -Dlibs.CopyLibs.classpath=/app/copylibstask.jar

# --- Giai đoạn 2: Chạy bằng Tomcat ---
FROM tomcat:9.0-jdk17-temurin

# Xóa các app mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file .war từ giai đoạn builder sang Tomcat
COPY --from=builder /app/PHMS/dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

C
