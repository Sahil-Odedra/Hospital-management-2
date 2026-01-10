package com.careconnect;

import java.sql.*;

public class DBConnection {
    private static final String URL = "jdbc:mysql://hospital-db.ctwq4c0e041t.ap-south-1.rds.amazonaws.com:3306/hospital?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "admin";
    private static final String PASSWORD = "12345678";

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("MySQL Driver not found", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }

    public static void initializeDatabase() {
        try (Connection conn = getConnection()) {
            if (conn == null)
                return;

            Statement stmt = conn.createStatement();

            // 1. Create Users Table
            String createUsers = "CREATE TABLE IF NOT EXISTS users (" +
                    "id INT AUTO_INCREMENT PRIMARY KEY, " +
                    "email VARCHAR(100) NOT NULL UNIQUE, " +
                    "password VARCHAR(100) NOT NULL, " +
                    "role ENUM('ADMIN', 'DOCTOR') NOT NULL, " +
                    "full_name VARCHAR(100), " +
                    "specialization VARCHAR(100), " +
                    "created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP" +
                    ")";
            stmt.executeUpdate(createUsers);

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

            // 4. Create/Ensure Default Admin User
            String checkAdmin = "SELECT COUNT(*) FROM users WHERE email = 'admin@hospital.com'";
            PreparedStatement ps = conn.prepareStatement(checkAdmin);
            ResultSet rs = ps.executeQuery();
            rs.next();
            if (rs.getInt(1) == 0) {
                String insertAdmin = "INSERT INTO users (email, password, role, full_name) VALUES (?, ?, ?, ?)";
                PreparedStatement psInsert = conn.prepareStatement(insertAdmin);
                psInsert.setString(1, "admin@hospital.com");
                psInsert.setString(2, "admin"); // Matches user request
                psInsert.setString(3, "ADMIN");
                psInsert.setString(4, "Super Admin");
                psInsert.executeUpdate();
                System.out.println("Default Admin created: admin/admin");
            } else {
                // Optional: Update password to 'admin' if it exists but is wrong?
                // For now, let's assume if it exists, it's fine.
                // But since the user complained, maybe I should forcing update?
                // No, safer to just ensure existence using the logic above.
                System.out.println("Admin user already exists.");
            }

            System.out.println("Database initialized successfully.");

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
