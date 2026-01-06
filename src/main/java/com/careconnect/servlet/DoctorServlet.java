package com.careconnect.servlet;

import com.careconnect.dao.UserDAO;
import com.careconnect.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

@WebServlet("/admin/addDoctor")
public class DoctorServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String specialization = req.getParameter("specialization");

        User newDoctor = new User(email, password, "DOCTOR", fullName, specialization);

        boolean success = userDAO.createDoctor(newDoctor);

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_doctors.jsp?success=Doctor Created");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_doctors.jsp?error=Creation Failed");
        }
    }
}
