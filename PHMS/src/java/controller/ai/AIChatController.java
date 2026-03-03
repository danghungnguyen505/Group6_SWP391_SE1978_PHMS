<<<<<<< Updated upstream
package controller.ai;

import dal.AIChatLogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.AIChatLog;
import model.User;
import util.GeminiClient;

/**
 * PetOwner AI chat controller using Gemini.
 * SRP: Handle chat (ask + show history) for current user.
 */
@WebServlet(name = "AIChatController", urlPatterns = {"/ai/chat"})
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
        request.getRequestDispatcher("/views/petOwner/aiChat.jsp").forward(request, response);
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
                || !util.ValidationUtils.isLengthValid(question, 5, 2000)) {
            request.setAttribute("error", "Câu hỏi phải có từ 5 đến 2000 ký tự.");
            doGet(request, response);
            return;
        }

        String answer;
        try {
            if (!GeminiClient.isConfigured()) {
                throw new IOException("Gemini API chưa được cấu hình. Vui lòng liên hệ quản trị hệ thống.");
            }
            // Hỏi Gemini với ngữ cảnh chăm sóc thú cưng
            String prompt = "Bạn là trợ lý thú y. Hãy trả lời ngắn gọn, dễ hiểu về chăm sóc thú cưng.\n\nCâu hỏi: "
                    + question;
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
        request.getRequestDispatcher("/views/petOwner/aiChat.jsp").forward(request, response);
    }
}

=======
package controller.ai;

import dal.AIChatLogDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import model.AIChatLog;
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
            // Hỏi Gemini với ngữ cảnh chăm sóc thú cưng
            String prompt = "Bạn là trợ lý thú y. Hãy trả lời ngắn gọn, dễ hiểu về chăm sóc thú cưng.\n\nCâu hỏi: "
                    + question;
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
}

>>>>>>> Stashed changes
