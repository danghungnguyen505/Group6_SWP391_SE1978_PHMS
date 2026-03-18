# --- Bước 1: Build bằng Ant ---
FROM openjdk:17-jdk-slim AS builder
RUN apt-get update && apt-get install -y ant

# Thư mục làm việc trong container
WORKDIR /app

# Copy toàn bộ nội dung từ máy/github vào /app trong container
COPY . .

# Chú ý: Di chuyển vào thư mục PHMS nơi có file build.xml để chạy lệnh ant
RUN cd PHMS && ant -f build.xml dist

# --- Bước 2: Chạy bằng Tomcat ---
FROM tomcat:9.0-jdk17-openjdk-slim
RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file .war từ thư mục dist bên trong PHMS
# Dấu * giúp lấy file war bất kể tên là gì
COPY --from=builder /app/PHMS/dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080
CMD ["catalina.sh", "run"]
