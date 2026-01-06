package com.careconnect.servlet;

import com.careconnect.dao.HospitalDAO;
import com.careconnect.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;

// Map multiple URL patterns to the same servlet
@WebServlet(urlPatterns = { "/auth/login", "/auth/logout" })
public class AuthServlet extends HttpServlet {

    private HospitalDAO hospitalDAO = new HospitalDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();

        if ("/auth/login".equals(action)) {
            handleLogin(req, resp);
        } else {
            resp.sendError(HttpServletResponse.SC_METHOD_NOT_ALLOWED);
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();

        if ("/auth/logout".equals(action)) {
            handleLogout(req, resp);
        } else {
            // Default redirects to index
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
        }
    }

    private void handleLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = req.getParameter("email");
        String password = req.getParameter("password");

        User user = hospitalDAO.login(email, password);

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

    private void handleLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.invalidate();
        }
        resp.sendRedirect(req.getContextPath() + "/index.jsp");
    }
}
