package controller.ai;

import dal.AIChatLogDAO;
import dal.AppointmentDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.time.DayOfWeek;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.List;
import model.AIChatLog;
import model.Appointment;
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

            // Xây dựng ngữ cảnh từ database nếu người dùng hỏi về lịch khám/appointment
            String lowerQuestion = question.toLowerCase();
            StringBuilder contextBuilder = new StringBuilder();

            if (isAppointmentRelated(lowerQuestion)) {
                AppointmentDAO apptDao = new AppointmentDAO();
                List<Appointment> allAppts = apptDao.getAppointmentsByOwnerId(account.getUserId());

                // Tính khoảng thời gian trong tuần hiện tại (thứ 2 -> chủ nhật)
                LocalDate today = LocalDate.now();
                LocalDate startOfWeek = today.with(DayOfWeek.MONDAY);
                LocalDate endOfWeek = today.with(DayOfWeek.SUNDAY);

                DateTimeFormatter dateFormatter = DateTimeFormatter.ofPattern("dd/MM/yyyy");
                DateTimeFormatter timeFormatter = DateTimeFormatter.ofPattern("HH:mm");

                contextBuilder.append("THÔNG TIN LỊCH HẸN TỪ HỆ THỐNG PHMS (KHÔNG ĐƯỢC BỊA THÊM):\n");
                contextBuilder.append("Tuần hiện tại từ ")
                        .append(startOfWeek.format(dateFormatter))
                        .append(" đến ")
                        .append(endOfWeek.format(dateFormatter))
                        .append(".\n");

                boolean hasThisWeek = false;
                for (Appointment a : allAppts) {
                    if (a.getStartTime() == null) {
                        continue;
                    }
                    LocalDateTime ldt = a.getStartTime().toLocalDateTime();
                    LocalDate apptDate = ldt.toLocalDate();
                    if (!apptDate.isBefore(startOfWeek) && !apptDate.isAfter(endOfWeek)) {
                        hasThisWeek = true;
                        contextBuilder.append("- Ngày ")
                                .append(apptDate.format(dateFormatter))
                                .append(" lúc ")
                                .append(ldt.toLocalTime().format(timeFormatter))
                                .append(", thú cưng: ")
                                .append(a.getPetName() != null ? a.getPetName() : "Không rõ tên thú cưng")
                                .append(", bác sĩ: ")
                                .append(a.getVetName() != null ? a.getVetName() : "Không rõ bác sĩ")
                                .append(", trạng thái: ")
                                .append(a.getStatus() != null ? a.getStatus() : "Không rõ trạng thái")
                                .append(".\n");
                    }
                }

                if (!hasThisWeek) {
                    contextBuilder.append("Tuần này người dùng KHÔNG có cuộc hẹn nào trong hệ thống.\n");
                }

                contextBuilder.append("Nếu người dùng muốn đặt lịch khám mới, hãy hướng dẫn họ vào chức năng Đặt lịch khám trên hệ thống và chọn ngày giờ phù hợp. Không được tự bịa thêm cuộc hẹn không có trong danh sách trên.\n\n");
            }

            String context = contextBuilder.toString();

            // Hỏi Gemini với ngữ cảnh chăm sóc thú cưng + (tuỳ chọn) ngữ cảnh lịch hẹn
            StringBuilder promptBuilder = new StringBuilder();
            if (!context.isEmpty()) {
                promptBuilder.append(context);
            }
            promptBuilder.append("Bạn là trợ lý thú y. Hãy trả lời ngắn gọn, dễ hiểu về chăm sóc thú cưng và sử dụng đúng dữ liệu lịch hẹn nếu có.\n\nCâu hỏi: ")
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
     * Kiểm tra câu hỏi có liên quan đến lịch khám/appointment không (tiếng Việt + tiếng Anh cơ bản).
     */
    private boolean isAppointmentRelated(String lowerQuestion) {
        if (lowerQuestion == null || lowerQuestion.isEmpty()) {
            return false;
        }
        return lowerQuestion.contains("lịch khám")
                || lowerQuestion.contains("lich kham")
                || lowerQuestion.contains("lịch hẹn")
                || lowerQuestion.contains("lich hen")
                || lowerQuestion.contains("appointment")
                || lowerQuestion.contains("đặt lịch")
                || lowerQuestion.contains("dat lich")
                || lowerQuestion.contains("đặt hẹn")
                || lowerQuestion.contains("dat hen")
                || lowerQuestion.contains("trạng thái lịch")
                || lowerQuestion.contains("trang thai lich")
                || lowerQuestion.contains("trạng thái cuộc hẹn")
                || lowerQuestion.contains("trang thai cuoc hen")
                || lowerQuestion.contains("tuần này")
                || lowerQuestion.contains("tuan nay")
                || lowerQuestion.contains("hủy lịch")
                || lowerQuestion.contains("huy lich");
    }
}