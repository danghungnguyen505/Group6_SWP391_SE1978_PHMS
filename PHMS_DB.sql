-- 1. Tạo Database
CREATE DATABASE PHMS_DB;
GO
USE PHMS_DB;
GO

-- 2. Bảng Users (Bảng gốc cho PetOwner và Employee)
CREATE TABLE Users (
    user_id INT IDENTITY(1,1) PRIMARY KEY,
    username NVARCHAR(50) NOT NULL UNIQUE,
    password NVARCHAR(255) NOT NULL,
    full_name NVARCHAR(100),
    phone NVARCHAR(20),
    role NVARCHAR(50) -- Admin, Owner, Employee...
);

-- 3. Bảng PetOwner (Kế thừa/Liên kết 1-1 với Users)
CREATE TABLE PetOwner (
    user_id INT PRIMARY KEY,
    address NVARCHAR(255),
    email NVARCHAR(100),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 4. Bảng Employee (Kế thừa/Liên kết 1-1 với Users)
CREATE TABLE Employee (
    user_id INT PRIMARY KEY,
    employee_code VARCHAR(20) UNIQUE,
    department NVARCHAR(100),
    salary_base FLOAT,
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);

-- 5. Các phân hệ chức năng của Employee (1-1 với Employee)
CREATE TABLE Veterinarian (
    emp_id INT PRIMARY KEY,
    license_number VARCHAR(50),
    specialization NVARCHAR(100),
    FOREIGN KEY (emp_id) REFERENCES Employee(user_id)
);

CREATE TABLE Nurse (
    emp_id INT PRIMARY KEY,
    skill_level NVARCHAR(50),
    FOREIGN KEY (emp_id) REFERENCES Employee(user_id)
);

CREATE TABLE Receptionist (
    emp_id INT PRIMARY KEY,
    desk_number VARCHAR(20),
    FOREIGN KEY (emp_id) REFERENCES Employee(user_id)
);

CREATE TABLE ClinicManager (
    emp_id INT PRIMARY KEY,
    manage_level NVARCHAR(50),
    FOREIGN KEY (emp_id) REFERENCES Employee(user_id)
);

-- 6. Bảng Pet
CREATE TABLE Pet (
    pet_id INT IDENTITY(1,1) PRIMARY KEY,
    owner_id INT,
    name NVARCHAR(100),
    species NVARCHAR(50),
    history_summary NVARCHAR(MAX),
    FOREIGN KEY (owner_id) REFERENCES PetOwner(user_id)
);

-- 7. Bảng Appointment (Cuộc hẹn)
CREATE TABLE Appointment (
    appt_id INT IDENTITY(1,1) PRIMARY KEY,
    pet_id INT,
    vet_id INT,
    start_time DATETIME,
    status NVARCHAR(50), -- Pending, Confirmed, Completed, Cancelled
    type NVARCHAR(50),   -- Checkup, Surgery, Urgent
    FOREIGN KEY (pet_id) REFERENCES Pet(pet_id),
    FOREIGN KEY (vet_id) REFERENCES Veterinarian(emp_id)
);

-- 8. Bảng TriageRecord (Sàng lọc ban đầu)
CREATE TABLE TriageRecord (
    triage_id INT IDENTITY(1,1) PRIMARY KEY,
    appt_id INT,
    recep_id INT,
    condition_level NVARCHAR(50),
    initial_symptoms NVARCHAR(MAX),
    triage_time DATETIME,
    FOREIGN KEY (appt_id) REFERENCES Appointment(appt_id),
    FOREIGN KEY (recep_id) REFERENCES Receptionist(emp_id)
);

-- 9. Bảng MedicalRecord (Hồ sơ bệnh án)
CREATE TABLE MedicalRecord (
    record_id INT IDENTITY(1,1) PRIMARY KEY,
    appt_id INT,
    diagnosis NVARCHAR(MAX),
    treatment_plan NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (appt_id) REFERENCES Appointment(appt_id)
);

-- 10. Bảng LabTest (Xét nghiệm)
CREATE TABLE LabTest (
    test_id INT IDENTITY(1,1) PRIMARY KEY,
    record_id INT,
    nurse_id INT,
    test_type NVARCHAR(100),
    request_notes NVARCHAR(MAX),
    result_data NVARCHAR(MAX),
    status NVARCHAR(50),
    FOREIGN KEY (record_id) REFERENCES MedicalRecord(record_id),
    FOREIGN KEY (nurse_id) REFERENCES Nurse(emp_id)
);

-- 11. Bảng Medicine (Thuốc)
CREATE TABLE Medicine (
    medicine_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100),
    unit NVARCHAR(20),
    price FLOAT,
    stock_quantity INT
);

