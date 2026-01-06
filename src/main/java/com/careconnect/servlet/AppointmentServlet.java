package com.careconnect.servlet;

import com.careconnect.dao.AppointmentDAO;
import com.careconnect.dao.PatientDAO;
import com.careconnect.model.Appointment;
import com.careconnect.model.Patient;
import com.careconnect.model.User;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Timestamp;

@WebServlet("/admin/assignAppointment")
public class AppointmentServlet extends HttpServlet {

    private AppointmentDAO appointmentDAO = new AppointmentDAO();
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
            int patientId = Integer.parseInt(req.getParameter("patientId"));
            int doctorId = Integer.parseInt(req.getParameter("doctorId"));
            String dateStr = req.getParameter("appointmentDate");
            String timeStr = req.getParameter("appointmentTime");
            String notes = req.getParameter("adminNotes");

            // Combine Date and Time
            String dateTimeStr = dateStr + " " + timeStr;
            Timestamp appointmentTime = Timestamp.valueOf(dateTimeStr);

            Appointment appt = new Appointment(doctorId, patientId, appointmentTime, notes);

            boolean success = appointmentDAO.scheduleAppointment(appt);

            if (success) {
                // Mock Email Notification
                Patient p = patientDAO.getPatientById(patientId);
                if (p != null) {
                    System.out.println("--------------------------------------------------");
                    System.out.println("MOCK EMAIL SERVICE");
                    System.out.println("To: " + p.getEmail());
                    System.out.println("Subject: Appointment Details - CareConnect");
                    System.out.println(
                            "Dear " + p.getFullName() + ", your appointment is confirmed for " + appointmentTime);
                    System.out.println("--------------------------------------------------");
                }

                resp.sendRedirect(req.getContextPath()
                        + "/admin/assign_appointment.jsp?success=Appointment Scheduled & Email Sent");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/assign_appointment.jsp?error=Scheduling Failed");
            }

        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/assign_appointment.jsp?error=Error processing request");
        }
    }
}
