package com.careconnect.dao;

import com.careconnect.db.DBConnection;
import com.careconnect.model.Patient;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class PatientDAO {

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
        return null; // Not found
    }
}
