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

        USER = "sahil";
        PASSWORD = "123";

        String inst = System.getenv("INSTANCE_CONNECTION_NAME");
        if (inst != null && !inst.isEmpty()) {
            URL = "jdbc:mysql:///hospital?cloudSqlInstance=" + inst
                    + "&socketFactory=com.google.cloud.sql.mysql.SocketFactory&useSSL=false";
        } else {
            URL = "jdbc:mysql://34.124.163.81:3306/hospital?useSSL=false&allowPublicKeyRetrieval=true";
        }
    }

    public static Connection getConnection() throws SQLException {
        return DriverManager.getConnection(URL, USER, PASSWORD);
    }
}
