package com.careconnect.db;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DBConnection {
    private static String URL;
    private static String USER;
    private static String PASSWORD;

    // Load Driver and Properties Static Block
    static {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Load properties
            java.util.Properties props = new java.util.Properties();
            java.io.InputStream is = DBConnection.class.getClassLoader().getResourceAsStream("db.properties");

            if (is != null) {
                props.load(is);
                URL = props.getProperty("db.url");
                USER = props.getProperty("db.user");
                PASSWORD = props.getProperty("db.password");
            } else {
                // Fallback or Error
                System.err.println("❌ db.properties not found!");
            }

        } catch (Exception e) {
            e.printStackTrace();
            throw new RuntimeException("Error initializing DB Connection", e);
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
