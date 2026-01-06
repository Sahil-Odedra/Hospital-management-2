package com.careconnect.db;

import java.sql.*;

public class DBConnection {
    // Hardcoded credentials to avoid properties file encoding issues
    private static final String URL = "jdbc:mysql://34.143.135.67:3306/hospital?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "1234";

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

            // 1. Create Users Table (Admin & Doctors)
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

            // 4. Create Default Admin User
            String checkAdmin = "SELECT COUNT(*) FROM users WHERE email = 'admin@hospital.com'";
            PreparedStatement ps = conn.prepareStatement(checkAdmin);
            ResultSet rs = ps.executeQuery();
            rs.next();
            if (rs.getInt(1) == 0) {
                String insertAdmin = "INSERT INTO users (email, password, role, full_name) VALUES (?, ?, ?, ?)";
                PreparedStatement psInsert = conn.prepareStatement(insertAdmin);
                psInsert.setString(1, "admin@hospital.com");
                psInsert.setString(2, "admin123");
                psInsert.setString(3, "ADMIN");
                psInsert.setString(4, "Super Admin");
                psInsert.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
}
