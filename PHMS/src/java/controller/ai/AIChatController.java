package controller.ai;

import dal.AIChatLogDAO;
import dal.AppointmentDAO;
import dal.FeedbackDAO;
import dal.HomeDAO;
import dal.InvoiceDAO;
import dal.LabTestDAO;
import dal.MedicalRecordDAO;
import dal.MedicineDAO;
import dal.PaymentDAO;
import dal.PetDAO;
import dal.PrescriptionDAO;
import dal.ScheduleVeterianrianDAO;
import dal.ServiceDAO;
import dal.TriageRecordDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.HashSet;
import java.util.List;
import java.util.Set;
import model.AIChatLog;
import model.Appointment;
import model.DoctorDTO;
import model.Feedback;
import model.Invoice;
import model.LabTest;
import model.MedicalRecord;
import model.Medicine;
import model.Payment;
import model.Pet;
import model.Prescription;
import model.Schedule;
import model.Service;
import model.TriageRecord;
import model.User;
import util.GeminiClient;

/**
 * PetOwner AI chat controller using Gemini.
 * SRP: Handle chat (ask + show history) for current user.
 */
@WebServlet(name = "AIChatController", urlPatterns = {"/aiHealthGuide"})
public class AIChatController extends HttpServlet {

    private static final int HISTORY_LIMIT = 20;

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        AIChatLogDAO dao = new AIChatLogDAO();
        List<AIChatLog> history = dao.listByUser(account.getUserId(), HISTORY_LIMIT);
        request.setAttribute("history", history);
        request.setAttribute("geminiConfigured", GeminiClient.isConfigured());
        request.getRequestDispatcher("/views/petOwner/aiHealthGuidePetOwner.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String question = util.ValidationUtils.sanitize(request.getParameter("question"));
        if (!util.ValidationUtils.isNotEmpty(question)
                || !util.ValidationUtils.isLengthValid(question, 1, 2000)) {
            request.setAttribute("error", "Câu hỏi phải có từ 1 đến 2000 ký tự.");
            doGet(request, response);
            return;
        }

        String answer;
        try {
            if (!GeminiClient.isConfigured()) {
                throw new IOException("Gemini API chưa được cấu hình. Vui lòng liên hệ quản trị hệ thống.");
            }

            // Phân tích câu hỏi để xác định loại dữ liệu cần lấy
            String lowerQuestion = question.toLowerCase();
            Set<String> dataTypes = analyzeQuestionTypes(lowerQuestion);

            // Lấy và định dạng dữ liệu từ database
            String context = buildAllContext(dataTypes, account.getUserId());

            // Hỏi Gemini với ngữ cảnh dữ liệu
            StringBuilder promptBuilder = new StringBuilder();
            if (!context.isEmpty()) {
                promptBuilder.append(context);
            }
            promptBuilder.append("Bạn là trợ lý thú y. Hãy trả lời ngắn gọn, dễ hiểu về chăm sóc thú cưng và sử dụng đúng dữ liệu từ hệ thống nếu có.\n\nCâu hỏi: ")
                    .append(question);

            String prompt = promptBuilder.toString();
            answer = GeminiClient.chat(prompt);
            if (answer == null || answer.trim().isEmpty()) {
                answer = "Xin lỗi, hiện tại không thể lấy được câu trả lời từ AI. Vui lòng thử lại sau.";
            }
        } catch (Exception e) {
            answer = "Có lỗi khi gọi AI: " + e.getMessage();
        }

        // Lưu log
        AIChatLogDAO dao = new AIChatLogDAO();
        dao.insertLog(account.getUserId(), question, answer);

        // Load lịch sử lại để hiển thị
        List<AIChatLog> history = dao.listByUser(account.getUserId(), HISTORY_LIMIT);
        request.setAttribute("history", history);
        request.setAttribute("question", question);
        request.setAttribute("answer", answer);
        request.setAttribute("geminiConfigured", GeminiClient.isConfigured());
        request.getRequestDispatcher("/views/petOwner/aiHealthGuidePetOwner.jsp").forward(request, response);
    }

