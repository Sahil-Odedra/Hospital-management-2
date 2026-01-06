package com.careconnect.dao;

import com.careconnect.db.DBConnection;
import com.careconnect.model.User;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class UserDAO {

    // Login Method
    public User login(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            if (conn == null) {
                System.out.println("❌ UserDAO: DB Connection is NULL");
                return null;
            }
            System.out.println("✅ UserDAO: Connected to DB");

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                System.out.println("✅ UserDAO: User found in DB");
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
            System.err.println("❌ UserDAO Error: " + e.getMessage());
            e.printStackTrace();
        }
        return null;
    }

    // Register/Create Doctor
    public boolean createDoctor(User user) {
        String sql = "INSERT INTO users (email, password, role, full_name, specialization) VALUES (?, ?, 'DOCTOR', ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword()); // In real app, hash this
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getSpecialization());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // Get All Doctors
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
}
