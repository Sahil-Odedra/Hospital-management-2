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
                // Real Email Notification
                Patient p = patientDAO.getPatientById(patientId);
                if (p != null) {
                    String subject = "Appointment Confirmation - CareConnect";
                    String body = "Dear " + p.getFullName() + ",\n\n" +
                            "Your appointment has been successfully scheduled.\n" +
                            "Time: " + appointmentTime + "\n" +
                            "Doctor: Dr. " + doctorId + "\n\n" +
                            "Please arrive 15 minutes early.\n\n" +
                            "Regards,\nCareConnect Team";

                    // Run in a separate thread to not block the UI response
                    new Thread(() -> {
                        com.careconnect.service.EmailService.sendEmail(p.getEmail(), subject, body);
                    }).start();
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
