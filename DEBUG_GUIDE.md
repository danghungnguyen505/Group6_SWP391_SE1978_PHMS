# Hướng Dẫn Debug - Thêm Thú Cưng và Đặt Lịch

## Các Vấn Đề Đã Được Sửa

### 1. Database Connection Check
- Đã thêm kiểm tra `connection == null` trước khi thực thi SQL
- Đã cải thiện logging trong DBContext để hiển thị lỗi kết nối

### 2. Generated Keys Handling
- Đã sửa cách lấy generated keys từ SQL Server
- Thử lấy theo tên cột trước, nếu không được thì lấy theo index

### 3. Error Logging
- Đã thêm logging chi tiết trong các method createPet và createAppointment
- Hiển thị SQL statement, parameters, và kết quả

### 4. Exception Handling
- Đã thêm try-catch trong controllers để bắt exception
- Hiển thị thông báo lỗi chi tiết hơn cho user

## Cách Kiểm Tra Lỗi

### Bước 1: Kiểm Tra Database Connection

1. Mở console log của server (Tomcat/GlassFish)
2. Khởi động ứng dụng
3. Tìm dòng: `"Database connection established successfully!"`
   - Nếu không thấy → Database connection thất bại
   - Kiểm tra:
     - SQL Server đang chạy?
     - Database PHMS_DB đã được tạo?
     - Username/password đúng? (sa/123)
     - Port 1433 có bị chặn?

### Bước 2: Kiểm Tra Khi Thêm Thú Cưng

1. Mở console log
2. Thử thêm thú cưng
3. Tìm các dòng log:
   ```
   Executing SQL: INSERT INTO Pet...
   Parameters: ownerId=X, name=..., species=...
   Execute update result: 1
   Created pet with ID: X
   ```

**Nếu thấy lỗi:**
- `"Database connection is null!"` → Kiểm tra DBContext
- `"No rows affected!"` → Kiểm tra SQL syntax hoặc foreign key constraints
- `"No generated keys returned!"` → Vấn đề với IDENTITY column

### Bước 3: Kiểm Tra Khi Đặt Lịch

1. Mở console log
2. Thử đặt lịch
3. Tìm các dòng log:
   ```
   Executing SQL: INSERT INTO Appointment...
   Parameters: petId=X, vetId=Y, startTime=..., type=...
   Execute update result: 1
   Created appointment with ID: X
   ```

**Nếu thấy lỗi:**
- Kiểm tra petId có tồn tại không
- Kiểm tra vetId có tồn tại không
- Kiểm tra startTime có hợp lệ không

## Các Lỗi Thường Gặp

### Lỗi 1: "Database connection is null"
**Nguyên nhân:** Không kết nối được database
**Giải pháp:**
1. Kiểm tra SQL Server đang chạy
2. Kiểm tra database PHMS_DB đã được tạo
3. Kiểm tra username/password trong DBContext.java
4. Kiểm tra port 1433

### Lỗi 2: "No rows affected"
**Nguyên nhân:** SQL không thực thi được
**Giải pháp:**
1. Kiểm tra foreign key constraints
2. Kiểm tra dữ liệu đầu vào có hợp lệ không
3. Kiểm tra SQL syntax

### Lỗi 3: "No generated keys returned"
**Nguyên nhân:** SQL Server không trả về generated keys
**Giải pháp:**
1. Kiểm tra IDENTITY column có được set đúng không
2. Thử query trực tiếp trong SQL Server Management Studio

### Lỗi 4: Foreign Key Constraint Violation
**Nguyên nhân:** 
- ownerId không tồn tại trong PetOwner
- petId không tồn tại trong Pet
- vetId không tồn tại trong Veterinarian

**Giải pháp:**
1. Kiểm tra dữ liệu trong database
2. Đảm bảo user đã login và có owner_id hợp lệ
3. Đảm bảo pet đã được tạo trước khi đặt lịch

## SQL Queries Để Kiểm Tra

```sql
-- Kiểm tra connection
SELECT @@VERSION;

-- Kiểm tra database
USE PHMS_DB;
GO

-- Kiểm tra bảng Pet
SELECT * FROM Pet;

-- Kiểm tra bảng Appointment
SELECT * FROM Appointment;

-- Kiểm tra PetOwner
SELECT * FROM PetOwner;

-- Kiểm tra Veterinarian
SELECT * FROM Veterinarian;

-- Kiểm tra user hiện tại
SELECT * FROM Users WHERE role = 'Owner';
```

## Test Thủ Công

### Test Thêm Pet:
```sql
INSERT INTO Pet (owner_id, name, species, history_summary) 
VALUES (5, N'Test Pet', N'Chó', N'Test history');
```

### Test Đặt Lịch:
```sql
INSERT INTO Appointment (pet_id, vet_id, start_time, status, type, created_at) 
VALUES (1, 2, GETDATE(), 'Pending Confirmation', 'Checkup', GETDATE());
```

Nếu các query này chạy được trong SQL Server nhưng không chạy được trong ứng dụng, vấn đề là ở Java code hoặc connection.

## Kiểm Tra Console Log

Khi chạy ứng dụng, console sẽ hiển thị:
- Database connection status
- SQL statements
- Parameters
- Results
- Errors với chi tiết đầy đủ

Hãy copy toàn bộ log khi gặp lỗi để debug dễ hơn.