    /**
     * Phân tích câu hỏi để xác định loại dữ liệu cần lấy từ database.
     */
    private Set<String> analyzeQuestionTypes(String lowerQuestion) {
        Set<String> types = new HashSet<>();
        if (lowerQuestion == null || lowerQuestion.isEmpty()) {
            return types;
        }

        // Thú cưng
        if (lowerQuestion.contains("thú cưng") || lowerQuestion.contains("thu cung")
                || lowerQuestion.contains("pet") || lowerQuestion.contains("chó") || lowerQuestion.contains("cho")
                || lowerQuestion.contains("mèo") || lowerQuestion.contains("meo")
                || lowerQuestion.contains("hamster") || lowerQuestion.contains("thỏ")
                || lowerQuestion.contains("vật nuôi") || lowerQuestion.contains("vat nuoi")
                || lowerQuestion.contains("con vật") || lowerQuestion.contains("con vat")) {
            types.add("PET");
        }

        // Lịch hẹn
        if (lowerQuestion.contains("lịch khám") || lowerQuestion.contains("lich kham")
                || lowerQuestion.contains("lịch hẹn") || lowerQuestion.contains("lich hen")
                || lowerQuestion.contains("appointment") || lowerQuestion.contains("đặt lịch")
                || lowerQuestion.contains("dat lich") || lowerQuestion.contains("đặt hẹn")
                || lowerQuestion.contains("dat hen") || lowerQuestion.contains("cuộc hẹn")
                || lowerQuestion.contains("cuoc hen") || lowerQuestion.contains("trạng thái lịch")
                || lowerQuestion.contains("trang thai lich") || lowerQuestion.contains("tuần này")
                || lowerQuestion.contains("tuan nay") || lowerQuestion.contains("hủy lịch")
                || lowerQuestion.contains("huy lich") || lowerQuestion.contains("tuần tới")
                || lowerQuestion.contains("tuan toi") || lowerQuestion.contains("tiêm phòng")
                || lowerQuestion.contains("tiem phong") || lowerQuestion.contains("khám")
                || lowerQuestion.contains("kham")) {
            types.add("APPOINTMENT");
        }

        // Hồ sơ y tế
        if (lowerQuestion.contains("hồ sơ") || lowerQuestion.contains("ho so")
                || lowerQuestion.contains("bệnh án") || lowerQuestion.contains("benh an")
                || lowerQuestion.contains("chẩn đoán") || lowerQuestion.contains("chan doan")
                || lowerQuestion.contains("medical record") || lowerQuestion.contains("điều trị")
                || lowerQuestion.contains("dieu tri") || lowerQuestion.contains("khám bệnh")
                || lowerQuestion.contains("kham benh") || lowerQuestion.contains("lịch sử khám")
                || lowerQuestion.contains("lich su kham")) {
            types.add("MEDICAL");
        }

        // Đơn thuốc
        if (lowerQuestion.contains("thuốc") || lowerQuestion.contains("thuoc")
                || lowerQuestion.contains("đơn thuốc") || lowerQuestion.contains("don thuoc")
                || lowerQuestion.contains("prescription") || lowerQuestion.contains("liều")
                || lowerQuestion.contains("lieu") || lowerQuestion.contains("kê đơn")
                || lowerQuestion.contains("ke don")) {
            types.add("PRESCRIPTION");
        }

        // Hóa đơn
        if (lowerQuestion.contains("hóa đơn") || lowerQuestion.contains("hoa don")
                || lowerQuestion.contains("invoice") || lowerQuestion.contains("thanh toán")
                || lowerQuestion.contains("thanh toan") || lowerQuestion.contains("tiền")
                || lowerQuestion.contains("tien") || lowerQuestion.contains("chi phí")
                || lowerQuestion.contains("chi phi") || lowerQuestion.contains("phí khám")
                || lowerQuestion.contains("phi kham")) {
            types.add("INVOICE");
        }

        // Xét nghiệm
        if (lowerQuestion.contains("xét nghiệm") || lowerQuestion.contains("xet nghiem")
                || lowerQuestion.contains("lab test") || lowerQuestion.contains("kết quả xét nghiệm")
                || lowerQuestion.contains("ket qua xet nghiem") || lowerQuestion.contains("lab")) {
            types.add("LABTEST");
        }

        // Dịch vụ
        if (lowerQuestion.contains("dịch vụ") || lowerQuestion.contains("dich vu")
                || lowerQuestion.contains("service") || lowerQuestion.contains("bảng giá")
                || lowerQuestion.contains("bang gia") || lowerQuestion.contains("giá dịch vụ")
                || lowerQuestion.contains("gia dich vu")) {
            types.add("SERVICE");
        }

        // Danh mục thuốc (catalog)
        if (lowerQuestion.contains("danh mục thuốc") || lowerQuestion.contains("danh muc thuoc")
                || lowerQuestion.contains("loại thuốc") || lowerQuestion.contains("loai thuoc")
                || lowerQuestion.contains("medicine") || lowerQuestion.contains("giá thuốc")
                || lowerQuestion.contains("gia thuoc")) {
            types.add("MEDICINE");
        }

        // Bác sĩ / Bác sĩ thú y
        if (lowerQuestion.contains("bác sĩ") || lowerQuestion.contains("bac si")
                || lowerQuestion.contains("doctor") || lowerQuestion.contains("vet")
                || lowerQuestion.contains("chuyên khoa") || lowerQuestion.contains("chuyen khoa")) {
            types.add("DOCTOR");
        }

        // Lịch làm việc bác sĩ
        if (lowerQuestion.contains("lịch làm việc") || lowerQuestion.contains("lich lam viec")
                || lowerQuestion.contains("schedule") || lowerQuestion.contains("ca làm")
                || lowerQuestion.contains("ca lam") || lowerQuestion.contains("lịch trực")
                || lowerQuestion.contains("lich truc") || lowerQuestion.contains("ngày nào")
                || lowerQuestion.contains("hôm nào") || lowerQuestion.contains("khi nào")
                || lowerQuestion.contains("thứ mấy") || lowerQuestion.contains("thu may")
                || lowerQuestion.contains("lịch") || lowerQuestion.contains("lich")
                || lowerQuestion.contains("đặt lịch") || lowerQuestion.contains("dat lich")
                || lowerQuestion.contains("tiêm phòng") || lowerQuestion.contains("tiem phong")
                || lowerQuestion.contains("tiêm") || lowerQuestion.contains("tiem")
                || lowerQuestion.contains("đến được") || lowerQuestion.contains("den duoc")
                || lowerQuestion.contains("có mở cửa") || lowerQuestion.contains("mo cua")
                || lowerQuestion.contains("giờ mở") || lowerQuestion.contains("gio mo")) {
            types.add("SCHEDULE");
        }

        // Thanh toán / Payment
        if (lowerQuestion.contains("thanh toán") || lowerQuestion.contains("thanh toan")
                || lowerQuestion.contains("payment") || lowerQuestion.contains("chuyển khoản")
                || lowerQuestion.contains("chuyen khoan") || lowerQuestion.contains("giao dịch")
                || lowerQuestion.contains("giao dich")) {
            types.add("PAYMENT");
        }

        // Phân loại cấp cứu / Triage
        if (lowerQuestion.contains("phân loại") || lowerQuestion.contains("phan loai")
                || lowerQuestion.contains("triage") || lowerQuestion.contains("cấp cứu")
                || lowerQuestion.contains("cap cuu") || lowerQuestion.contains("triệu chứng ban đầu")
                || lowerQuestion.contains("trieu chung ban dau") || lowerQuestion.contains("mức độ")
                || lowerQuestion.contains("muc do")) {
            types.add("TRIAGE");
        }

        // Đánh giá / Feedback
        if (lowerQuestion.contains("đánh giá") || lowerQuestion.contains("danh gia")
                || lowerQuestion.contains("feedback") || lowerQuestion.contains("review")
                || lowerQuestion.contains("nhận xét") || lowerQuestion.contains("nhan xet")) {
            types.add("FEEDBACK");
        }

        // Thông tin cá nhân
        if (lowerQuestion.contains("thông tin cá nhân") || lowerQuestion.contains("thong tin ca nhan")
                || lowerQuestion.contains("profile") || lowerQuestion.contains("tài khoản")
                || lowerQuestion.contains("tai khoan") || lowerQuestion.contains("hồ sơ cá nhân")
                || lowerQuestion.contains("ho so ca nhan")) {
            types.add("PROFILE");
        }

        return types;
    }

