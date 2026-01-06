package com.careconnect.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    // Database Credentials from User
    private static final String URL = "jdbc:mysql://34.143.135.67:3306/hospital?useSSL=false&allowPublicKeyRetrieval=true";
    private static final String USER = "root";
    private static final String PASSWORD = "1234"; // Ideally, use environment variables

    // Load Driver Static Block
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
            throw new RuntimeException("Error loading MySQL Driver", e);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
    
    // Test helper (Main method to verification connection quickly)
    public static void main(String[] args) {
        try (Connection conn = getConnection()) {
            if (conn != null) {
                System.out.println("✅ Successfully connected to Google Cloud SQL!");
            }
        } catch (SQLException e) {
            System.err.println("❌ Connection Failed!");
            e.printStackTrace();
        }
    }
}
