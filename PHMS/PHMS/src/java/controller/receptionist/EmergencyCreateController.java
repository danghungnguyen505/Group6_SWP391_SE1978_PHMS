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
        
        // Lookup pet owner by email (if provided)
        String email = util.ValidationUtils.sanitize(request.getParameter("email"));
        if (util.ValidationUtils.isNotEmpty(email)) {
            String cleanedEmail = email.trim().toLowerCase(java.util.Locale.ENGLISH);
            request.setAttribute("email", cleanedEmail);
            if (!util.ValidationUtils.isValidEmail(cleanedEmail)) {
                request.setAttribute("error", "Email không hợp lệ.");
            } else {
                User owner = userDAO.getPetOwnerByEmail(cleanedEmail);
                request.setAttribute("owner", owner);
                if (owner != null) {
                    PetDAO petDAO = new PetDAO();
                    List<Pet> pets = petDAO.getPetsByOwnerId(owner.getUserId());
                    request.setAttribute("pets", pets);
                } else {
                    request.setAttribute("ownerNotFound", true);
                }
            }
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
        String email = util.ValidationUtils.sanitize(request.getParameter("email"));
        String ownerFullName = util.ValidationUtils.sanitize(request.getParameter("ownerFullName"));
        String petIdStr = request.getParameter("petId");
        String vetIdStr = request.getParameter("vetId");
        String conditionLevel = util.ValidationUtils.sanitize(request.getParameter("conditionLevel"));
        String initialSymptoms = util.ValidationUtils.sanitize(request.getParameter("initialSymptoms"));
        String notes = util.ValidationUtils.sanitize(request.getParameter("notes"));

        // New-pet info (when owner doesn't exist)
        String petNameNew = util.ValidationUtils.sanitize(request.getParameter("petNameNew"));
        String speciesNew = util.ValidationUtils.sanitize(request.getParameter("speciesNew"));
        String breedNew = util.ValidationUtils.sanitize(request.getParameter("breedNew"));
        String genderNew = util.ValidationUtils.sanitize(request.getParameter("genderNew"));
        String birthDateNewStr = util.ValidationUtils.sanitize(request.getParameter("birthDateNew"));
        String weightNewStr = util.ValidationUtils.sanitize(request.getParameter("weightNew"));
        String historyNew = util.ValidationUtils.sanitize(request.getParameter("historyNew"));

        // Validate owner: either existing ownerId + petId, or auto-create by email + new pet info
        Integer ownerId = null;
        Integer petId = null;

        if (util.ValidationUtils.isNotEmpty(ownerIdStr) && util.ValidationUtils.isIntegerInRange(ownerIdStr, 1, Integer.MAX_VALUE)) {
            ownerId = Integer.parseInt(ownerIdStr);
            if (!util.ValidationUtils.isNotEmpty(petIdStr) || !util.ValidationUtils.isIntegerInRange(petIdStr, 1, Integer.MAX_VALUE)) {
                request.setAttribute("error", "Vui lòng chọn thú cưng.");
                doGet(request, response);
                return;
            }
            petId = Integer.parseInt(petIdStr);
        } else {
            String cleanedEmail = email.trim().toLowerCase(java.util.Locale.ENGLISH);
            request.setAttribute("email", cleanedEmail);
            if (!util.ValidationUtils.isValidEmail(cleanedEmail)) {
                request.setAttribute("error", "Vui lòng nhập email hợp lệ.");
                doGet(request, response);
                return;
            }
            if (!util.ValidationUtils.isNotEmpty(ownerFullName) || !util.ValidationUtils.isLengthValid(ownerFullName, 2, 100)) {
                request.setAttribute("error", "Vui lòng nhập tên chủ thú cưng (2-100 ký tự).");
                doGet(request, response);
                return;
            }

            if (!util.ValidationUtils.isNotEmpty(petNameNew) || !util.ValidationUtils.isLengthValid(petNameNew, 1, 50)) {
                request.setAttribute("error", "Vui lòng nhập tên thú cưng (1-50 ký tự).");
                doGet(request, response);
                return;
            }
            if (!util.ValidationUtils.isNotEmpty(speciesNew) || !util.ValidationUtils.isLengthValid(speciesNew, 1, 50)) {
                request.setAttribute("error", "Vui lòng nhập species (1-50 ký tự).");
                doGet(request, response);
                return;
            }
            if (!util.ValidationUtils.isNotEmpty(breedNew) || !util.ValidationUtils.isLengthValid(breedNew, 1, 100)) {
                request.setAttribute("error", "Vui lòng nhập breed (1-100 ký tự).");
                doGet(request, response);
                return;
            }
            if (!("Male".equalsIgnoreCase(genderNew) || "Female".equalsIgnoreCase(genderNew))) {
                request.setAttribute("error", "Vui lòng chọn giới tính (Male/Female).");
                doGet(request, response);
                return;
            }
            if (!util.ValidationUtils.isNotEmpty(birthDateNewStr)) {
                request.setAttribute("error", "Vui lòng chọn ngày sinh.");
                doGet(request, response);
                return;
            }
            java.sql.Date birthDateNew;
            try {
                birthDateNew = java.sql.Date.valueOf(birthDateNewStr);
            } catch (IllegalArgumentException ex) {
                request.setAttribute("error", "Ngày sinh không hợp lệ.");
                doGet(request, response);
                return;
            }
            if (!util.ValidationUtils.isPositiveNumber(weightNewStr)) {
                request.setAttribute("error", "Vui lòng nhập cân nặng hợp lệ (>0).");
                doGet(request, response);
                return;
            }
            double weightNew = Double.parseDouble(weightNewStr);
            if (!util.ValidationUtils.isLengthValid(historyNew, 0, 2000)) {
                request.setAttribute("error", "Bệnh sử tối đa 2000 ký tự.");
                doGet(request, response);
                return;
            }

            UserDAO userDAO = new UserDAO();
            User existingOwner = userDAO.getPetOwnerByEmail(cleanedEmail);
            if (existingOwner != null) {
                request.setAttribute("error", "Email đã có tài khoản. Vui lòng chọn thú cưng từ danh sách.");
                response.sendRedirect(request.getContextPath() + "/receptionist/emergency/create?email=" + cleanedEmail);
                return;
            }

            String username = cleanedEmail;
            String password = cleanedEmail;
            int newOwnerId = userDAO.insertPetOwnerReturnId(username, password, ownerFullName, cleanedEmail, "", "");
            if (newOwnerId <= 0) {
                request.setAttribute("error", "Không thể tạo tài khoản chủ thú cưng tự động. Vui lòng thử lại.");
                doGet(request, response);
                return;
            }

            PetDAO petDAO = new PetDAO();
            int newPetId = petDAO.insertPetReturnId(newOwnerId, petNameNew, speciesNew, historyNew, breedNew, weightNew, birthDateNew, genderNew);
            if (newPetId <= 0) {
                request.setAttribute("error", "Đã tạo tài khoản nhưng không thể tạo hồ sơ thú cưng. Vui lòng thử lại.");
                doGet(request, response);
                return;
            }

            ownerId = newOwnerId;
            petId = newPetId;
            session.setAttribute("toastMessage", "success|Đã tạo tài khoản. Tên đăng nhập: " + username + " | Mật khẩu: " + password);
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
