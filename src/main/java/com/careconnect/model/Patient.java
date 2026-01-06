package com.careconnect.model;

import java.sql.Date;
import java.sql.Timestamp;

public class Patient {
    private int id;
    private String fullName;
    private String email;
    private String phone;
    private Date dob;
    private Timestamp createdAt;

    public Patient() {
    }

    public Patient(String fullName, String email, String phone, Date dob) {
        this.fullName = fullName;
        this.email = email;
        this.phone = phone;
        this.dob = dob;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getFullName() {
        return fullName;
    }

    public void setFullName(String fullName) {
        this.fullName = fullName;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public Date getDob() {
        return dob;
    }

    public void setDob(Date dob) {
        this.dob = dob;
    }

    public Timestamp getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(Timestamp createdAt) {
        this.createdAt = createdAt;
    }
}
