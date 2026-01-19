package com.careconnect;

import java.sql.*;

public class DBConnection {
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

        // Read values from environment variables
        String dbUser = System.getenv("DB_USER");
        String dbPass = System.getenv("DB_PASS");
        String dbName = System.getenv("DB_NAME");
        String inst = System.getenv("INSTANCE_CONNECTION_NAME");

        // Defaults for local testing if env vars aren't set
        USER = (dbUser != null) ? dbUser : "sahil";
        PASSWORD = (dbPass != null) ? dbPass : "123";
        String database = (dbName != null) ? dbName : "hospital";

        if (inst != null && !inst.isEmpty()) {
            // Cloud Run (Socket Factory)
            URL = String.format(
                    "jdbc:mysql:///%s?cloudSqlInstance=%s&socketFactory=com.google.cloud.sql.mysql.SocketFactory&useSSL=false",
                    database, inst);
        } else {
            // Local fallback (Public IP)
            URL = "jdbc:mysql://34.124.163.81:3306/" + database + "?useSSL=false&allowPublicKeyRetrieval=true";
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
