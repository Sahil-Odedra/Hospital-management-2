package com.careconnect;

import java.sql.Date;
import java.sql.Timestamp;

public class Entities {

    public static class User {
        private int id;
        private String email;
        private String password;
        private String role;
        private String fullName;
        private String specialization;
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

    public static class Patient {
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

    public static class Appointment {
        private int id;
        private int doctorId;
        private int patientId;
        private Timestamp appointmentTime;
        private String status;
        private String adminNotes;

        private String doctorName;
        private String patientName;

        public Appointment() {
        }

        public Appointment(int doctorId, int patientId, Timestamp appointmentTime, String adminNotes) {
            this.doctorId = doctorId;
            this.patientId = patientId;
            this.appointmentTime = appointmentTime;
            this.adminNotes = adminNotes;
            this.status = "SCHEDULED";
        }

        // Getters and Setters
        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public int getDoctorId() {
            return doctorId;
        }

        public void setDoctorId(int doctorId) {
            this.doctorId = doctorId;
        }

        public int getPatientId() {
            return patientId;
        }

        public void setPatientId(int patientId) {
            this.patientId = patientId;
        }

        public Timestamp getAppointmentTime() {
            return appointmentTime;
        }

        public void setAppointmentTime(Timestamp appointmentTime) {
            this.appointmentTime = appointmentTime;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getAdminNotes() {
            return adminNotes;
        }

        public void setAdminNotes(String adminNotes) {
            this.adminNotes = adminNotes;
        }

        public String getDoctorName() {
            return doctorName;
        }

        public void setDoctorName(String doctorName) {
            this.doctorName = doctorName;
        }

        public String getPatientName() {
            return patientName;
        }

        public void setPatientName(String patientName) {
            this.patientName = patientName;
        }
    }
}
