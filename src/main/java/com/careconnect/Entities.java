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
        private String gender;
        private String bloodGroup;
        private double weight;
        private double height;
        private String address;
        private String emergencyContactName;
        private String emergencyContactPhone;
        private String allergies;
        private Timestamp createdAt;

        public Patient() {
        }

        public Patient(String fullName, String email, String phone, Date dob, String gender, String bloodGroup,
                double weight, double height) {
            this.fullName = fullName;
            this.email = email;
            this.phone = phone;
            this.dob = dob;
            this.gender = gender;
            this.bloodGroup = bloodGroup;
            this.weight = weight;
            this.height = height;
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

        public String getGender() {
            return gender;
        }

        public void setGender(String gender) {
            this.gender = gender;
        }

        public String getBloodGroup() {
            return bloodGroup;
        }

        public void setBloodGroup(String bloodGroup) {
            this.bloodGroup = bloodGroup;
        }

        public double getWeight() {
            return weight;
        }

        public void setWeight(double weight) {
            this.weight = weight;
        }

        public double getHeight() {
            return height;
        }

        public void setHeight(double height) {
            this.height = height;
        }

        public String getAddress() {
            return address;
        }

        public void setAddress(String address) {
            this.address = address;
        }

        public String getEmergencyContactName() {
            return emergencyContactName;
        }

        public void setEmergencyContactName(String emergencyContactName) {
            this.emergencyContactName = emergencyContactName;
        }

        public String getEmergencyContactPhone() {
            return emergencyContactPhone;
        }

        public void setEmergencyContactPhone(String emergencyContactPhone) {
            this.emergencyContactPhone = emergencyContactPhone;
        }

        public String getAllergies() {
            return allergies;
        }

        public void setAllergies(String allergies) {
            this.allergies = allergies;
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
        private double fee;

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
            this.fee = 500.00;
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

        public double getFee() {
            return fee;
        }

        public void setFee(double fee) {
            this.fee = fee;
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

    public static class Bed {
        private int id;
        private String bedNumber;
        private String roomNumber;
        private int floor;
        private String type;
        private double pricePerDay;
        private String status;

        public Bed() {
        }

        // Getters and Setters
        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getBedNumber() {
            return bedNumber;
        }

        public void setBedNumber(String bedNumber) {
            this.bedNumber = bedNumber;
        }

        public String getRoomNumber() {
            return roomNumber;
        }

        public void setRoomNumber(String roomNumber) {
            this.roomNumber = roomNumber;
        }

        public int getFloor() {
            return floor;
        }

        public void setFloor(int floor) {
            this.floor = floor;
        }

        public String getType() {
            return type;
        }

        public void setType(String type) {
            this.type = type;
        }

        public double getPricePerDay() {
            return pricePerDay;
        }

        public void setPricePerDay(double pricePerDay) {
            this.pricePerDay = pricePerDay;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }
    }

    public static class Staff {
        private int id;
        private String name;
        private String role;
        private String phone;
        private String assignedToType;
        private int assignedToId;
        private String assignedToName; // Helper for UI

        public Staff() {
        }

        // Getters and Setters
        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getRole() {
            return role;
        }

        public void setRole(String role) {
            this.role = role;
        }

        public String getPhone() {
            return phone;
        }

        public void setPhone(String phone) {
            this.phone = phone;
        }

        public String getAssignedToType() {
            return assignedToType;
        }

        public void setAssignedToType(String assignedToType) {
            this.assignedToType = assignedToType;
        }

        public int getAssignedToId() {
            return assignedToId;
        }

        public void setAssignedToId(int assignedToId) {
            this.assignedToId = assignedToId;
        }

        public String getAssignedToName() {
            return assignedToName;
        }

        public void setAssignedToName(String assignedToName) {
            this.assignedToName = assignedToName;
        }
    }

    public static class Admission {
        private int id;
        private int patientId;
        private int bedId;
        private int doctorId;
        private Timestamp admissionDate;
        private Timestamp dischargeDate;
        private String insuranceName;
        private double depositAmount;
        private String dischargeSummary;
        private String status;

        private String patientName;
        private String bedNumber;
        private String doctorName;
        private double pricePerDay;

        public Admission() {
        }

        // Getters and Setters
        public double getPricePerDay() {
            return pricePerDay;
        }

        public void setPricePerDay(double pricePerDay) {
            this.pricePerDay = pricePerDay;
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public int getPatientId() {
            return patientId;
        }

        public void setPatientId(int patientId) {
            this.patientId = patientId;
        }

        public int getBedId() {
            return bedId;
        }

        public void setBedId(int bedId) {
            this.bedId = bedId;
        }

        public int getDoctorId() {
            return doctorId;
        }

        public void setDoctorId(int doctorId) {
            this.doctorId = doctorId;
        }

        public Timestamp getAdmissionDate() {
            return admissionDate;
        }

        public void setAdmissionDate(Timestamp admissionDate) {
            this.admissionDate = admissionDate;
        }

        public Timestamp getDischargeDate() {
            return dischargeDate;
        }

        public void setDischargeDate(Timestamp dischargeDate) {
            this.dischargeDate = dischargeDate;
        }

        public String getInsuranceName() {
            return insuranceName;
        }

        public void setInsuranceName(String insuranceName) {
            this.insuranceName = insuranceName;
        }

        public double getDepositAmount() {
            return depositAmount;
        }

        public void setDepositAmount(double depositAmount) {
            this.depositAmount = depositAmount;
        }

        public String getDischargeSummary() {
            return dischargeSummary;
        }

        public void setDischargeSummary(String dischargeSummary) {
            this.dischargeSummary = dischargeSummary;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getPatientName() {
            return patientName;
        }

        public void setPatientName(String patientName) {
            this.patientName = patientName;
        }

        public String getBedNumber() {
            return bedNumber;
        }

        public void setBedNumber(String bedNumber) {
            this.bedNumber = bedNumber;
        }

        public String getDoctorName() {
            return doctorName;
        }

        public void setDoctorName(String doctorName) {
            this.doctorName = doctorName;
        }
    }

    public static class BillingCatalog {
        private int id;
        private String itemName;
        private String category;
        private double price;

        public BillingCatalog() {
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getItemName() {
            return itemName;
        }

        public void setItemName(String itemName) {
            this.itemName = itemName;
        }

        public String getCategory() {
            return category;
        }

        public void setCategory(String category) {
            this.category = category;
        }

        public double getPrice() {
            return price;
        }

        public void setPrice(double price) {
            this.price = price;
        }
    }

    public static class PatientReport {
        private int id;
        private int patientId;
        private int admissionId;
        private int appointmentId;
        private int testId;
        private String findings;
        private Timestamp testDate;
        private String status;

        private String patientName;
        private String testName;

        public PatientReport() {
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public int getPatientId() {
            return patientId;
        }

        public void setPatientId(int patientId) {
            this.patientId = patientId;
        }

        public int getAdmissionId() {
            return admissionId;
        }

        public void setAdmissionId(int admissionId) {
            this.admissionId = admissionId;
        }

        public int getAppointmentId() {
            return appointmentId;
        }

        public void setAppointmentId(int appointmentId) {
            this.appointmentId = appointmentId;
        }

        public int getTestId() {
            return testId;
        }

        public void setTestId(int testId) {
            this.testId = testId;
        }

        public String getFindings() {
            return findings;
        }

        public void setFindings(String findings) {
            this.findings = findings;
        }

        public Timestamp getTestDate() {
            return testDate;
        }

        public void setTestDate(Timestamp testDate) {
            this.testDate = testDate;
        }

        public String getStatus() {
            return status;
        }

        public void setStatus(String status) {
            this.status = status;
        }

        public String getPatientName() {
            return patientName;
        }

        public void setPatientName(String patientName) {
            this.patientName = patientName;
        }

        public String getTestName() {
            return testName;
        }

        public void setTestName(String testName) {
            this.testName = testName;
        }
    }

    public static class Medicine {
        private int id;
        private String name;
        private String batchNo;
        private Date expiryDate;
        private int currentStock;
        private double pricePerUnit;
        private int lowStockThreshold;
        private String supplierEmail;
        private boolean isReordered;

        public Medicine() {
        }

        // Getters and Setters
        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public String getName() {
            return name;
        }

        public void setName(String name) {
            this.name = name;
        }

        public String getBatchNo() {
            return batchNo;
        }

        public void setBatchNo(String batchNo) {
            this.batchNo = batchNo;
        }

        public Date getExpiryDate() {
            return expiryDate;
        }

        public void setExpiryDate(Date expiryDate) {
            this.expiryDate = expiryDate;
        }

        public int getCurrentStock() {
            return currentStock;
        }

        public void setCurrentStock(int currentStock) {
            this.currentStock = currentStock;
        }

        public double getPricePerUnit() {
            return pricePerUnit;
        }

        public void setPricePerUnit(double pricePerUnit) {
            this.pricePerUnit = pricePerUnit;
        }

        public int getLowStockThreshold() {
            return lowStockThreshold;
        }

        public void setLowStockThreshold(int lowStockThreshold) {
            this.lowStockThreshold = lowStockThreshold;
        }

        public String getSupplierEmail() {
            return supplierEmail;
        }

        public void setSupplierEmail(String supplierEmail) {
            this.supplierEmail = supplierEmail;
        }

        public boolean isReordered() {
            return isReordered;
        }

        public void setReordered(boolean reordered) {
            isReordered = reordered;
        }
    }

    public static class Billing {
        private int id;
        private int patientId;
        private int admissionId;
        private int appointmentId;
        private double totalAmount;
        private double paidAmount;
        private String paymentStatus;
        private Timestamp billingDate;

        private String patientName;

        public Billing() {
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public int getPatientId() {
            return patientId;
        }

        public void setPatientId(int patientId) {
            this.patientId = patientId;
        }

        public int getAdmissionId() {
            return admissionId;
        }

        public void setAdmissionId(int admissionId) {
            this.admissionId = admissionId;
        }

        public int getAppointmentId() {
            return appointmentId;
        }

        public void setAppointmentId(int appointmentId) {
            this.appointmentId = appointmentId;
        }

        public double getTotalAmount() {
            return totalAmount;
        }

        public void setTotalAmount(double totalAmount) {
            this.totalAmount = totalAmount;
        }

        public double getPaidAmount() {
            return paidAmount;
        }

        public void setPaidAmount(double paidAmount) {
            this.paidAmount = paidAmount;
        }

        public String getPaymentStatus() {
            return paymentStatus;
        }

        public void setPaymentStatus(String paymentStatus) {
            this.paymentStatus = paymentStatus;
        }

        public Timestamp getBillingDate() {
            return billingDate;
        }

        public void setBillingDate(Timestamp billingDate) {
            this.billingDate = billingDate;
        }

        public String getPatientName() {
            return patientName;
        }

        public void setPatientName(String patientName) {
            this.patientName = patientName;
        }
    }

    public static class Prescription {
        private int id;
        private int appointmentId;
        private int doctorId;
        private int patientId;
        private String diagnosis;
        private Timestamp prescribedDate;

        public Prescription() {
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public int getAppointmentId() {
            return appointmentId;
        }

        public void setAppointmentId(int appointmentId) {
            this.appointmentId = appointmentId;
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

        public String getDiagnosis() {
            return diagnosis;
        }

        public void setDiagnosis(String diagnosis) {
            this.diagnosis = diagnosis;
        }

        public Timestamp getPrescribedDate() {
            return prescribedDate;
        }

        public void setPrescribedDate(Timestamp prescribedDate) {
            this.prescribedDate = prescribedDate;
        }
    }

    public static class PrescriptionDetail {
        private int id;
        private int prescriptionId;
        private int medicineId;
        private String dosageMorning;
        private String dosageNoon;
        private String dosageEvening;
        private String dosageNight;
        private String duration;
        private int quantity;
        private String medicineName;

        public PrescriptionDetail() {
        }

        // Getters and Setters
        public String getMedicineName() {
            return medicineName;
        }

        public void setMedicineName(String medicineName) {
            this.medicineName = medicineName;
        }

        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public int getPrescriptionId() {
            return prescriptionId;
        }

        public void setPrescriptionId(int prescriptionId) {
            this.prescriptionId = prescriptionId;
        }

        public int getMedicineId() {
            return medicineId;
        }

        public void setMedicineId(int medicineId) {
            this.medicineId = medicineId;
        }

        public String getDosageMorning() {
            return dosageMorning;
        }

        public void setDosageMorning(String dosageMorning) {
            this.dosageMorning = dosageMorning;
        }

        public String getDosageNoon() {
            return dosageNoon;
        }

        public void setDosageNoon(String dosageNoon) {
            this.dosageNoon = dosageNoon;
        }

        public String getDosageEvening() {
            return dosageEvening;
        }

        public void setDosageEvening(String dosageEvening) {
            this.dosageEvening = dosageEvening;
        }

        public String getDosageNight() {
            return dosageNight;
        }

        public void setDosageNight(String dosageNight) {
            this.dosageNight = dosageNight;
        }

        public String getDuration() {
            return duration;
        }

        public void setDuration(String duration) {
            this.duration = duration;
        }

        public int getQuantity() {
            return quantity;
        }

        public void setQuantity(int quantity) {
            this.quantity = quantity;
        }
    }

    public static class BillingDetail {
        private int id;
        private int billingId;
        private String itemName;
        private double amount;

        public BillingDetail() {
        }

        public BillingDetail(int billingId, String itemName, double amount) {
            this.billingId = billingId;
            this.itemName = itemName;
            this.amount = amount;
        }

        // Getters and Setters
        public int getId() {
            return id;
        }

        public void setId(int id) {
            this.id = id;
        }

        public int getBillingId() {
            return billingId;
        }

        public void setBillingId(int billingId) {
            this.billingId = billingId;
        }

        public String getItemName() {
            return itemName;
        }

        public void setItemName(String itemName) {
            this.itemName = itemName;
        }

        public double getAmount() {
            return amount;
        }

        public void setAmount(double amount) {
            this.amount = amount;
        }
    }
}
