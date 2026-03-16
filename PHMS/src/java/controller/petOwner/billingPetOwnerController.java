/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/JSP_Servlet/Servlet.java to edit this template
 */

package controller.petOwner;

import dal.InvoiceDAO;
import dal.PaymentDAO;
import java.io.IOException;
import java.io.PrintWriter;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import model.Invoice;
import model.InvoiceDetail;
import model.Payment;
import model.User;

/**
 *
 * @author zoxy4
 */
@WebServlet(name="billingPetOwnerController", urlPatterns={"/billing"})
public class billingPetOwnerController extends HttpServlet {
 @Override
protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {

    HttpSession session = request.getSession();
    User account = (User) session.getAttribute("account");

    if (account == null || !"PetOwner".equalsIgnoreCase(account.getRole())) {
        response.sendRedirect(request.getContextPath() + "/views/auth/login.jsp");
        return;
    }

    int ownerId = account.getUserId();

    InvoiceDAO invoiceDAO = new InvoiceDAO();
    List<Invoice> invoiceList = invoiceDAO.getInvoicesByOwnerId(ownerId);

    // ===== SUMMARY CALCULATION =====
    int totalInvoices = invoiceList.size();
    int paidCount = 0;
    int unpaidCount = 0;
    double totalSpent = 0;

    for (Invoice inv : invoiceList) {
        if ("Paid".equalsIgnoreCase(inv.getStatus())) {
            paidCount++;
            totalSpent += inv.getTotalAmount();
        } else {
            unpaidCount++;
        }
    }

    request.setAttribute("invoiceList", invoiceList);
    request.setAttribute("totalInvoices", totalInvoices);
    request.setAttribute("paidCount", paidCount);
    request.setAttribute("unpaidCount", unpaidCount);
    request.setAttribute("totalSpent", totalSpent);

    request.getRequestDispatcher("/views/petOwner/billingPetOwner.jsp")
            .forward(request, response);
}

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
    throws ServletException, IOException {
        //processRequest(request, response);
    }
}
