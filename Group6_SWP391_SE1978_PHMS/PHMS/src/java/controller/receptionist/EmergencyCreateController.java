package controller.receptionist;

import dal.AppointmentDAO;
import dal.PetDAO;
import dal.TriageRecordDAO;
import dal.UserDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;
import java.util.List;
import model.Appointment;
import model.Pet;
import model.User;

/**
 * Receptionist creates emergency appointment when pet owner brings pet to clinic.
 * SRP: Create emergency appointment with triage only.
 */
@WebServlet(name = "EmergencyCreateController", urlPatterns = {"/receptionist/emergency/create"})
public class EmergencyCreateController extends HttpServlet {
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        // Get all veterinarians for selection
        UserDAO userDAO = new UserDAO();
        List<User> veterinarians = userDAO.getAllVeterinarians();
        request.setAttribute("veterinarians", veterinarians);
        
        // Get owner ID from parameter (if provided)
        String ownerIdStr = request.getParameter("ownerId");
        if (util.ValidationUtils.isNotEmpty(ownerIdStr) && util.ValidationUtils.isIntegerInRange(ownerIdStr, 1, Integer.MAX_VALUE)) {
            int ownerId = Integer.parseInt(ownerIdStr);
            PetDAO petDAO = new PetDAO();
            List<Pet> pets = petDAO.getPetsByOwnerId(ownerId);
            request.setAttribute("pets", pets);
            request.setAttribute("ownerId", ownerId);
        }
        
        request.getRequestDispatcher("/views/receptionist/emergencyCreate.jsp").forward(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Receptionist".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }
        
        String ownerIdStr = request.getParameter("ownerId");
        String petIdStr = request.getParameter("petId");
        String vetIdStr = request.getParameter("vetId");
        String conditionLevel = util.ValidationUtils.sanitize(request.getParameter("conditionLevel"));
        String initialSymptoms = util.ValidationUtils.sanitize(request.getParameter("initialSymptoms"));
        String notes = util.ValidationUtils.sanitize(request.getParameter("notes"));
        
        // Validation
        if (!util.ValidationUtils.isNotEmpty(ownerIdStr) || !util.ValidationUtils.isIntegerInRange(ownerIdStr, 1, Integer.MAX_VALUE)) {
            request.setAttribute("error", "Vui lòng nhập ID chủ thú cưng hợp lệ.");
            doGet(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(petIdStr) || !util.ValidationUtils.isIntegerInRange(petIdStr, 1, Integer.MAX_VALUE)) {
            request.setAttribute("error", "Vui lòng chọn thú cưng.");
            doGet(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(vetIdStr) || !util.ValidationUtils.isIntegerInRange(vetIdStr, 1, Integer.MAX_VALUE)) {
            request.setAttribute("error", "Vui lòng chọn bác sĩ cấp cứu.");
            doGet(request, response);
            return;
        }
        
        // Validate condition level (4 levels: Critical, High, Medium, Low)
        if (!util.ValidationUtils.isNotEmpty(conditionLevel) || 
            !("Critical".equalsIgnoreCase(conditionLevel) || 
              "High".equalsIgnoreCase(conditionLevel) || 
              "Medium".equalsIgnoreCase(conditionLevel) || 
              "Low".equalsIgnoreCase(conditionLevel))) {
            request.setAttribute("error", "Vui lòng chọn mức độ ưu tiên (Critical/High/Medium/Low).");
            doGet(request, response);
            return;
        }
        
        if (!util.ValidationUtils.isNotEmpty(initialSymptoms) || !util.ValidationUtils.isLengthValid(initialSymptoms, 5, 2000)) {
            request.setAttribute("error", "Triệu chứng ban đầu phải có từ 5 đến 2000 ký tự.");
            doGet(request, response);
            return;
        }
        
        int ownerId = Integer.parseInt(ownerIdStr);
        int petId = Integer.parseInt(petIdStr);
        int vetId = Integer.parseInt(vetIdStr);
        
        // Verify pet belongs to owner
        PetDAO petDAO = new PetDAO();
        Pet pet = petDAO.getPetById(petId);
        if (pet == null || pet.getOwnerId() != ownerId) {
            request.setAttribute("error", "Thú cưng không hợp lệ hoặc không thuộc về chủ này.");
            doGet(request, response);
            return;
        }
        
        // Create emergency appointment immediately (no waiting)
        Appointment appt = new Appointment();
        appt.setPetId(petId);
        appt.setVetId(vetId);
        appt.setStartTime(new Timestamp(System.currentTimeMillis()));
        appt.setType("Urgent");
        appt.setStatus("Checked-in"); // Immediately checked-in for emergency
        appt.setNotes(notes);
        
        AppointmentDAO apptDAO = new AppointmentDAO();
        int apptId = apptDAO.insertAppointmentReturnId(appt);
        
        if (apptId > 0) {
            // Create triage record immediately
            TriageRecordDAO triageDAO = new TriageRecordDAO();
            boolean triageOk = triageDAO.upsertForAppointment(apptId, account.getUserId(), conditionLevel, initialSymptoms);
            
            if (triageOk) {
                session.setAttribute("toastMessage", "success|Đã tạo cuộc hẹn cấp cứu và phân loại thành công!");
                response.sendRedirect(request.getContextPath() + "/receptionist/emergency/queue");
            } else {
                // Appointment created but triage failed - still redirect but with warning
                session.setAttribute("toastMessage", "warning|Đã tạo cuộc hẹn cấp cứu nhưng không thể lưu thông tin triage.");
                response.sendRedirect(request.getContextPath() + "/receptionist/emergency/queue");
            }
        } else {
            request.setAttribute("error", "Không thể tạo cuộc hẹn cấp cứu. Vui lòng thử lại.");
            doGet(request, response);
        }
    }
}
