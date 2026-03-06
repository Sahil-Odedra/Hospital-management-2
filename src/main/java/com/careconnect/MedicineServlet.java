package com.careconnect;

import java.io.IOException;
import java.sql.Date;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.careconnect.Entities.Medicine;
import com.careconnect.Entities.User;

@WebServlet("/MedicineServlet")
public class MedicineServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"ADMIN".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        String action = request.getParameter("action");
        HospitalDAO dao = new HospitalDAO();

        try {
            if ("add".equals(action)) {
                String name = request.getParameter("name");
                String batchNo = request.getParameter("batchNo");
                Date expiryDate = Date.valueOf(request.getParameter("expiryDate"));
                int currentStock = Integer.parseInt(request.getParameter("currentStock"));
                double price = Double.parseDouble(request.getParameter("price"));
                int lowThreshold = Integer.parseInt(request.getParameter("lowStockThreshold"));
                String supplierEmail = request.getParameter("supplierEmail");

                Medicine m = new Medicine();
                m.setName(name);
                m.setBatchNo(batchNo);
                m.setExpiryDate(expiryDate);
                m.setCurrentStock(currentStock);
                m.setPricePerUnit(price);
                m.setLowStockThreshold(lowThreshold);
                m.setSupplierEmail(supplierEmail);

                if (dao.addMedicine(m)) {
                    session.setAttribute("message", "Medicine added successfully!");
                } else {
                    session.setAttribute("error", "Failed to add medicine.");
                }

            } else if ("updateStock".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));
                int quantity = Integer.parseInt(request.getParameter("quantity"));

                if (dao.updateMedicineStock(id, quantity)) {
                    session.setAttribute("message", "Stock updated successfully!");
                } else {
                    session.setAttribute("error", "Failed to update stock.");
                }

            } else if ("delete".equals(action)) {
                int id = Integer.parseInt(request.getParameter("id"));

                if (dao.deleteMedicine(id)) {
                    session.setAttribute("message", "Medicine deleted successfully!");
                } else {
                    session.setAttribute("error", "Failed to delete medicine.");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            session.setAttribute("error", "An error occurred: " + e.getMessage());
        }

        response.sendRedirect("admin/manage_medicines.jsp");
    }
}