-- 12. Bảng Prescription (Đơn thuốc)
CREATE TABLE Prescription (
    pres_id INT IDENTITY(1,1) PRIMARY KEY,
    record_id INT,
    medicine_id INT,
    quantity INT,
    dosage NVARCHAR(100),
    FOREIGN KEY (record_id) REFERENCES MedicalRecord(record_id),
    FOREIGN KEY (medicine_id) REFERENCES Medicine(medicine_id)
);

-- 13. Bảng Invoice (Hóa đơn)
CREATE TABLE Invoice (
    invoice_id INT IDENTITY(1,1) PRIMARY KEY,
    appt_id INT,
    recep_id INT,
    total_amount FLOAT,
    status NVARCHAR(50), -- Unpaid, Paid, Partially Paid
    FOREIGN KEY (appt_id) REFERENCES Appointment(appt_id),
    FOREIGN KEY (recep_id) REFERENCES Receptionist(emp_id)
);

-- 14. Bảng Payment (Thanh toán)
CREATE TABLE Payment (
    payment_id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id INT,
    trans_code VARCHAR(50),
    amount FLOAT,
    method NVARCHAR(50), -- Cash, Credit Card, Transfer
    status NVARCHAR(50),
    FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id)
);

-- 15. Bảng ServiceList (Danh mục dịch vụ)
CREATE TABLE ServiceList (
    service_id INT IDENTITY(1,1) PRIMARY KEY,
    name NVARCHAR(100) NOT NULL,
    base_price FLOAT NOT NULL,
    description NVARCHAR(MAX),
    is_active BIT DEFAULT 1,
    managed_by INT, 
    FOREIGN KEY (managed_by) REFERENCES ClinicManager(emp_id)
);


-- 16. Bảng InvoiceDetail (Chi tiết hóa đơn)
CREATE TABLE InvoiceDetail (
    detail_id INT IDENTITY(1,1) PRIMARY KEY,
    invoice_id INT NOT NULL,
    medicine_id INT NULL, -- Sẽ có giá trị nếu là bán thuốc
    service_id INT NULL,  -- Sẽ có giá trị nếu là dịch vụ (liên kết với ServiceList)
    item_type NVARCHAR(50) NOT NULL, -- Lưu giá trị: 'Medicine' hoặc 'Service'
    quantity INT NOT NULL DEFAULT 1,
    unit_price FLOAT NOT NULL,
    subtotal AS (quantity * unit_price), -- Cột tự động tính tiền = Số lượng * Đơn giá
    FOREIGN KEY (invoice_id) REFERENCES Invoice(invoice_id),
    FOREIGN KEY (medicine_id) REFERENCES Medicine(medicine_id),
    FOREIGN KEY (service_id) REFERENCES ServiceList(service_id),
    CHECK (
        (item_type = 'Medicine' AND medicine_id IS NOT NULL AND service_id IS NULL)
        OR
        (item_type = 'Service' AND service_id IS NOT NULL AND medicine_id IS NULL)
    )
);
-- 17. Bảng Schedule (Lịch làm việc)
CREATE TABLE Schedule (
    schedule_id INT IDENTITY(1,1) PRIMARY KEY,
    emp_id INT,
    manager_id INT,
    work_date DATE,
    shift_time NVARCHAR(50),
    FOREIGN KEY (emp_id) REFERENCES Employee(user_id),
    FOREIGN KEY (manager_id) REFERENCES ClinicManager(emp_id)
);

