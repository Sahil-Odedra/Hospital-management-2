package com.careconnect;

import java.io.IOException;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;
import com.careconnect.Entities.*;

@WebServlet("/PrescriptionServlet")
public class PrescriptionServlet extends HttpServlet {

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession();
        User user = (User) session.getAttribute("user");

        if (user == null || !"DOCTOR".equals(user.getRole())) {
            response.sendRedirect("index.jsp");
            return;
        }

        int appointmentId = Integer.parseInt(request.getParameter("appointmentId"));
        int doctorId = user.getId();
        int patientId = Integer.parseInt(request.getParameter("patientId"));
        String diagnosis = request.getParameter("diagnosis");

        String[] medicineIds = request.getParameterValues("medicineId");
        String[] dosagesMorning = request.getParameterValues("dosageMorning");
        String[] dosagesNoon = request.getParameterValues("dosageNoon");
        String[] dosagesEvening = request.getParameterValues("dosageEvening");
        String[] dosagesNight = request.getParameterValues("dosageNight");
        String[] durations = request.getParameterValues("duration");
        String[] quantities = request.getParameterValues("quantity");

        Connection conn = null;
        PreparedStatement psPrescription = null;
        PreparedStatement psDetails = null;
        PreparedStatement psUpdateStock = null;
        PreparedStatement psAppt = null;
        PreparedStatement psBilling = null;
        PreparedStatement psGetFee = null;

        try {
            conn = DBConnection.getConnection();
            conn.setAutoCommit(false); // Start Transaction

            String sqlPrescription = "INSERT INTO prescriptions (appointment_id, doctor_id, patient_id, diagnosis) VALUES (?, ?, ?, ?)";
            psPrescription = conn.prepareStatement(sqlPrescription, Statement.RETURN_GENERATED_KEYS);
            psPrescription.setInt(1, appointmentId);
            psPrescription.setInt(2, doctorId);
            psPrescription.setInt(3, patientId);
            psPrescription.setString(4, diagnosis);
            psPrescription.executeUpdate();

            ResultSet rs = psPrescription.getGeneratedKeys();
            int prescriptionId = 0;
            if (rs.next()) {
                prescriptionId = rs.getInt(1);
            } else {
                throw new SQLException("Failed to get prescription ID.");
            }

            // 2. Loop & Insert Items + Update Stock
            String sqlDetails = "INSERT INTO prescription_details (prescription_id, medicine_id, dosage_morning, dosage_noon, dosage_evening, dosage_night, duration, quantity) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
            psDetails = conn.prepareStatement(sqlDetails);

            String sqlUpdateStock = "UPDATE medicines SET current_stock = current_stock - ? WHERE id = ? AND current_stock >= ?";
            psUpdateStock = conn.prepareStatement(sqlUpdateStock);

            if (medicineIds != null) {
                for (int i = 0; i < medicineIds.length; i++) {
                    int medId = Integer.parseInt(medicineIds[i]);
                    if (medId > 0) {
                        int qty = Integer.parseInt(quantities[i]);

                        psDetails.setInt(1, prescriptionId);
                        psDetails.setInt(2, medId);
                        psDetails.setString(3, dosagesMorning[i]);
                        psDetails.setString(4, dosagesNoon[i]);
                        psDetails.setString(5, dosagesEvening[i]);
                        psDetails.setString(6, dosagesNight[i]);
                        psDetails.setString(7, durations[i]);
                        psDetails.setInt(8, qty);
                        psDetails.addBatch();

                        psUpdateStock.setInt(1, qty);
                        psUpdateStock.setInt(2, medId);
                        psUpdateStock.setInt(3, qty);
                        int rowsUpdated = psUpdateStock.executeUpdate();

                        if (rowsUpdated == 0) {
                            throw new SQLException("Insufficient stock for Medicine ID: " + medId);
                        }
                    }
                }
                psDetails.executeBatch();
            }

            // 3. Update appointment status to 'COMPLETED'
            String sqlUpdateAppt = "UPDATE appointments SET status = 'COMPLETED' WHERE id = ?";
            psAppt = conn.prepareStatement(sqlUpdateAppt);
            psAppt.setInt(1, appointmentId);
            psAppt.executeUpdate();

            conn.commit(); // Commit Transaction

            session.setAttribute("message", "Prescription submitted successfully!");
            response.sendRedirect("doctor/dashboard.jsp");

        } catch (Exception e) {
            e.printStackTrace();
            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException ex) {
                    ex.printStackTrace();
                }
            }
            session.setAttribute("error", "Error processing prescription: " + e.getMessage());
            response.sendRedirect("doctor/dashboard.jsp");
        } finally {
            try {
                if (psPrescription != null)
                    psPrescription.close();
            } catch (Exception e) {
            }
            try {
                if (psDetails != null)
                    psDetails.close();
            } catch (Exception e) {
            }
            try {
                if (psUpdateStock != null)
                    psUpdateStock.close();
            } catch (Exception e) {
            }
            try {
                if (psAppt != null)
                    psAppt.close();
            } catch (Exception e) {
            }
            try {
                if (psBilling != null)
                    psBilling.close();
            } catch (Exception e) {
            }
            try {
                if (psGetFee != null)
                    psGetFee.close();
            } catch (Exception e) {
            }
            try {
                if (conn != null)
                    conn.close();
            } catch (Exception e) {
            }
        }
    }
}
