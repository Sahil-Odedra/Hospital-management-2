package com.careconnect;

import com.careconnect.Entities.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.sql.Date;
import java.sql.Timestamp;

@WebServlet(urlPatterns = { "/auth/login", "/auth/logout",
        "/admin/addDoctor", "/admin/addPatient", "/admin/assignAppointment", "/admin/deleteDoctor" })
public class HospitalServlet extends HttpServlet {

    private HospitalDAO hospitalDAO = new HospitalDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();

        if ("/auth/login".equals(action)) {
            handleLogin(req, resp);
        } else {
            HttpSession session = req.getSession(false);
            User currentUser = null;
            if (session != null) {
                currentUser = (User) session.getAttribute("user");
            }

            if (currentUser == null || !"ADMIN".equals(currentUser.getRole())) {
                resp.sendRedirect(req.getContextPath() + "/index.jsp");
                return;
            }

            if ("/admin/addDoctor".equals(action)) {
                handleAddDoctor(req, resp);
            } else if ("/admin/addPatient".equals(action)) {
                handleAddPatient(req, resp);
            } else if ("/admin/assignAppointment".equals(action)) {
                handleAssignAppointment(req, resp);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();

        if ("/auth/logout".equals(action)) {
            handleLogout(req, resp);
        } else if ("/admin/deleteDoctor".equals(action)) {
            handleDeleteDoctor(req, resp);
        } else {
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

            if (dob.after(new Date(System.currentTimeMillis()))) {
                resp.sendRedirect(
                        req.getContextPath() + "/admin/manage_patients.jsp?error=Birthdate cannot be in the future");
                return;
            }

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

            if (appointmentTime.before(new Timestamp(System.currentTimeMillis()))) {
                resp.sendRedirect(req.getContextPath()
                        + "/admin/assign_appointment.jsp?error=Appointment time cannot be in the past");
                return;
            }

            Appointment appt = new Appointment(doctorId, patientId, appointmentTime, notes);
            boolean success = hospitalDAO.scheduleAppointment(appt);

            if (success) {
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

    private void handleDeleteDoctor(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean success = hospitalDAO.deleteDoctor(id);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/admin/manage_doctors.jsp?success=Doctor Deleted");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/manage_doctors.jsp?error=Delete Failed");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_doctors.jsp?error=Invalid ID");
        }
    }
}