-- 18. Bảng LeaveRequest (Yêu cầu nghỉ phép)
CREATE TABLE LeaveRequest (
    leave_id INT IDENTITY(1,1) PRIMARY KEY,
    emp_id INT,
    manager_id INT,
    start_date DATE,
    reason NVARCHAR(MAX),
    status NVARCHAR(50), -- Pending, Approved, Rejected
    FOREIGN KEY (emp_id) REFERENCES Employee(user_id),
    FOREIGN KEY (manager_id) REFERENCES ClinicManager(emp_id)
);

-- 19. Bảng Feedback (Đánh giá)
CREATE TABLE Feedback (
    feedback_id INT IDENTITY(1,1) PRIMARY KEY,
    appt_id INT,
    rating INT CHECK (rating >= 1 AND rating <= 5),
    comment NVARCHAR(MAX),
    FOREIGN KEY (appt_id) REFERENCES Appointment(appt_id)
);

-- 20. Bảng AIChatLog (Lịch sử chat AI)
CREATE TABLE AIChatLog (
    log_id INT IDENTITY(1,1) PRIMARY KEY,
    user_id INT ,
    question_raw NVARCHAR(MAX),
    ai_response NVARCHAR(MAX),
    created_at DATETIME DEFAULT GETDATE(),
    FOREIGN KEY (user_id) REFERENCES Users(user_id)
);
GO


-- 1. TẠO NGƯỜI DÙNG (USERS)
INSERT INTO Users (username, password, full_name, phone, role) VALUES 
('admin', '123', N'Nguyễn Quản Lý', '0901234567', 'Manager'),      -- ID: 1
('vet1', '123', N'Dr. Trần Bác Sĩ', '0912345678', 'Veterinarian'), -- ID: 2
('nurse1', '123', N'Lê Y Tá', '0923456789', 'Nurse'),             -- ID: 3
('recep1', '123', N'Phạm Lễ Tân', '0934567890', 'Receptionist'),  -- ID: 4
('customer1', '123', N'Hoàng Khách Hàng', '0945678901', 'Owner'); -- ID: 5
GO
-- 2. PHÂN QUYỀN VAI TRÒ (ROLES)
-- 2.1 Tạo Pet Owner
INSERT INTO PetOwner (user_id, address, email) VALUES 
(5, N'123 Đường Láng, Hà Nội', 'customer1@gmail.com');

-- 2.2 Tạo Employee (Nhân viên chung)
INSERT INTO Employee (user_id, employee_code, department, salary_base) VALUES 
(1, 'MNG001', N'Ban Giám Đốc', 20000000),
(2, 'VET001', N'Khoa Khám Bệnh', 15000000),
(3, 'NUR001', N'Khoa Xét Nghiệm', 8000000),
(4, 'REC001', N'Tiếp Đón', 7000000);

-- 2.3 Phân vào bảng chi tiết từng nghề
INSERT INTO ClinicManager (emp_id, manage_level) VALUES (1, 'Senior');
INSERT INTO Veterinarian (emp_id, license_number, specialization) VALUES (2, 'LIC-2025-001', N'Chó Mèo & Ngoại Khoa');
INSERT INTO Nurse (emp_id, skill_level) VALUES (3, 'Junior');
INSERT INTO Receptionist (emp_id, desk_number) VALUES (4, 'Desk 1');
GO

-- 3. DỮ LIỆU MASTER (DỊCH VỤ & THUỐC)
-- Danh sách Dịch vụ
INSERT INTO ServiceList (name, base_price, description, is_active, managed_by) VALUES 
(N'Khám Lâm Sàng', 150000, N'Kiểm tra sức khỏe tổng quát', 1, 1),
(N'Tiêm Vaccine Dại', 200000, N'Vaccine phòng dại định kỳ', 1, 1),
(N'Siêu Âm Ổ Bụng', 300000, N'Siêu âm kiểm tra nội tạng', 1, 1),
(N'Xét Nghiệm Máu', 250000, N'Công thức máu toàn phần', 1, 1);

-- Danh sách Thuốc
INSERT INTO Medicine (name, unit, price, stock_quantity) VALUES 
(N'Amoxicillin 500mg', N'Viên', 5000, 1000),
(N'Thuốc tẩy giun Drontal', N'Viên', 50000, 200),
(N'Canxi Nano', N'Lọ', 150000, 50),
(N'Bông băng y tế', N'Cuộn', 10000, 500);
GO

