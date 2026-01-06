package com.careconnect.servlet;

import com.careconnect.db.DatabaseInitializer;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;

@WebServlet("/setup")
public class SetupServlet extends HttpServlet {
    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        resp.setContentType("text/html");
        try {
            DatabaseInitializer.initialize();
            resp.getWriter().println("<h1>✅ Database Initialization Triggered manually.</h1>");
            resp.getWriter().println("<p>Check server logs for details.</p>");
            resp.getWriter().println("<p>Try logging in as <b>admin@hospital.com</b> / <b>admin123</b> now.</p>");
            resp.getWriter().println("<a href='index.jsp'>Go to Login</a>");
        } catch (Exception e) {
            resp.getWriter().println("<h1>❌ Error</h1>");
            resp.getWriter().println("<pre>" + e.getMessage() + "</pre>");
            e.printStackTrace();
        }
    }
}
