package com.careconnect.db;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import java.sql.Statement;

public class DatabaseInitializer {

    public static void main(String[] args) {
        System.out.println("Starting Database Initialization...");
        try (Connection conn = DBConnection.getConnection()) {
            if (conn == null) {
                System.out.println("❌ Failed to establish connection.");
                return;
            }
            System.out.println("✅ Connected to Database.");

            Statement stmt = conn.createStatement();

            // 1. Create Users Table (Admin & Doctors)
            String createUsers = "CREATE TABLE IF NOT EXISTS users (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "email VARCHAR(100) NOT NULL UNIQUE, " +
                    "password VARCHAR(100) NOT NULL, " +
                    "role ENUM('ADMIN', 'DOCTOR') NOT NULL, " +
                    "full_name VARCHAR(100), " +
                    "specialization VARCHAR(100), " + // Nullable, only for doctors
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")";
            stmt.executeUpdate(createUsers);
            System.out.println("✅ Table 'users' ready.");

            // 2. Create Patients Table
            String createPatients = "CREATE TABLE IF NOT EXISTS patients (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "full_name VARCHAR(100) NOT NULL, " +
                    "email VARCHAR(100) NOT NULL, " +
                    "phone VARCHAR(20), " +
                    "dob DATE, " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")";
            stmt.executeUpdate(createPatients);
            System.out.println("✅ Table 'patients' ready.");

            // 3. Create Appointments Table
            String createAppointments = "CREATE TABLE IF NOT EXISTS appointments (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "doctor_id INT NOT NULL, " +
                    "patient_id INT NOT NULL, " +
                    "appointment_time DATETIME NOT NULL, " +
                    "status ENUM('SCHEDULED', 'COMPLETED', 'CANCELLED') DEFAULT 'SCHEDULED', " +
                    "admin_notes TEXT, " +
                    "FOREIGN KEY (doctor_id) REFERENCES users(id), " +
                    "FOREIGN KEY (patient_id) REFERENCES patients(id)" +
                    ")";
            stmt.executeUpdate(createAppointments);
            System.out.println("✅ Table 'appointments' ready.");

            // 4. Create Default Admin User
            String checkAdmin = "SELECT COUNT(*) FROM users WHERE email = 'admin@hospital.com'";
            PreparedStatement ps = conn.prepareStatement(checkAdmin);
            java.sql.ResultSet rs = ps.executeQuery();
            rs.next();
            if (rs.getInt(1) == 0) {
                String insertAdmin = "INSERT INTO users (email, password, role, full_name) VALUES (?, ?, ?, ?)";
                PreparedStatement psInsert = conn.prepareStatement(insertAdmin);
                psInsert.setString(1, "admin@hospital.com");
                psInsert.setString(2, "admin123"); // Authenticated via simple check for now
                psInsert.setString(3, "ADMIN");
                psInsert.setString(4, "Super Admin");
                psInsert.executeUpdate();
                System.out.println("✅ Default Admin User Created (admin@hospital.com / admin123)");
            } else {
                System.out.println("ℹ️ Admin user already exists.");
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
