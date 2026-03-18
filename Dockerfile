# --- Bước 1: Build bằng Ant ---
FROM openjdk:17-jdk-slim AS builder

# Cài đặt Ant
RUN apt-get update && apt-get install -y ant

# Thiết lập thư mục làm việc là thư mục PHMS (nơi chứa build.xml)
WORKDIR /app/PHMS

# Copy toàn bộ nội dung vào container
COPY . /app

# Chạy lệnh build của Ant bên trong thư mục PHMS
# Lệnh này sẽ tạo ra file .war trong PHMS/dist/
RUN ant -f build.xml dist

# --- Bước 2: Chạy bằng Tomcat ---
FROM tomcat:9.0-jdk17-openjdk-slim

RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file .war từ thư mục build của bước trước
# Lưu ý đường dẫn: /app/PHMS/dist/
COPY --from=builder /app/PHMS/dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
