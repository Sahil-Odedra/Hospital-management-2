package com.careconnect.dao;

import com.careconnect.db.DBConnection;
import com.careconnect.model.Appointment;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class AppointmentDAO {

    public boolean scheduleAppointment(Appointment appt) {
        String sql = "INSERT INTO appointments (doctor_id, patient_id, appointment_time, admin_notes, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appt.getDoctorId());
            ps.setInt(2, appt.getPatientId());
            ps.setTimestamp(3, appt.getAppointmentTime());
            ps.setString(4, appt.getAdminNotes());
            ps.setString(5, "SCHEDULED");

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Appointment> getAppointmentsByDoctor(int doctorId) {
        List<Appointment> list = new ArrayList<>();
        // Join with patients table to get patient name
        String sql = "SELECT a.*, p.full_name as patient_name " +
                "FROM appointments a " +
                "JOIN patients p ON a.patient_id = p.id " +
                "WHERE a.doctor_id = ? " +
                "ORDER BY a.appointment_time ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment a = new Appointment();
                a.setId(rs.getInt("id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setAppointmentTime(rs.getTimestamp("appointment_time"));
                a.setStatus(rs.getString("status"));
                a.setAdminNotes(rs.getString("admin_notes"));
                a.setPatientName(rs.getString("patient_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // For Admin: See all appointments
    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.full_name as patient_name, u.full_name as doctor_name " +
                "FROM appointments a " +
                "JOIN patients p ON a.patient_id = p.id " +
                "JOIN users u ON a.doctor_id = u.id " +
                "ORDER BY a.appointment_time ASC";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Appointment a = new Appointment();
                a.setId(rs.getInt("id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setAppointmentTime(rs.getTimestamp("appointment_time"));
                a.setStatus(rs.getString("status"));
                a.setAdminNotes(rs.getString("admin_notes"));
                a.setPatientName(rs.getString("patient_name"));
                a.setDoctorName(rs.getString("doctor_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
