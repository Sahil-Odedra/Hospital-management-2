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

        String dbUser = System.getenv("DB_USER");
        String dbPass = System.getenv("DB_PASS");
        String dbName = System.getenv("DB_NAME");
        String inst = System.getenv("INSTANCE_CONNECTION_NAME");

        USER = (dbUser != null) ? dbUser : "root";
        PASSWORD = (dbPass != null) ? dbPass : "";
        String database = (dbName != null) ? dbName : "hospital";

        if (inst != null && !inst.isEmpty()) {
            URL = String.format(
                    "jdbc:mysql:///%s?cloudSqlInstance=%s&socketFactory=com.google.cloud.sql.mysql.SocketFactory&useSSL=false",
                    database, inst);
        } else {
            String dbHost = System.getenv("DB_HOST");
            if (dbHost == null || dbHost.isEmpty()) {
                dbHost = "34.35.125.240";
            }
            URL = String.format("jdbc:mysql://%s:3306/%s?useSSL=false&allowPublicKeyRetrieval=true", dbHost, database);
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
