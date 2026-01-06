package com.careconnect.servlet;

import com.careconnect.dao.HospitalDAO;
import com.careconnect.model.Appointment;
import com.careconnect.model.Patient;
import com.careconnect.model.User;
import com.careconnect.service.EmailService;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;

@WebServlet(urlPatterns = { "/admin/addDoctor", "/admin/addPatient", "/admin/assignAppointment" })
public class MainServlet extends HttpServlet {

    private HospitalDAO hospitalDAO = new HospitalDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        HttpSession session = req.getSession(false);
        User currentUser = (session != null) ? (User) session.getAttribute("user") : null;

        if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
            resp.sendRedirect(req.getContextPath() + "/index.jsp");
            return;
        }

        String action = req.getServletPath();

        if ("/admin/addDoctor".equals(action)) {
            handleAddDoctor(req, resp);
        } else if ("/admin/addPatient".equals(action)) {
            handleAddPatient(req, resp);
        } else if ("/admin/assignAppointment".equals(action)) {
            handleAssignAppointment(req, resp);
        }
    }

    private void handleAddDoctor(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String fullName = req.getParameter("fullName");
        String email = req.getParameter("email");
        String password = req.getParameter("password");
        String specialization = req.getParameter("specialization");

        User newDoctor = new User(email, password, "DOCTOR", fullName, specialization);

        boolean success = hospitalDAO.createDoctor(newDoctor);

        if (success) {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_doctors.jsp?success=Doctor Created");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_doctors.jsp?error=Creation Failed");
        }
    }

    private void handleAddPatient(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            String fullName = req.getParameter("fullName");
            String email = req.getParameter("email");
            String phone = req.getParameter("phone");
            String dobStr = req.getParameter("dob");
            Date dob = Date.valueOf(dobStr);

            Patient newPatient = new Patient(fullName, email, phone, dob);
            boolean success = hospitalDAO.addPatient(newPatient);

            if (success) {
                resp.sendRedirect(req.getContextPath() + "/admin/manage_patients.jsp?success=Patient Created");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/manage_patients.jsp?error=Creation Failed");
            }
        } catch (IllegalArgumentException e) {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_patients.jsp?error=Invalid Date Format");
        }
    }

    private void handleAssignAppointment(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int patientId = Integer.parseInt(req.getParameter("patientId"));
            int doctorId = Integer.parseInt(req.getParameter("doctorId"));
            String dateStr = req.getParameter("appointmentDate");
            String timeStr = req.getParameter("appointmentTime");
            String notes = req.getParameter("adminNotes");

            String dateTimeStr = dateStr + " " + timeStr;
            Timestamp appointmentTime = Timestamp.valueOf(dateTimeStr);

            Appointment appt = new Appointment(doctorId, patientId, appointmentTime, notes);

            boolean success = hospitalDAO.scheduleAppointment(appt);

            if (success) {
                // Email Notification
                Patient p = hospitalDAO.getPatientById(patientId);
                if (p != null) {
                    String subject = "Appointment Confirmation - CareConnect";
                    String body = "Dear " + p.getFullName() + ",\n\n" +
                            "Your appointment has been successfully scheduled.\n" +
                            "Time: " + appointmentTime + "\n" +
                            "Doctor: Dr. " + doctorId + "\n\n" +
                            "Please arrive 15 minutes early.\n\n" +
                            "Regards,\nCareConnect Team";

                    new Thread(() -> {
                        EmailService.sendEmail(p.getEmail(), subject, body);
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
