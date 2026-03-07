package com.careconnect;

import java.io.BufferedReader;
import java.io.FileReader;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.Statement;

public class DatabaseRestorer {
    public static void main(String[] args) {
        String dbHost = System.getenv("DB_HOST");
        if (dbHost == null || dbHost.isEmpty()) {
            dbHost = "34.124.163.81";
        }
        String dbUser = System.getenv("DB_USER");
        if (dbUser == null || dbUser.isEmpty()) {
            dbUser = "root";
        }
        String dbPass = System.getenv("DB_PASS");
        if (dbPass == null || dbPass.isEmpty()) {
            dbPass = "";
        }

        String baseUrl = "jdbc:mysql://" + dbHost + ":3306/?useSSL=false&allowPublicKeyRetrieval=true";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            System.out.println("Connecting to " + dbHost + " as " + dbUser + "...");

            executeSqlFile(baseUrl, dbUser, dbPass, "full_setup.sql");

            System.out.println("\nSUCCESS: Database restoration completed!");
        } catch (Exception e) {
            e.printStackTrace();
            System.err.println("Restoration failed: " + e.getMessage());
        }
    }

    private static void executeSqlFile(String url, String user, String pass, String fileName) throws Exception {
        System.out.println("Executing " + fileName + "...");
        try (Connection conn = DriverManager.getConnection(url, user, pass);
                Statement stmt = conn.createStatement();
                BufferedReader reader = new BufferedReader(new FileReader(fileName))) {

            stmt.execute("SET FOREIGN_KEY_CHECKS = 0");

            StringBuilder sql = new StringBuilder();
            String line;
            while ((line = reader.readLine()) != null) {
                String trimmed = line.trim();
                if (trimmed.isEmpty() || trimmed.startsWith("--") || trimmed.startsWith("/*"))
                    continue;

                sql.append(line).append("\n");

                if (trimmed.endsWith(";")) {
                    String finalSql = sql.toString().trim();
                    if (!finalSql.isEmpty()) {
                        try {
                            stmt.execute(finalSql);
                        } catch (Exception e) {
                            System.err.println(
                                    "Warning at statement starting with ["
                                            + finalSql.substring(0, Math.min(30, finalSql.length())).replace("\n", " ")
                                            + "...]: " + e.getMessage());
                        }
                    }
                    sql.setLength(0);
                }
            }

            stmt.execute("SET FOREIGN_KEY_CHECKS = 1");
        }
    }
}
