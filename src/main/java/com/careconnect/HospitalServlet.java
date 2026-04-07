package com.careconnect;

import com.careconnect.Entities.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import java.io.IOException;
import java.util.List;
import java.sql.Date;
import java.sql.Timestamp;

@WebServlet(urlPatterns = { "/auth/login", "/auth/logout",
        "/admin/addDoctor", "/admin/addPatient", "/admin/assignAppointment", "/admin/deleteDoctor",
        "/admin/deletePatient", "/admin/addBed", "/admin/addStaff", "/admin/admitPatient",
        "/admin/dischargePatient", "/admin/addBillingItem", "/admin/addReport", "/admin/addMedicine",
        "/admin/updateAppointmentStatus", "/admin/getBookedSlots", "/admin/deleteStaff",
        "/admin/deleteBed", "/admin/deleteBillingItem", "/patient/login", "/patient/logout",
        "/patient/bookAppointment" })
public class HospitalServlet extends HttpServlet {

    private HospitalDAO hospitalDAO = new HospitalDAO();

    @Override
    protected void doPost(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();

        if ("/auth/login".equals(action)) {
            handleLogin(req, resp);
        } else if ("/patient/login".equals(action)) {
            handlePatientLogin(req, resp);
        } else if ("/patient/bookAppointment".equals(action)) {
            handlePatientSelfBooking(req, resp);
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
            } else if ("/admin/addBed".equals(action)) {
                handleAddBed(req, resp);
            } else if ("/admin/addStaff".equals(action)) {
                handleAddStaff(req, resp);
            } else if ("/admin/admitPatient".equals(action)) {
                handleAdmitPatient(req, resp);
            } else if ("/admin/dischargePatient".equals(action)) {
                handleDischargePatient(req, resp);
            } else if ("/admin/addBillingItem".equals(action)) {
                handleAddBillingItem(req, resp);
            } else if ("/admin/addReport".equals(action)) {
                handleAddReport(req, resp);
            } else if ("/admin/addMedicine".equals(action)) {
                handleAddMedicine(req, resp);
            } else if ("/admin/updateAppointmentStatus".equals(action)) {
                handleUpdateAppointmentStatus(req, resp);
            }
        }
    }

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        String action = req.getServletPath();

        if ("/auth/logout".equals(action)) {
            handleLogout(req, resp);
        } else if ("/patient/logout".equals(action)) {
            handlePatientLogout(req, resp);
        } else if ("/admin/deleteDoctor".equals(action)) {
            handleDeleteDoctor(req, resp);
        } else if ("/admin/deletePatient".equals(action)) {
            handleDeletePatient(req, resp);
        } else if ("/admin/deleteStaff".equals(action)) {
            handleDeleteStaff(req, resp);
        } else if ("/admin/deleteBed".equals(action)) {
            handleDeleteBed(req, resp);
        } else if ("/admin/deleteBillingItem".equals(action)) {
            handleDeleteBillingItem(req, resp);
        } else if ("/admin/getBookedSlots".equals(action)) {
            handleGetBookedSlots(req, resp);
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

            String gender = req.getParameter("gender");
            String bloodGroup = req.getParameter("bloodGroup");

            double weight = 0.0;
            String weightStr = req.getParameter("weight");
            if (weightStr != null && !weightStr.isEmpty()) {
                weight = Double.parseDouble(weightStr);
            }

            double height = 0.0;
            String heightStr = req.getParameter("height");
            if (heightStr != null && !heightStr.isEmpty()) {
                height = Double.parseDouble(heightStr);
            }

            if (dob.after(new Date(System.currentTimeMillis()))) {
                resp.sendRedirect(
                        req.getContextPath() + "/admin/manage_patients.jsp?error=Birthdate cannot be in the future");
                return;
            }

            Patient newPatient = new Patient(fullName, email, phone, dob, gender, bloodGroup, weight, height);
            newPatient.setAddress(req.getParameter("address"));
            newPatient.setEmergencyContactName(req.getParameter("emergencyContactName"));
            newPatient.setEmergencyContactPhone(req.getParameter("emergencyContactPhone"));
            newPatient.setAllergies(req.getParameter("allergies"));

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

            if (timeStr != null && timeStr.length() == 5) {
                timeStr += ":00";
            }

            String dateTimeStr = dateStr + " " + timeStr;
            Timestamp appointmentTime = Timestamp.valueOf(dateTimeStr);

            List<String> bookedSlots = hospitalDAO.getBookedSlots(doctorId, dateStr);
            String requestedTime = timeStr;
            if (bookedSlots.contains(requestedTime)) {
                resp.sendRedirect(req.getContextPath()
                        + "/admin/assign_appointment.jsp?error=This time slot is already booked for this doctor.");
                return;
            }

            if (appointmentTime.before(new Timestamp(System.currentTimeMillis()))) {
                resp.sendRedirect(req.getContextPath()
                        + "/admin/assign_appointment.jsp?error=Appointment time cannot be in the past");
                return;
            }

            Appointment appt = new Appointment(doctorId, patientId, appointmentTime, notes);
            boolean success = hospitalDAO.scheduleAppointment(appt);

            if (success) {
                Billing bill = new Billing();
                bill.setPatientId(patientId);
                bill.setAppointmentId(appt.getId());
                bill.setTotalAmount(500.00);
                bill.setPaymentStatus("Pending");
                int billId = hospitalDAO.generateBill(bill);
                if (billId > 0) {
                    hospitalDAO.addBillingDetail(new BillingDetail(billId, "OPD Consultation Fee", 500.00));
                }

                Patient p = hospitalDAO.getPatientById(patientId);
                if (p != null) {
                    String subject = "Appointment Confirmation - CareConnect";
                    String body = "Dear " + p.getFullName() + ",\n\n" +
                            "Your appointment has been successfully scheduled.\n" +
                            "Time: " + appointmentTime + "\n" +
                            "Doctor ID: " + doctorId + "\n\n" +
                            "Please arrive 15 minutes early.\n\n" +
                            "Regards,\nCareConnect Team";

                    new Thread(() -> {
                        EmailService.sendEmail(p.getEmail(), subject, body);
                    }).start();
                }
                resp.sendRedirect(req.getContextPath()
                        + "/admin/assign_appointment.jsp?success=Appointment Scheduled & Email Sent. Bill #" + billId
                        + " generated.");
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

    private void handleDeletePatient(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean success = hospitalDAO.deletePatient(id);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/admin/manage_patients.jsp?success=Patient Deleted");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/manage_patients.jsp?error=Delete Failed");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_patients.jsp?error=Invalid ID");
        }
    }

    private void handleDeleteStaff(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean success = hospitalDAO.deleteStaff(id);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/admin/manage_staff.jsp?success=Staff Deleted");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/manage_staff.jsp?error=Delete Failed");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_staff.jsp?error=Invalid ID");
        }
    }

    private void handleDeleteBed(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean success = hospitalDAO.deleteBed(id);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/admin/manage_beds.jsp?success=Bed Deleted");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/manage_beds.jsp?error=Delete Failed");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_beds.jsp?error=Invalid ID");
        }
    }

    private void handleDeleteBillingItem(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int id = Integer.parseInt(req.getParameter("id"));
            boolean success = hospitalDAO.deleteBillingCatalogItem(id);
            if (success) {
                resp.sendRedirect(req.getContextPath() + "/admin/billing_catalog.jsp?success=Item Deleted");
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/billing_catalog.jsp?error=Delete Failed");
            }
        } catch (Exception e) {
            resp.sendRedirect(req.getContextPath() + "/admin/billing_catalog.jsp?error=Invalid ID");
        }
    }

    private void handleAddBed(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Bed b = new Bed();
        b.setBedNumber(req.getParameter("bedNumber"));
        b.setRoomNumber(req.getParameter("roomNumber"));
        b.setFloor(Integer.parseInt(req.getParameter("floor")));
        b.setType(req.getParameter("type"));
        b.setPricePerDay(Double.parseDouble(req.getParameter("pricePerDay")));

        if (hospitalDAO.addBed(b)) {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_beds.jsp?success=Bed Added");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_beds.jsp?error=Creation Failed");
        }
    }

    private void handleAddStaff(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Staff s = new Staff();
        s.setName(req.getParameter("name"));
        s.setRole(req.getParameter("role"));
        s.setPhone(req.getParameter("phone"));
        s.setAssignedToType(req.getParameter("assignedToType"));
        s.setAssignedToId(Integer.parseInt(req.getParameter("assignedToId")));

        if (hospitalDAO.addStaff(s)) {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_staff.jsp?success=Staff Created");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_staff.jsp?error=Creation Failed");
        }
    }

    private void handleAdmitPatient(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Admission a = new Admission();
        a.setPatientId(Integer.parseInt(req.getParameter("patientId")));
        a.setBedId(Integer.parseInt(req.getParameter("bedId")));
        a.setDoctorId(Integer.parseInt(req.getParameter("doctorId")));
        a.setInsuranceName(req.getParameter("insuranceName"));
        a.setDepositAmount(Double.parseDouble(req.getParameter("depositAmount")));

        if (hospitalDAO.admitPatient(a)) {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_admissions.jsp?success=Patient Admitted");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_admissions.jsp?error=Admission Failed");
        }
    }

    private void handleDischargePatient(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        try {
            int admissionId = Integer.parseInt(req.getParameter("id"));
            String summary = req.getParameter("summary");
            String[] selectedItems = req.getParameterValues("billingItems");

            Admission admission = hospitalDAO.getAdmissionById(admissionId);
            if (admission == null) {
                resp.sendRedirect(req.getContextPath() + "/admin/manage_admissions.jsp?error=Admission Not Found");
                return;
            }

            double total = 0;
            long diffInMillies = Math.abs(System.currentTimeMillis() - admission.getAdmissionDate().getTime());
            long days = (diffInMillies / (1000 * 60 * 60 * 24)) + 1;

            Bed bed = hospitalDAO.getAllBeds().stream().filter(b -> b.getId() == admission.getBedId()).findFirst()
                    .orElse(null);
            double bedCharges = days * (bed != null ? bed.getPricePerDay() : 0);
            total += bedCharges;

            Billing bill = new Billing();
            bill.setPatientId(admission.getPatientId());
            bill.setAdmissionId(admissionId);
            bill.setPaymentStatus("Pending");
            bill.setTotalAmount(total);

            int billId = hospitalDAO.generateBill(bill);
            if (billId > 0) {
                hospitalDAO.addBillingDetail(new BillingDetail(billId, "Bed Charges (" + days + " days)", bedCharges));

                if (selectedItems != null) {
                    for (String itemIdStr : selectedItems) {
                        int itemId = Integer.parseInt(itemIdStr);
                        BillingCatalog item = hospitalDAO.getBillingCatalogItemById(itemId);
                        if (item != null) {
                            String qtyStr = req.getParameter("qty_" + itemIdStr);
                            int qty = 1;
                            if (qtyStr != null && !qtyStr.isEmpty()) {
                                try {
                                    qty = Integer.parseInt(qtyStr);
                                    if (qty < 1) qty = 1;
                                } catch (NumberFormatException ignored) {}
                            }
                            
                            double itemTotal = item.getPrice() * qty;
                            String detailName = item.getItemName();
                            if (qty > 1) {
                                detailName += " (x" + qty + ")";
                            }
                            
                            hospitalDAO.addBillingDetail(new BillingDetail(billId, detailName, itemTotal));
                            total += itemTotal;
                        }
                    }
                }

                double deposit = admission.getDepositAmount();
                if (deposit > 0) {
                    hospitalDAO.addBillingDetail(new BillingDetail(billId, "Less: Admission Deposit", -deposit));
                    total -= deposit;
                    if (total < 0) {
                        total = 0;
                    }
                }

                String updateSql = "UPDATE billing SET total_amount = ? WHERE id = ?";
                try (java.sql.Connection conn = DBConnection.getConnection();
                        java.sql.PreparedStatement ps = conn.prepareStatement(updateSql)) {
                    ps.setDouble(1, total);
                    ps.setInt(2, billId);
                    ps.executeUpdate();
                }

                if (hospitalDAO.dischargePatient(admissionId, summary)) {
                    resp.sendRedirect(req.getContextPath() + "/admin/view_bill.jsp?id=" + billId);
                } else {
                    resp.sendRedirect(req.getContextPath() + "/admin/manage_admissions.jsp?error=Discharge Failed");
                }
            } else {
                resp.sendRedirect(req.getContextPath() + "/admin/manage_admissions.jsp?error=Billing Failed");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/admin/manage_admissions.jsp?error=Error processing discharge");
        }
    }

    private void handleAddBillingItem(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        BillingCatalog item = new BillingCatalog();
        item.setItemName(req.getParameter("itemName"));
        item.setCategory(req.getParameter("category"));
        item.setPrice(Double.parseDouble(req.getParameter("price")));

        if (hospitalDAO.addBillingItem(item)) {
            resp.sendRedirect(req.getContextPath() + "/admin/billing_catalog.jsp?success=Item Added");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/billing_catalog.jsp?error=Addition Failed");
        }
    }

    private void handleAddReport(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        PatientReport r = new PatientReport();
        r.setPatientId(Integer.parseInt(req.getParameter("patientId")));
        String admissionId = req.getParameter("admissionId");
        if (admissionId != null && !admissionId.isEmpty())
            r.setAdmissionId(Integer.parseInt(admissionId));
        String appointmentId = req.getParameter("appointmentId");
        if (appointmentId != null && !appointmentId.isEmpty())
            r.setAppointmentId(Integer.parseInt(appointmentId));
        r.setTestId(Integer.parseInt(req.getParameter("testId")));
        r.setFindings(req.getParameter("findings"));

        if (hospitalDAO.addPatientReport(r)) {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_patients.jsp?success=Report Added");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_patients.jsp?error=Report Failed");
        }
    }

    private void handleAddMedicine(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        Medicine m = new Medicine();
        m.setName(req.getParameter("name"));
        m.setBatchNo(req.getParameter("batchNo"));
        m.setExpiryDate(Date.valueOf(req.getParameter("expiryDate")));
        m.setCurrentStock(Integer.parseInt(req.getParameter("currentStock")));
        m.setPricePerUnit(Double.parseDouble(req.getParameter("pricePerUnit")));
        m.setLowStockThreshold(Integer.parseInt(req.getParameter("lowStockThreshold")));
        m.setSupplierEmail(req.getParameter("supplierEmail"));

        if (hospitalDAO.addMedicine(m)) {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_medicines.jsp?success=Medicine Added");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_medicines.jsp?error=Addition Failed");
        }
    }

    private void handleGetBookedSlots(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String doctorIdStr = req.getParameter("doctorId");
        String date = req.getParameter("date");

        if (doctorIdStr != null && date != null) {
            int doctorId = Integer.parseInt(doctorIdStr);
            List<String> bookedSlots = hospitalDAO.getBookedSlots(doctorId, date);
            resp.setContentType("text/plain");
            resp.getWriter().write(String.join(",", bookedSlots));
        }
    }

    private void handleUpdateAppointmentStatus(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        int id = Integer.parseInt(req.getParameter("id"));
        String status = req.getParameter("status");

        if (hospitalDAO.updateAppointmentStatus(id, status)) {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_appointments.jsp?success=Status Updated");
        } else {
            resp.sendRedirect(req.getContextPath() + "/admin/manage_appointments.jsp?error=Update Failed");
        }
    }

    private void handlePatientLogin(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        String email = req.getParameter("email");
        String dobStr = req.getParameter("dob");
        if (email == null || dobStr == null || email.trim().isEmpty() || dobStr.trim().isEmpty()) {
            resp.sendRedirect(req.getContextPath() + "/patient.jsp?error=Email and Date of Birth are required");
            return;
        }

        try {
            Date dob = Date.valueOf(dobStr);
            Patient patient = hospitalDAO.patientLogin(email, dob);

            if (patient != null) {
                HttpSession session = req.getSession();
                session.setAttribute("patientUser", patient);
                resp.sendRedirect(req.getContextPath() + "/patient.jsp");
            } else {
                resp.sendRedirect(req.getContextPath() + "/patient.jsp?error=Invalid Email or Date of Birth");
            }
        } catch (IllegalArgumentException e) {
            resp.sendRedirect(req.getContextPath() + "/patient.jsp?error=Invalid Date Format");
        }
    }

    private void handlePatientLogout(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        if (session != null) {
            session.removeAttribute("patientUser");
        }
        resp.sendRedirect(req.getContextPath() + "/patient.jsp");
    }

    private void handlePatientSelfBooking(HttpServletRequest req, HttpServletResponse resp) throws IOException {
        HttpSession session = req.getSession(false);
        Patient patientUser = (session != null) ? (Patient) session.getAttribute("patientUser") : null;
        if (patientUser == null) {
            resp.sendRedirect(req.getContextPath() + "/patient.jsp?error=Unauthorized");
            return;
        }

        try {
            int patientId = patientUser.getId();
            int doctorId = Integer.parseInt(req.getParameter("doctorId"));
            String dateStr = req.getParameter("appointmentDate");
            String timeStr = req.getParameter("appointmentTime");

            if (timeStr != null && timeStr.length() == 5) {
                timeStr += ":00";
            }

            String dateTimeStr = dateStr + " " + timeStr;
            Timestamp appointmentTime = Timestamp.valueOf(dateTimeStr);

            List<String> bookedSlots = hospitalDAO.getBookedSlots(doctorId, dateStr);
            String requestedTime = timeStr;
            if (bookedSlots.contains(requestedTime)) {
                resp.sendRedirect(req.getContextPath() + "/patient.jsp?error=This time slot is already booked.");
                return;
            }

            if (appointmentTime.before(new Timestamp(System.currentTimeMillis()))) {
                resp.sendRedirect(req.getContextPath() + "/patient.jsp?error=Appointment time cannot be in the past");
                return;
            }

            Appointment appt = new Appointment(doctorId, patientId, appointmentTime, "Patient self-booked via portal");
            boolean success = hospitalDAO.scheduleAppointment(appt);

            if (success) {
                resp.sendRedirect(req.getContextPath() + "/patient.jsp?success=Appointment successfully scheduled.");
            } else {
                resp.sendRedirect(req.getContextPath() + "/patient.jsp?error=Scheduling failed. Please try again.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            resp.sendRedirect(req.getContextPath() + "/patient.jsp?error=Error processing booking");
        }
    }
}