-- 4. DỮ LIỆU VẬN HÀNH (THÚ CƯNG & LỊCH)
-- Thú cưng
INSERT INTO Pet (owner_id, name, species, history_summary) VALUES 
(5, N'Miu Miu', N'Mèo Anh Lông Ngắn', N'Đã tiêm 1 mũi 3 bệnh'),
(5, N'Lu Lu', N'Chó Poodle', N'Dị ứng hải sản');

-- Lịch làm việc nhân viên
INSERT INTO Schedule (emp_id, manager_id, work_date, shift_time) VALUES 
(2, 1, GETDATE(), '08:00 - 17:00'), -- Bác sĩ làm hôm nay
(4, 1, GETDATE(), '08:00 - 17:00'); -- Lễ tân làm hôm nay
GO

-- 5. QUY TRÌNH KHÁM BỆNH (SAMPLE FLOW)
-- 5.1 Đặt lịch hẹn (Appointment)
INSERT INTO Appointment (pet_id, vet_id, start_time, status, type) VALUES 
(1, 2, GETDATE(), 'Completed', 'Checkup'); -- Cuộc hẹn đã xong

-- 5.2 Tiếp đón & Sàng lọc (Triage)
INSERT INTO TriageRecord (appt_id, recep_id, condition_level, initial_symptoms, triage_time) VALUES 
(1, 4, 'Green', N'Mèo bỏ ăn 2 ngày, hơi sốt', GETDATE());

-- 5.3 Hồ sơ bệnh án (Medical Record)
INSERT INTO MedicalRecord (appt_id, diagnosis, treatment_plan, created_at) VALUES 
(1, N'Rối loạn tiêu hóa nhẹ', N'Uống men tiêu hóa và theo dõi tại nhà', GETDATE());

-- 5.4 Chỉ định xét nghiệm (Lab Test)
INSERT INTO LabTest (record_id, nurse_id, test_type, request_notes, result_data, status) VALUES 
(1, 3, N'Xét nghiệm phân', N'Kiểm tra ký sinh trùng', N'Âm tính với giun sán', 'Completed');

-- 5.5 Kê đơn thuốc (Prescription)
INSERT INTO Prescription (record_id, medicine_id, quantity, dosage) VALUES 
(1, 2, 1, N'Uống 1 viên duy nhất vào buổi sáng');

-- 5.6 Tạo Hóa đơn (Invoice)
-- Giả sử: Khám (150k) + Thuốc tẩy giun (50k) = 200k
INSERT INTO Invoice (appt_id, recep_id, total_amount, status) VALUES 
(1, 4, 200000, 'Paid');

-- 5.7 Chi tiết hóa đơn (Invoice Detail)
-- Dòng 1: Tiền công khám (Service)
INSERT INTO InvoiceDetail (invoice_id, service_id, item_type, quantity, unit_price) VALUES 
(1, 1, 'Service', 1, 150000);
-- Dòng 2: Tiền thuốc (Medicine)
INSERT INTO InvoiceDetail (invoice_id, medicine_id, item_type, quantity, unit_price) VALUES 
(1, 2, 'Medicine', 1, 50000);

-- 5.8 Thanh toán (Payment)
INSERT INTO Payment (invoice_id, trans_code, amount, method, status) VALUES 
(1, 'TXN_VNPAY_001', 200000, 'VNPay', 'Success');

-- 5.9 Đánh giá (Feedback)
INSERT INTO Feedback (appt_id, rating, comment) VALUES 
(1, 5, N'Bác sĩ khám rất tận tình, bé mèo đã ăn lại được.');

-- 5.10 Chat AI (Demo)
INSERT INTO AIChatLog (user_id, question_raw, ai_response) VALUES 
(5, N'Mèo bị nôn ra bọt trắng là bị sao?', N'Có thể do đói quá hoặc rối loạn tiêu hóa. Nếu kèm bỏ ăn hãy đưa đi khám.');
GO
--=======================================================================================
--Select

SELECT user_id, username, role, full_name 
FROM Users 
WHERE username = 'admin' AND password = '123';