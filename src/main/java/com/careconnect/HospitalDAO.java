package com.careconnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.careconnect.Entities.*;

public class HospitalDAO {

    public User login(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setFullName(rs.getString("full_name"));
                user.setSpecialization(rs.getString("specialization"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean createDoctor(User user) {
        String sql = "INSERT INTO users (email, password, role, full_name, specialization) VALUES (?, ?, 'DOCTOR', ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getSpecialization());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<User> getAllDoctors() {
        List<User> doctors = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'DOCTOR'";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                User doc = new User();
                doc.setId(rs.getInt("id"));
                doc.setEmail(rs.getString("email"));
                doc.setFullName(rs.getString("full_name"));
                doc.setSpecialization(rs.getString("specialization"));
                doctors.add(doc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return doctors;
    }

    public boolean addPatient(Patient patient) {
        String sql = "INSERT INTO patients (full_name, email, phone, dob) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, patient.getFullName());
            ps.setString(2, patient.getEmail());
            ps.setString(3, patient.getPhone());
            ps.setDate(4, patient.getDob());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT * FROM patients ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Patient p = new Patient();
                p.setId(rs.getInt("id"));
                p.setFullName(rs.getString("full_name"));
                p.setEmail(rs.getString("email"));
                p.setPhone(rs.getString("phone"));
                p.setDob(rs.getDate("dob"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                patients.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }

    public Patient getPatientById(int id) {
        String sql = "SELECT * FROM patients WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Patient p = new Patient();
                p.setId(rs.getInt("id"));
                p.setFullName(rs.getString("full_name"));
                p.setEmail(rs.getString("email"));
                p.setPhone(rs.getString("phone"));
                p.setDob(rs.getDate("dob"));
                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

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
        String sql = "SELECT a.*, p.full_name as patient_name FROM appointments a JOIN patients p ON a.patient_id = p.id WHERE a.doctor_id = ? ORDER BY a.appointment_time ASC";

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

    public int getDoctorCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'DOCTOR'";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getPatientCount() {
        String sql = "SELECT COUNT(*) FROM patients";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getPendingAppointmentCount() {
        String sql = "SELECT COUNT(*) FROM appointments WHERE status = 'SCHEDULED'";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.full_name as patient_name, u.full_name as doctor_name FROM appointments a JOIN patients p ON a.patient_id = p.id JOIN users u ON a.doctor_id = u.id ORDER BY a.appointment_time ASC";

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
