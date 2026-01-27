/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import dao.MedicalRecordDAO;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import model.MedicalRecord;

@WebServlet("/examination")
public class ExaminationServlet extends HttpServlet {

    private MedicalRecordDAO dao = new MedicalRecordDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String apptId = request.getParameter("apptId");

        if (apptId == null || apptId.isBlank()) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing appointment ID");
            return;
        }

        request.setAttribute("apptId", apptId);
        request.getRequestDispatcher("examination.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String apptIdRaw = request.getParameter("apptId");
        String diagnosis = request.getParameter("diagnosis");
        String treatmentPlan = request.getParameter("treatmentPlan");

        if (apptIdRaw == null || apptIdRaw.isBlank()) {
            request.setAttribute("error", "Invalid appointment ID");
            request.getRequestDispatcher("examination.jsp").forward(request, response);
            return;
        }

        if (diagnosis == null || diagnosis.trim().isEmpty()) {
            request.setAttribute("error", "Diagnosis is required!");
            request.setAttribute("apptId", apptIdRaw);
            request.getRequestDispatcher("examination.jsp").forward(request, response);
            return;
        }

        int apptId = Integer.parseInt(apptIdRaw);

        MedicalRecord record = new MedicalRecord(apptId, diagnosis, treatmentPlan);
        dao.insert(record);

        response.sendRedirect(
                request.getContextPath() + "/examination?apptId=" + apptId
        );

    }
}
