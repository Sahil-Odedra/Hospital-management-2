package com.careconnect.model;

import java.sql.Timestamp;

public class User {
    private int id;
    private String email;
    private String password;
    private String role; // 'ADMIN' or 'DOCTOR'
    private String fullName;
    private String specialization; // Only for Doctors
    private Timestamp createdAt;

    public User() {
    }

    public User(String email, String password, String role, String fullName, String specialization) {
        this.email = email;
        this.password = password;
        this.role = role;
        this.fullName = fullName;
        this.specialization = specialization;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPassword() {
        return password;
    }

    public void setPassword(String password) {
        this.password = password;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getSpecialization() {
        return specialization;
    }

    public void setSpecialization(String specialization) {
        this.specialization = specialization;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
