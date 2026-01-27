/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */
package controller;

import service.MedicineService;
import serviceimpl.MedicineServiceImpl;
import model.Medicine;

import jakarta.servlet.*;
import jakarta.servlet.http.*;
import jakarta.servlet.annotation.WebServlet;
import java.io.IOException;


public class MedicineController extends HttpServlet {

    private MedicineService service = new MedicineServiceImpl();

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if (action == null) {
            req.setAttribute("medicines", service.getAllMedicines());
            req.getRequestDispatcher("list.jsp").forward(req, resp);

        } else if ("add".equals(action)) {
            req.getRequestDispatcher("add.jsp").forward(req, resp);

        } else if ("edit".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                req.setAttribute("medicine", service.getMedicineById(id));
                req.getRequestDispatcher("edit.jsp").forward(req, resp);
            } catch (NumberFormatException e) {
                resp.sendRedirect("medicine");
            }

        } else if ("delete".equals(action)) {
            try {
                int id = Integer.parseInt(req.getParameter("id"));
                service.deleteMedicine(id);
            } catch (NumberFormatException ignored) {}
            resp.sendRedirect("medicine");
        }
    }

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp)
            throws ServletException, IOException {

        String action = req.getParameter("action");

        if ("insert".equals(action)) {
            Medicine m = new Medicine();
            m.setName(req.getParameter("name"));
            m.setUnit(req.getParameter("unit"));
            m.setPrice(Double.parseDouble(req.getParameter("price")));
            m.setStockQuantity(Integer.parseInt(req.getParameter("stockQuantity")));
            service.addMedicine(m);

        } else if ("update".equals(action)) {
            Medicine m = new Medicine();
            m.setMedicineId(Integer.parseInt(req.getParameter("medicineId")));
            m.setName(req.getParameter("name"));
            m.setUnit(req.getParameter("unit"));
            m.setPrice(Double.parseDouble(req.getParameter("price")));
            m.setStockQuantity(Integer.parseInt(req.getParameter("stockQuantity")));
            service.updateMedicine(m);
        }

        resp.sendRedirect("medicine");
    }
}
