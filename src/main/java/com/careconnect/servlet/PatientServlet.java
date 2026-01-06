package com.careconnect.servlet;

import com.careconnect.dao.PatientDAO;
import com.careconnect.model.Patient;
import com.careconnect.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;

@WebServlet("/admin/addPatient")
public class PatientServlet extends HttpServlet {

    private PatientDAO patientDAO = new PatientDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        try {
            String fullName = req.getParameter("fullName");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String dobStr = req.getParameter("dob");
            Date dob = Date.valueOf(dobStr); // Format: yyyy-mm-dd

            Patient newPatient = new Patient(fullName, email, phone, dob);

            boolean success = patientDAO.addPatient(newPatient);

            if (success) {
                resp.sendRedirect(req.getContextPath() + "/admin/manage_patients.jsp?success=Patient Created");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/manage_patients.jsp?error=Creation Failed");
            }
        } catch (IllegalArgumentException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_patients.jsp?error=Invalid Date Format");
        }
    }
}
