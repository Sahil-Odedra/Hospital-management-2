package com.careconnect.model;

import java.sql.Timestamp;

public class Appointment {
    private int id;
    private int doctorId;
    private int patientId;
    private Timestamp appointmentTime;
    private String status; // 'SCHEDULED', 'COMPLETED', 'CANCELLED'
    private String adminNotes;

    // Helper fields for UI (joined data)
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
