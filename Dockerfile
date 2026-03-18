# --- Giai đoạn 1: Build bằng Ant ---
FROM eclipse-temurin:17-jdk AS builder

# Cài đặt Ant và wget để tải thư viện thiếu
RUN apt-get update && apt-get install -y ant wget

WORKDIR /app

# Tải thư viện CopyLibs của NetBeans (Cái này giúp sửa lỗi bạn đang gặp)
RUN wget https://repo1.maven.org/maven2/org/netbeans/external/org-netbeans-modules-java-j2seproject-copylibstask/RELEASE120/org-netbeans-modules-java-j2seproject-copylibstask-RELEASE120.jar -O /app/copylibstask.jar

# Copy toàn bộ code vào container
COPY . .

# Chạy lệnh build của Ant với tham số chỉ định đường dẫn CopyLibs
# Chúng ta truyền thêm biến -Dlibs.CopyLibs.classpath để Ant tìm thấy file vừa tải
RUN cd PHMS && ant -f build.xml dist -Dlibs.CopyLibs.classpath=/app/copylibstask.jar

# --- Giai đoạn 2: Chạy bằng Tomcat ---
FROM tomcat:9.0-jdk17-temurin

RUN rm -rf /usr/local/tomcat/webapps/*

# Copy file .war vào Tomcat
COPY --from=builder /app/PHMS/dist/*.war /usr/local/tomcat/webapps/ROOT.war

EXPOSE 8080

CMD ["catalina.sh", "run"]
