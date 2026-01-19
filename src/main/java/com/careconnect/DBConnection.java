package com.careconnect;

import java.sql.*;
import javax.servlet.ServletContextEvent;
import javax.servlet.ServletContextListener;
import javax.servlet.annotation.WebListener;

@WebListener
public class DBConnection implements ServletContextListener {
    private static final String URL;
    private static final String USER;
    private static final String PASSWORD;

    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("MySQL Driver not found", e);
        }

        // Get database credentials from environment variables
        USER = System.getenv("DB_USER") != null ? System.getenv("DB_USER") : "sahil";
        PASSWORD = System.getenv("DB_PASS") != null ? System.getenv("DB_PASS") : "";
        String dbName = System.getenv("DB_NAME") != null ? System.getenv("DB_NAME") : "hospital";

        // Check if running on Cloud Run (INSTANCE_CONNECTION_NAME env var exists)
        String instanceConnectionName = System.getenv("INSTANCE_CONNECTION_NAME");

        if (instanceConnectionName != null && !instanceConnectionName.isEmpty()) {
            // Cloud Run deployment: Use Unix socket connection via Cloud SQL Socket Factory
            URL = String.format(
                    "jdbc:mysql:///%s?cloudSqlInstance=%s&socketFactory=com.google.cloud.sql.mysql.SocketFactory&useSSL=false",
                    dbName,
                    instanceConnectionName);
        } else {
            // Local development: Use public IP connection
            String dbHost = System.getenv("DB_HOST") != null ? System.getenv("DB_HOST") : "localhost";
            URL = String.format(
                    "jdbc:mysql://%s:3306/%s?useSSL=false&allowPublicKeyRetrieval=true",
                    dbHost,
                    dbName);
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
                psInsert.setString(2, "admin");
                psInsert.setString(3, "ADMIN");
                psInsert.setString(4, "Super Admin");
                psInsert.executeUpdate();
            }

        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    @Override
    public void contextInitialized(ServletContextEvent sce) {
        initializeDatabase();
    }

    @Override
    public void contextDestroyed(ServletContextEvent sce) {
        // Cleanup if needed
    }
}
