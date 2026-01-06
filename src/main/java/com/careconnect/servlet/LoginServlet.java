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

@WebServlet("/auth/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        System.out.println("----- LOGIN ATTEMPT -----");
        System.out.println("Email provided: " + email);
        System.out.println("Password provided: " + password);

        User user = userDAO.login(email, password);
        System.out.println("User found: " + (user != null ? user.getEmail() : "NULL"));

        if (user != null) {
            HttpSession session = req.getSession();
            session.setAttribute("user", user);

            // Redirect based on Role
            if ("ADMIN".equals(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/admin/dashboard.jsp");
            } else if ("DOCTOR".equals(user.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/doctor/dashboard.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/index.jsp?error=Invalid Role");
            }
        } else {
            resp.sendRedirect(req.getContextPath() + "/index.jsp?error=Invalid Credentials");
        }
    }
}
