# --- Bước 1: Build bằng Ant ---
# Thay openjdk:17-jdk-slim bằng eclipse-temurin:17-jdk
FROM eclipse-temurin:17-jdk AS builder

# Cài đặt công cụ Ant
RUN apt-get update && apt-get install -y ant

# Thư mục làm việc trong container
WORKDIR /app

# Copy toàn bộ nội dung từ github vào /app
COPY . .

# Di chuyển vào thư mục PHMS nơi có file build.xml để chạy lệnh ant
RUN cd PHMS && ant -f build.xml dist

# --- Bước 2: Chạy bằng Tomcat ---
# Thay tomcat:9.0-jdk17-openjdk-slim bằng tomcat:9.0-jdk17-temurin
FROM tomcat:9.0-jdk17-temurin

# Xóa các ứng dụng mặc định của Tomcat
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file .war từ thư mục dist bên trong PHMS
# Đổi tên thành ROOT.war để chạy tại địa chỉ gốc
COPY --from=builder /app/PHMS/dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
