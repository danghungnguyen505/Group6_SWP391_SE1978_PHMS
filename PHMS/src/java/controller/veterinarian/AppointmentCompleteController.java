/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.veterinarian;

import dal.AppointmentDAO;
import dal.LabTestDAO;
import dal.MedicalRecordDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.io.IOException;
import model.MedicalRecord;
import model.User;
/**
 *
 * @author zoxy4
 * Veterinarian completes an appointment after finishing all actions.
 */
@WebServlet(name="AppointmentCompleteController", urlPatterns={"/veterinarian/appointment/complete"})
public class AppointmentCompleteController extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        doPost(request, response);
    } 

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User account = (User) session.getAttribute("account");
        if (account == null || !"Veterinarian".equalsIgnoreCase(account.getRole())) {
            response.sendRedirect(request.getContextPath() + "/login");
            return;
        }

        String recordIdStr = request.getParameter("recordId");
        if (!util.ValidationUtils.isNotEmpty(recordIdStr)
                || !util.ValidationUtils.isIntegerInRange(recordIdStr, 1, Integer.MAX_VALUE)) {
            session.setAttribute("toastMessage", "error|Invalid medical record ID.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }

        int recordId = Integer.parseInt(recordIdStr);
        MedicalRecordDAO mrDAO = new MedicalRecordDAO();
        MedicalRecord record = mrDAO.getByIdForVet(recordId, account.getUserId());
        if (record == null) {
            session.setAttribute("toastMessage", "error|Record not found or access denied.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/records");
            return;
        }
        if (!"In-Progress".equalsIgnoreCase(record.getApptStatus())) {
            session.setAttribute("toastMessage", "error|Appointment is not In-Progress, cannot complete.");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/detail?id=" + recordId);
            return;
        }

        LabTestDAO labTestDAO = new LabTestDAO();
        boolean hasPendingLab = labTestDAO.hasPendingByRecordForVet(recordId, account.getUserId());
        if (hasPendingLab) {
            session.setAttribute("toastMessage", "error|Cannot complete yet. Waiting for Lab Test result (Requested/In Progress).");
            response.sendRedirect(request.getContextPath() + "/veterinarian/emr/detail?id=" + recordId);
            return;
        }

        AppointmentDAO apptDAO = new AppointmentDAO();
        boolean ok = apptDAO.completeForVet(record.getApptId(), account.getUserId());
        if (ok) {
            session.setAttribute("toastMessage", "success|Appointment marked as Completed.");
        } else {
            session.setAttribute("toastMessage", "error|Cannot complete appointment.");
        }
        response.sendRedirect(request.getContextPath() + "/veterinarian/emr/detail?id=" + recordId);
    }

}
