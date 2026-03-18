# --- Bước 1: Build bằng Ant dùng Eclipse Temurin 17 ---
FROM eclipse-temurin:17-jdk AS builder

# Cài đặt công cụ Ant (debian/ubuntu based)
RUN apt-get update && apt-get install -y ant

# Thiết lập thư mục làm việc
WORKDIR /app

# Copy toàn bộ code vào container
COPY . .

# Di chuyển vào thư mục PHMS và chạy lệnh build
# Lệnh này sẽ tạo ra file .war trong thư mục PHMS/dist/
RUN cd PHMS && ant -f build.xml dist

# --- Bước 2: Chạy bằng Tomcat (Dùng Java 17 chuẩn) ---
FROM tomcat:9.0-jdk17-temurin-jammy

# Xóa các ứng dụng mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file .war từ giai đoạn builder sang thư mục chạy của Tomcat
# Chú ý đường dẫn: /app/PHMS/dist/
COPY --from=builder /app/PHMS/dist/*.war /usr/local/tomcat/webapps/ROOT.war

# Cổng 8080 cho Tomcat
EXPOSE 8080

CMD ["catalina.sh", "run"]