    /**
     * Lấy và định dạng tất cả dữ liệu liên quan từ database.
     */
    private String buildAllContext(Set<String> types, int ownerId) {
        if (types.isEmpty()) {
            return "";
        }

        StringBuilder ctx = new StringBuilder();
        ctx.append("DỮ LIỆU TỪ HỆ THỐNG PHMS (KHÔNG ĐƯỢC BỊA THÊM, CHỈ SỬ DỤNG DỮ LIỆU DƯỚI ĐÂY):\n\n");

        DateTimeFormatter dateFmt = DateTimeFormatter.ofPattern("dd/MM/yyyy");
        DateTimeFormatter timeFmt = DateTimeFormatter.ofPattern("HH:mm");

        // === THÚ CƯNG ===
        if (types.contains("PET")) {
            ctx.append("=== THÚ CƯNG CỦA NGƯỜI DÙNG ===\n");
            PetDAO petDao = new PetDAO();
            List<Pet> pets = petDao.getPetsByOwnerId(ownerId);
            if (pets.isEmpty()) {
                ctx.append("Người dùng chưa đăng ký thú cưng nào.\n");
            } else {
                for (Pet p : pets) {
                    ctx.append("- Tên: ").append(p.getName() != null ? p.getName() : "N/A");
                    ctx.append(", Loài: ").append(p.getSpecies() != null ? p.getSpecies() : "N/A");
                    ctx.append(", Giống: ").append(p.getBreed() != null ? p.getBreed() : "N/A");
                    ctx.append(", Cân nặng: ").append(p.getWeight()).append("kg");
                    ctx.append(", Giới tính: ").append(p.getGender() != null ? p.getGender() : "N/A");
                    if (p.getBirthDate() != null) {
                        ctx.append(", Ngày sinh: ").append(p.getBirthDate().toLocalDate().format(dateFmt));
                    }
                    if (p.getHistorySummary() != null && !p.getHistorySummary().isEmpty()) {
                        ctx.append(", Tiền sử: ").append(p.getHistorySummary());
                    }
                    ctx.append("\n");
                }
            }
            ctx.append("\n");
        }

        // === LỊCH HẸN ===
        if (types.contains("APPOINTMENT")) {
            ctx.append("=== TẤT CẢ LỊCH HẸN ===\n");
            AppointmentDAO apptDao = new AppointmentDAO();
            List<Appointment> appts = apptDao.getAppointmentsByOwnerId(ownerId);
            if (appts.isEmpty()) {
                ctx.append("Người dùng không có lịch hẹn nào.\n");
            } else {
                for (Appointment a : appts) {
                    if (a.getStartTime() != null) {
                        LocalDateTime ldt = a.getStartTime().toLocalDateTime();
                        ctx.append("- Ngày ").append(ldt.toLocalDate().format(dateFmt));
                        ctx.append(" lúc ").append(ldt.toLocalTime().format(timeFmt));
                    }
                    ctx.append(", Thú cưng: ").append(a.getPetName() != null ? a.getPetName() : "N/A");
                    ctx.append(", Bác sĩ: ").append(a.getVetName() != null ? a.getVetName() : "N/A");
                    ctx.append(", Loại: ").append(a.getType() != null ? a.getType() : "N/A");
                    ctx.append(", Trạng thái: ").append(a.getStatus() != null ? a.getStatus() : "N/A");
                    if (a.getNotes() != null && !a.getNotes().isEmpty()) {
                        ctx.append(", Ghi chú: ").append(a.getNotes());
                    }
                    ctx.append("\n");
                }
            }
            ctx.append("Nếu người dùng muốn đặt lịch khám mới, hãy hướng dẫn họ vào chức năng Đặt lịch khám trên hệ thống.\n\n");
        }

        // === HỒ SƠ Y TẾ ===
        if (types.contains("MEDICAL")) {
            ctx.append("=== HỒ SƠ Y TẾ ===\n");
            MedicalRecordDAO mrDao = new MedicalRecordDAO();
            List<MedicalRecord> records = mrDao.listForOwner(ownerId, null);
            if (records.isEmpty()) {
                ctx.append("Không có hồ sơ y tế nào.\n");
            } else {
                for (MedicalRecord mr : records) {
                    if (mr.getApptStartTime() != null) {
                        LocalDateTime ldt = mr.getApptStartTime().toLocalDateTime();
                        ctx.append("- Ngày khám: ").append(ldt.toLocalDate().format(dateFmt));
                    }
                    ctx.append(", Thú cưng: ").append(mr.getPetName() != null ? mr.getPetName() : "N/A");
                    ctx.append(", Bác sĩ: ").append(mr.getVetName() != null ? mr.getVetName() : "N/A");
                    ctx.append(", Chẩn đoán: ").append(mr.getDiagnosis() != null ? mr.getDiagnosis() : "N/A");
                    ctx.append(", Điều trị: ").append(mr.getTreatmentPlan() != null ? mr.getTreatmentPlan() : "N/A");
                    ctx.append("\n");
                }
            }
            ctx.append("\n");
        }

        // === ĐƠN THUỐC ===
        if (types.contains("PRESCRIPTION")) {
            ctx.append("=== ĐƠN THUỐC ===\n");
            MedicalRecordDAO mrDao = new MedicalRecordDAO();
            PrescriptionDAO presDao = new PrescriptionDAO();
            List<MedicalRecord> records = mrDao.listForOwner(ownerId, null);
            boolean hasPrescription = false;
            for (MedicalRecord mr : records) {
                List<Prescription> prescriptions = presDao.getByRecordIdForOwner(mr.getRecordId(), ownerId);
                if (!prescriptions.isEmpty()) {
                    hasPrescription = true;
                    ctx.append("Hồ sơ #").append(mr.getRecordId());
                    if (mr.getApptStartTime() != null) {
                        ctx.append(" (Ngày ").append(mr.getApptStartTime().toLocalDateTime().toLocalDate().format(dateFmt)).append(")");
                    }
                    ctx.append(", Thú cưng: ").append(mr.getPetName() != null ? mr.getPetName() : "N/A");
                    ctx.append(":\n");
                    for (Prescription p : prescriptions) {
                        ctx.append("  + Thuốc: ").append(p.getMedicineName() != null ? p.getMedicineName() : "N/A");
                        ctx.append(", SL: ").append(p.getQuantity());
                        if (p.getMedicineUnit() != null) {
                            ctx.append(" ").append(p.getMedicineUnit());
                        }
                        ctx.append(", Liều: ").append(p.getDosage() != null ? p.getDosage() : "N/A");
                        ctx.append("\n");
                    }
                }
            }
            if (!hasPrescription) {
                ctx.append("Không có đơn thuốc nào.\n");
            }
            ctx.append("\n");
        }

        // === HÓA ĐƠN ===
        if (types.contains("INVOICE")) {
            ctx.append("=== HÓA ĐƠN ===\n");
            AppointmentDAO apptDao = new AppointmentDAO();
            InvoiceDAO invDao = new InvoiceDAO();
            List<Appointment> appts = apptDao.getAppointmentsByOwnerId(ownerId);
            boolean hasInvoice = false;
            for (Appointment a : appts) {
                Invoice inv = invDao.getInvoiceByAppointment(a.getApptId());
                if (inv != null) {
                    hasInvoice = true;
                    ctx.append("- Cuộc hẹn ngày ");
                    if (a.getStartTime() != null) {
                        ctx.append(a.getStartTime().toLocalDateTime().toLocalDate().format(dateFmt));
                    }
                    ctx.append(", Thú cưng: ").append(a.getPetName() != null ? a.getPetName() : "N/A");
                    ctx.append(", Tổng tiền: ").append(String.format("%,.0f", inv.getTotalAmount())).append(" VNĐ");
                    ctx.append(", Trạng thái: ").append(inv.getStatus() != null ? inv.getStatus() : "N/A");
                    ctx.append("\n");
                }
            }
            if (!hasInvoice) {
                ctx.append("Không có hóa đơn nào.\n");
            }
            ctx.append("\n");
        }

        // === XÉT NGHIỆM ===
        if (types.contains("LABTEST")) {
            ctx.append("=== XÉT NGHIỆM ===\n");
            LabTestDAO ltDao = new LabTestDAO();
            List<LabTest> tests = ltDao.listForOwner(ownerId, null);
            if (tests.isEmpty()) {
                ctx.append("Không có xét nghiệm nào.\n");
            } else {
                for (LabTest lt : tests) {
                    ctx.append("- Loại: ").append(lt.getTestType() != null ? lt.getTestType() : "N/A");
                    ctx.append(", Thú cưng: ").append(lt.getPetName() != null ? lt.getPetName() : "N/A");
                    ctx.append(", Trạng thái: ").append(lt.getStatus() != null ? lt.getStatus() : "N/A");
                    if (lt.getResultData() != null && !lt.getResultData().isEmpty()) {
                        ctx.append(", Kết quả: ").append(lt.getResultData());
                    }
                    if (lt.getRequestNotes() != null && !lt.getRequestNotes().isEmpty()) {
                        ctx.append(", Ghi chú: ").append(lt.getRequestNotes());
                    }
                    ctx.append("\n");
                }
            }
            ctx.append("\n");
        }

        // === DỊCH VỤ ===
        if (types.contains("SERVICE")) {
            ctx.append("=== DANH SÁCH DỊCH VỤ PHÒNG KHÁM ===\n");
            ServiceDAO svcDao = new ServiceDAO();
            List<Service> services = svcDao.getAllActiveServices();
            if (services.isEmpty()) {
                ctx.append("Hiện chưa có dịch vụ nào.\n");
            } else {
                for (Service s : services) {
                    ctx.append("- ").append(s.getName() != null ? s.getName() : "N/A");
                    ctx.append(", Giá: ").append(String.format("%,.0f", s.getBasePrice())).append(" VNĐ");
                    if (s.getDescription() != null && !s.getDescription().isEmpty()) {
                        ctx.append(", Mô tả: ").append(s.getDescription());
                    }
                    ctx.append("\n");
                }
            }
            ctx.append("\n");
        }

        // === DANH MỤC THUỐC ===
        if (types.contains("MEDICINE")) {
            ctx.append("=== DANH MỤC THUỐC ===\n");
            MedicineDAO medDao = new MedicineDAO();
            List<Medicine> medicines = medDao.getAllMedicines();
            if (medicines.isEmpty()) {
                ctx.append("Hiện chưa có thuốc nào trong hệ thống.\n");
            } else {
                for (Medicine m : medicines) {
                    ctx.append("- ").append(m.getName() != null ? m.getName() : "N/A");
                    ctx.append(", Đơn vị: ").append(m.getUnit() != null ? m.getUnit() : "N/A");
                    ctx.append(", Giá: ").append(String.format("%,.0f", m.getPrice())).append(" VNĐ");
                    ctx.append(", Tồn kho: ").append(m.getStockQuantity());
                    ctx.append("\n");
                }
            }
            ctx.append("\n");
        }

        // === BÁC SĨ THÚ Y ===
        if (types.contains("DOCTOR")) {
            ctx.append("=== DANH SÁCH BÁC SĨ THÚ Y ===\n");
            HomeDAO homeDao = new HomeDAO();
            List<DoctorDTO> doctors = homeDao.getTopDoctors();
            UserDAO userDao = new UserDAO();
            List<User> allVets = userDao.getAllVeterinarians();
            if (allVets.isEmpty()) {
                ctx.append("Hiện chưa có bác sĩ nào.\n");
            } else {
                for (User v : allVets) {
                    ctx.append("- BS. ").append(v.getFullName() != null ? v.getFullName() : "N/A");
                    // Tìm chuyên khoa từ DoctorDTO
                    for (DoctorDTO d : doctors) {
                        if (d.getId() == v.getUserId() && d.getSpecialization() != null) {
                            ctx.append(", Chuyên khoa: ").append(d.getSpecialization());
                            break;
                        }
                    }
                    ctx.append("\n");
                }
            }
            ctx.append("\n");
        }

        // === LỊCH LÀM VIỆC BÁC SĨ ===
        if (types.contains("SCHEDULE")) {
            ctx.append("=== LỊCH LÀM VIỆC BÁC SĨ (SẮP TỚI) ===\n");
            ScheduleVeterianrianDAO schDao = new ScheduleVeterianrianDAO();
            List<Schedule> schedules = schDao.getAvailableSchedules();
            if (schedules.isEmpty()) {
                ctx.append("Hiện chưa có lịch làm việc nào sắp tới.\n");
            } else {
                for (Schedule sch : schedules) {
                    ctx.append("- BS. ").append(sch.getVetName() != null ? sch.getVetName() : "N/A");
                    if (sch.getWorkDate() != null) {
                        ctx.append(", Ngày: ").append(sch.getWorkDate().toLocalDate().format(dateFmt));
                    }
                    ctx.append(", Ca: ").append(sch.getShiftTime() != null ? sch.getShiftTime() : "N/A");
                    ctx.append("\n");
                }
            }
            ctx.append("\n");
        }

        // === THANH TOÁN ===
        if (types.contains("PAYMENT")) {
            ctx.append("=== LỊCH SỬ THANH TOÁN ===\n");
            AppointmentDAO apptDao2 = new AppointmentDAO();
            InvoiceDAO invDao2 = new InvoiceDAO();
            PaymentDAO payDao = new PaymentDAO();
            List<Appointment> appts2 = apptDao2.getAppointmentsByOwnerId(ownerId);
            boolean hasPayment = false;
            for (Appointment a : appts2) {
                Invoice inv = invDao2.getInvoiceByAppointment(a.getApptId());
                if (inv != null) {
                    List<Payment> payments = payDao.getPaymentsByInvoice(inv.getInvoiceId());
                    for (Payment pay : payments) {
                        hasPayment = true;
                        ctx.append("- Hóa đơn #").append(inv.getInvoiceId());
                        ctx.append(", Số tiền: ").append(String.format("%,.0f", pay.getAmount())).append(" VNĐ");
                        ctx.append(", Phương thức: ").append(pay.getMethod() != null ? pay.getMethod() : "N/A");
                        ctx.append(", Trạng thái: ").append(pay.getStatus() != null ? pay.getStatus() : "N/A");
                        if (pay.getTransCode() != null && !pay.getTransCode().isEmpty()) {
                            ctx.append(", Mã GD: ").append(pay.getTransCode());
                        }
                        ctx.append("\n");
                    }
                }
            }
            if (!hasPayment) {
                ctx.append("Không có giao dịch thanh toán nào.\n");
            }
            ctx.append("\n");
        }

        // === PHÂN LOẠI CẤP CỨU (TRIAGE) ===
        if (types.contains("TRIAGE")) {
            ctx.append("=== PHÂN LOẠI CẤP CỨU ===\n");
            AppointmentDAO apptDao3 = new AppointmentDAO();
            TriageRecordDAO triageDao = new TriageRecordDAO();
            List<Appointment> appts3 = apptDao3.getAppointmentsByOwnerId(ownerId);
            boolean hasTriage = false;
            for (Appointment a : appts3) {
                TriageRecord tr = triageDao.getByAppointment(a.getApptId());
                if (tr != null) {
                    hasTriage = true;
                    ctx.append("- Cuộc hẹn ngày ");
                    if (a.getStartTime() != null) {
                        ctx.append(a.getStartTime().toLocalDateTime().toLocalDate().format(dateFmt));
                    }
                    ctx.append(", Thú cưng: ").append(a.getPetName() != null ? a.getPetName() : "N/A");
                    ctx.append(", Mức độ: ").append(tr.getConditionLevel() != null ? tr.getConditionLevel() : "N/A");
                    if (tr.getInitialSymptoms() != null && !tr.getInitialSymptoms().isEmpty()) {
                        ctx.append(", Triệu chứng: ").append(tr.getInitialSymptoms());
                    }
                    ctx.append("\n");
                }
            }
            if (!hasTriage) {
                ctx.append("Không có bản ghi phân loại cấp cứu nào.\n");
            }
            ctx.append("\n");
        }

        // === ĐÁNH GIÁ / FEEDBACK ===
        if (types.contains("FEEDBACK")) {
            ctx.append("=== ĐÁNH GIÁ CỦA NGƯỜI DÙNG ===\n");
            FeedbackDAO fbDao = new FeedbackDAO();
            List<Feedback> feedbacks = fbDao.getFeedbacksByOwner(ownerId);
            if (feedbacks.isEmpty()) {
                ctx.append("Người dùng chưa có đánh giá nào.\n");
            } else {
                for (Feedback fb : feedbacks) {
                    ctx.append("- Đánh giá: ").append(fb.getRating()).append("/5");
                    if (fb.getComment() != null && !fb.getComment().isEmpty()) {
                        ctx.append(", Nhận xét: ").append(fb.getComment());
                    }
                    if (fb.getPetName() != null) {
                        ctx.append(", Thú cưng: ").append(fb.getPetName());
                    }
                    if (fb.getApptDate() != null) {
                        ctx.append(", Ngày hẹn: ").append(fb.getApptDate());
                    }
                    ctx.append("\n");
                }
            }
            ctx.append("\n");
        }

        // === THÔNG TIN CÁ NHÂN ===
        if (types.contains("PROFILE")) {
            ctx.append("=== THÔNG TIN CÁ NHÂN ===\n");
            UserDAO userDao2 = new UserDAO();
            User user = userDao2.getUserById(ownerId);
            if (user != null) {
                ctx.append("- Họ tên: ").append(user.getFullName() != null ? user.getFullName() : "N/A");
                ctx.append(", Email: ").append(user.getEmail() != null ? user.getEmail() : "N/A");
                ctx.append(", SĐT: ").append(user.getPhone() != null ? user.getPhone() : "N/A");
                ctx.append(", Địa chỉ: ").append(user.getAddress() != null ? user.getAddress() : "N/A");
                ctx.append("\n");
            }
            ctx.append("\n");
        }

        return ctx.toString();
    }
}