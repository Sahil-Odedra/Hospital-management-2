package com.careconnect;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.Map;
import java.util.HashMap;
import java.util.LinkedHashMap;
import com.careconnect.Entities.*;

public class HospitalDAO {

    public Map<String, Double> getMonthlyRevenue() {
        Map<String, Double> revenue = new LinkedHashMap<>();
        String sql = "SELECT DATE_FORMAT(billing_date, '%b %Y') as month, SUM(total_amount) as total " +
                "FROM billing " +
                "GROUP BY month " +
                "ORDER BY MIN(billing_date) DESC " +
                "LIMIT 6";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                revenue.put(rs.getString("month"), rs.getDouble("total"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return revenue;
    }

    public User login(String email, String password) {
        String sql = "SELECT * FROM users WHERE email = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, email);
            ps.setString(2, password);

            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                user.setFullName(rs.getString("full_name"));
                user.setSpecialization(rs.getString("specialization"));
                user.setCreatedAt(rs.getTimestamp("created_at"));
                return user;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean createDoctor(User user) {
        String sql = "INSERT INTO users (email, password, role, full_name, specialization) VALUES (?, ?, 'DOCTOR', ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, user.getEmail());
            ps.setString(2, user.getPassword());
            ps.setString(3, user.getFullName());
            ps.setString(4, user.getSpecialization());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<User> getAllDoctors() {
        List<User> doctors = new ArrayList<>();
        String sql = "SELECT * FROM users WHERE role = 'DOCTOR'";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                User doc = new User();
                doc.setId(rs.getInt("id"));
                doc.setEmail(rs.getString("email"));
                doc.setFullName(rs.getString("full_name"));
                doc.setSpecialization(rs.getString("specialization"));
                doctors.add(doc);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return doctors;
    }

    public boolean deleteDoctor(int id) {
        String sql = "DELETE FROM users WHERE id = ? AND role = 'DOCTOR'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean addPatient(Patient patient) {
        String sql = "INSERT INTO patients (full_name, email, phone, dob, gender, blood_group, weight, height, address, emergency_contact_name, emergency_contact_phone, allergies) "
                + "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, patient.getFullName());
            ps.setString(2, patient.getEmail());
            ps.setString(3, patient.getPhone());
            ps.setDate(4, patient.getDob());
            ps.setString(5, patient.getGender());
            ps.setString(6, patient.getBloodGroup());
            ps.setDouble(7, patient.getWeight());
            ps.setDouble(8, patient.getHeight());
            ps.setString(9, patient.getAddress());
            ps.setString(10, patient.getEmergencyContactName());
            ps.setString(11, patient.getEmergencyContactPhone());
            ps.setString(12, patient.getAllergies());

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Patient> getAllPatients() {
        List<Patient> patients = new ArrayList<>();
        String sql = "SELECT * FROM patients ORDER BY created_at DESC";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Patient p = new Patient();
                p.setId(rs.getInt("id"));
                p.setFullName(rs.getString("full_name"));
                p.setEmail(rs.getString("email"));
                p.setPhone(rs.getString("phone"));
                p.setDob(rs.getDate("dob"));
                p.setGender(rs.getString("gender"));
                p.setBloodGroup(rs.getString("blood_group"));
                p.setWeight(rs.getDouble("weight"));
                p.setHeight(rs.getDouble("height"));
                p.setAddress(rs.getString("address"));
                p.setEmergencyContactName(rs.getString("emergency_contact_name"));
                p.setEmergencyContactPhone(rs.getString("emergency_contact_phone"));
                p.setAllergies(rs.getString("allergies"));
                p.setCreatedAt(rs.getTimestamp("created_at"));
                patients.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return patients;
    }

    public Patient getPatientById(int id) {
        String sql = "SELECT * FROM patients WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Patient p = new Patient();
                p.setId(rs.getInt("id"));
                p.setFullName(rs.getString("full_name"));
                p.setEmail(rs.getString("email"));
                p.setPhone(rs.getString("phone"));
                p.setDob(rs.getDate("dob"));
                p.setGender(rs.getString("gender"));
                p.setBloodGroup(rs.getString("blood_group"));
                p.setWeight(rs.getDouble("weight"));
                p.setHeight(rs.getDouble("height"));
                p.setAddress(rs.getString("address"));
                p.setEmergencyContactName(rs.getString("emergency_contact_name"));
                p.setEmergencyContactPhone(rs.getString("emergency_contact_phone"));
                p.setAllergies(rs.getString("allergies"));
                return p;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public Patient patientLogin(String email, java.sql.Date dob) {
        String sql = "SELECT * FROM patients WHERE email = ? AND dob = ?";
        try (java.sql.Connection conn = DBConnection.getConnection();
                java.sql.PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, email);
            ps.setDate(2, dob);
            java.sql.ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Patient p = new Patient();
                p.setId(rs.getInt("id"));
                p.setFullName(rs.getString("full_name"));
                p.setEmail(rs.getString("email"));
                p.setPhone(rs.getString("phone"));
                p.setDob(rs.getDate("dob"));
                p.setGender(rs.getString("gender"));
                p.setBloodGroup(rs.getString("blood_group"));
                p.setWeight(rs.getDouble("weight"));
                p.setHeight(rs.getDouble("height"));
                p.setAddress(rs.getString("address"));
                p.setEmergencyContactName(rs.getString("emergency_contact_name"));
                p.setEmergencyContactPhone(rs.getString("emergency_contact_phone"));
                p.setAllergies(rs.getString("allergies"));
                return p;
            }
        } catch (java.sql.SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean scheduleAppointment(Appointment appt) {
        String sql = "INSERT INTO appointments (doctor_id, patient_id, appointment_time, admin_notes, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, appt.getDoctorId());
            ps.setInt(2, appt.getPatientId());
            ps.setTimestamp(3, appt.getAppointmentTime());
            ps.setString(4, appt.getAdminNotes());
            ps.setString(5, "SCHEDULED");

            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Appointment> getAppointmentsByDoctor(int doctorId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.full_name as patient_name FROM appointments a JOIN patients p ON a.patient_id = p.id WHERE a.doctor_id = ? ORDER BY a.appointment_time ASC";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, doctorId);
            ResultSet rs = ps.executeQuery();

            while (rs.next()) {
                Appointment a = new Appointment();
                a.setId(rs.getInt("id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setAppointmentTime(rs.getTimestamp("appointment_time"));
                a.setStatus(rs.getString("status"));
                a.setAdminNotes(rs.getString("admin_notes"));
                a.setPatientName(rs.getString("patient_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public int getDoctorCount() {
        String sql = "SELECT COUNT(*) FROM users WHERE role = 'DOCTOR'";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getPatientCount() {
        String sql = "SELECT COUNT(*) FROM patients";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getPendingAppointmentCount() {
        String sql = "SELECT COUNT(*) FROM appointments WHERE status = 'SCHEDULED'";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public int getMedicineCount() {
        String sql = "SELECT COUNT(*) FROM medicines";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            if (rs.next())
                return rs.getInt(1);
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return 0;
    }

    public Map<String, Integer> getAppointmentCountsByDate() {
        Map<String, Integer> counts = new HashMap<>();
        String sql = "SELECT DATE(appointment_time) as date, COUNT(*) as count FROM appointments GROUP BY DATE(appointment_time)";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                counts.put(rs.getString("date"), rs.getInt("count"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return counts;
    }

    public List<String> getBookedSlots(int doctorId, String date) {
        List<String> bookedSlots = new ArrayList<>();
        String sql = "SELECT DATE_FORMAT(appointment_time, '%H:%i:%s') as time FROM appointments WHERE doctor_id = ? AND DATE(appointment_time) = ? AND status != 'CANCELLED'";

        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, doctorId);
            ps.setString(2, date);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                bookedSlots.add(rs.getString("time"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return bookedSlots;
    }

    public List<Appointment> getAllAppointments() {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, p.full_name as patient_name, u.full_name as doctor_name FROM appointments a JOIN patients p ON a.patient_id = p.id JOIN users u ON a.doctor_id = u.id ORDER BY a.appointment_time ASC";

        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {

            while (rs.next()) {
                Appointment a = new Appointment();
                a.setId(rs.getInt("id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setAppointmentTime(rs.getTimestamp("appointment_time"));
                a.setStatus(rs.getString("status"));
                a.setAdminNotes(rs.getString("admin_notes"));
                a.setPatientName(rs.getString("patient_name"));
                a.setDoctorName(rs.getString("doctor_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Medicine> getAllMedicines() {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT * FROM medicines ORDER BY name ASC";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Medicine m = new Medicine();
                m.setId(rs.getInt("id"));
                m.setName(rs.getString("name"));
                m.setBatchNo(rs.getString("batch_no"));
                m.setExpiryDate(rs.getDate("expiry_date"));
                m.setCurrentStock(rs.getInt("current_stock"));
                m.setPricePerUnit(rs.getDouble("price_per_unit"));
                m.setLowStockThreshold(rs.getInt("low_stock_threshold"));
                m.setSupplierEmail(rs.getString("supplier_email"));
                m.setReordered(rs.getBoolean("is_reordered"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // --- Medicine Management ---

    public boolean addMedicine(Medicine m) {
        String sql = "INSERT INTO medicines (name, batch_no, expiry_date, current_stock, price_per_unit, low_stock_threshold, supplier_email) VALUES (?, ?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, m.getName());
            ps.setString(2, m.getBatchNo());
            ps.setDate(3, m.getExpiryDate());
            ps.setInt(4, m.getCurrentStock());
            ps.setDouble(5, m.getPricePerUnit());
            ps.setInt(6, m.getLowStockThreshold());
            ps.setString(7, m.getSupplierEmail());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateMedicineStock(int id, int addedQuantity) {
        String sql = "UPDATE medicines SET current_stock = current_stock + ? WHERE id = ? AND (current_stock + ?) >= 0";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, addedQuantity);
            ps.setInt(2, id);
            ps.setInt(3, addedQuantity);

            boolean updated = ps.executeUpdate() > 0;
            if (updated) {
                checkAndTriggerReorder(id);
            }
            return updated;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    private void checkAndTriggerReorder(int id) {
        Medicine m = getMedicineById(id);
        if (m != null && m.getCurrentStock() <= m.getLowStockThreshold() && !m.isReordered()) {
            if (m.getSupplierEmail() != null && !m.getSupplierEmail().isEmpty()) {
                String subject = "LOW STOCK ALERT: " + m.getName();
                String body = "Automatic Reorder Request\n\n" +
                        "Medicine: " + m.getName() + "\n" +
                        "Current Stock: " + m.getCurrentStock() + "\n" +
                        "Threshold: " + m.getLowStockThreshold() + "\n\n" +
                        "Please supply restock batch for Batch No: " + m.getBatchNo();

                EmailService.sendEmail(m.getSupplierEmail(), subject, body);
                updateReorderStatus(id, true);
            }
        } else if (m != null && m.getCurrentStock() > m.getLowStockThreshold() && m.isReordered()) {
            // Reset reorder flag if stock is replenished
            updateReorderStatus(id, false);
        }
    }

    public Medicine getMedicineById(int id) {
        String sql = "SELECT * FROM medicines WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Medicine m = new Medicine();
                m.setId(rs.getInt("id"));
                m.setName(rs.getString("name"));
                m.setBatchNo(rs.getString("batch_no"));
                m.setExpiryDate(rs.getDate("expiry_date"));
                m.setCurrentStock(rs.getInt("current_stock"));
                m.setPricePerUnit(rs.getDouble("price_per_unit"));
                m.setLowStockThreshold(rs.getInt("low_stock_threshold"));
                m.setSupplierEmail(rs.getString("supplier_email"));
                m.setReordered(rs.getBoolean("is_reordered"));
                return m;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean updateReorderStatus(int id, boolean status) {
        String sql = "UPDATE medicines SET is_reordered = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBoolean(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteMedicine(int id) {
        String sql = "DELETE FROM medicines WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deletePatient(int id) {
        String sql = "DELETE FROM patients WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteStaff(int id) {
        String sql = "DELETE FROM staff WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteBed(int id) {
        String sql = "DELETE FROM beds WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean deleteBillingCatalogItem(int id) {
        String sql = "DELETE FROM billing_catalog WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- Bed Management ---

    public List<Bed> getAllBeds() {
        List<Bed> beds = new ArrayList<>();
        String sql = "SELECT * FROM beds";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Bed b = new Bed();
                b.setId(rs.getInt("id"));
                b.setBedNumber(rs.getString("bed_number"));
                b.setRoomNumber(rs.getString("room_number"));
                b.setFloor(rs.getInt("floor"));
                b.setType(rs.getString("type"));
                b.setPricePerDay(rs.getDouble("price_per_day"));
                b.setStatus(rs.getString("status"));
                beds.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return beds;
    }

    public List<Bed> getAvailableBeds() {
        List<Bed> beds = new ArrayList<>();
        String sql = "SELECT * FROM beds WHERE status = 'Available'";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Bed b = new Bed();
                b.setId(rs.getInt("id"));
                b.setBedNumber(rs.getString("bed_number"));
                b.setRoomNumber(rs.getString("room_number"));
                b.setFloor(rs.getInt("floor"));
                b.setType(rs.getString("type"));
                b.setPricePerDay(rs.getDouble("price_per_day"));
                b.setStatus(rs.getString("status"));
                beds.add(b);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return beds;
    }

    public boolean addBed(Bed b) {
        String sql = "INSERT INTO beds (bed_number, room_number, floor, type, price_per_day) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, b.getBedNumber());
            ps.setString(2, b.getRoomNumber());
            ps.setInt(3, b.getFloor());
            ps.setString(4, b.getType());
            ps.setDouble(5, b.getPricePerDay());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public boolean updateBedStatus(int bedId, String status) {
        String sql = "UPDATE beds SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, bedId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- Staff Management ---

    public List<Staff> getAllStaff() {
        List<Staff> staffList = new ArrayList<>();
        String sql = "SELECT * FROM staff";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Staff s = new Staff();
                s.setId(rs.getInt("id"));
                s.setName(rs.getString("name"));
                s.setRole(rs.getString("role"));
                s.setPhone(rs.getString("phone"));
                s.setAssignedToType(rs.getString("assigned_to_type"));
                s.setAssignedToId(rs.getInt("assigned_to_id"));
                staffList.add(s);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return staffList;
    }

    public boolean addStaff(Staff s) {
        String sql = "INSERT INTO staff (name, role, phone, assigned_to_type, assigned_to_id) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, s.getName());
            ps.setString(2, s.getRole());
            ps.setString(3, s.getPhone());
            ps.setString(4, s.getAssignedToType());
            ps.setInt(5, s.getAssignedToId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- IPD Admission Management ---

    public boolean admitPatient(Admission a) {
        String sql = "INSERT INTO admissions (patient_id, bed_id, doctor_id, insurance_name, deposit_amount) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            try (PreparedStatement ps = conn.prepareStatement(sql)) {
                ps.setInt(1, a.getPatientId());
                ps.setInt(2, a.getBedId());
                ps.setInt(3, a.getDoctorId());
                ps.setString(4, a.getInsuranceName());
                ps.setDouble(5, a.getDepositAmount());

                if (ps.executeUpdate() > 0) {
                    // Mark bed as occupied
                    String updateBedSql = "UPDATE beds SET status = 'Occupied' WHERE id = ?";
                    try (PreparedStatement uPs = conn.prepareStatement(updateBedSql)) {
                        uPs.setInt(1, a.getBedId());
                        uPs.executeUpdate();
                    }
                    conn.commit();
                    return true;
                }
                conn.rollback();
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public List<Admission> getAllAdmissions() {
        List<Admission> list = new ArrayList<>();
        String sql = "SELECT a.*, p.full_name as patient_name, b.bed_number, b.price_per_day, u.full_name as doctor_name "
                +
                "FROM admissions a " +
                "JOIN patients p ON a.patient_id = p.id " +
                "JOIN beds b ON a.bed_id = b.id " +
                "JOIN users u ON a.doctor_id = u.id ORDER BY a.admission_date DESC";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                Admission a = new Admission();
                a.setId(rs.getInt("id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setBedId(rs.getInt("bed_id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setAdmissionDate(rs.getTimestamp("admission_date"));
                a.setDischargeDate(rs.getTimestamp("discharge_date"));
                a.setInsuranceName(rs.getString("insurance_name"));
                a.setDepositAmount(rs.getDouble("deposit_amount"));
                a.setDischargeSummary(rs.getString("discharge_summary"));
                a.setStatus(rs.getString("status"));
                a.setPatientName(rs.getString("patient_name"));
                a.setBedNumber(rs.getString("bed_number"));
                a.setDoctorName(rs.getString("doctor_name"));
                a.setPricePerDay(rs.getDouble("price_per_day"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean dischargePatient(int admissionId, String summary) {
        String findAdmissionSql = "SELECT bed_id FROM admissions WHERE id = ?";
        try (Connection conn = DBConnection.getConnection()) {
            conn.setAutoCommit(false);
            int bedId = -1;
            try (PreparedStatement ps = conn.prepareStatement(findAdmissionSql)) {
                ps.setInt(1, admissionId);
                ResultSet rs = ps.executeQuery();
                if (rs.next())
                    bedId = rs.getInt("bed_id");
            }

            if (bedId != -1) {
                String dischargeSql = "UPDATE admissions SET status = 'Discharged', discharge_date = CURRENT_TIMESTAMP, discharge_summary = ? WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(dischargeSql)) {
                    ps.setString(1, summary);
                    ps.setInt(2, admissionId);
                    ps.executeUpdate();
                }

                String updateBedSql = "UPDATE beds SET status = 'Available' WHERE id = ?";
                try (PreparedStatement ps = conn.prepareStatement(updateBedSql)) {
                    ps.setInt(1, bedId);
                    ps.executeUpdate();
                }
                conn.commit();
                return true;
            }
            conn.rollback();
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return false;
    }

    public HospitalDAO() {
        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            autoPatchSchema();
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
    }

    private void autoPatchSchema() {
        String createTableSql = "CREATE TABLE IF NOT EXISTS billing_details ("
                + "id INT AUTO_INCREMENT PRIMARY KEY,"
                + "billing_id INT NOT NULL,"
                + "item_name VARCHAR(255) NOT NULL,"
                + "amount DECIMAL(10, 2) NOT NULL,"
                + "FOREIGN KEY (billing_id) REFERENCES billing (id) ON DELETE CASCADE"
                + ")";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(createTableSql)) {
            ps.executeUpdate();
            System.out.println("Schema auto-patch verified for billing_details.");
        } catch (Exception e) {
            System.err.println("Schema auto-patch failed: " + e.getMessage());
        }
    }

    // --- Billing Catalog ---

    public List<BillingCatalog> getBillingCatalog() {
        List<BillingCatalog> catalog = new ArrayList<>();
        String sql = "SELECT * FROM billing_catalog ORDER BY category, item_name";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                BillingCatalog item = new BillingCatalog();
                item.setId(rs.getInt("id"));
                item.setItemName(rs.getString("item_name"));
                item.setCategory(rs.getString("category"));
                item.setPrice(rs.getDouble("price"));
                catalog.add(item);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return catalog;
    }

    public boolean addBillingItem(BillingCatalog item) {
        String sql = "INSERT INTO billing_catalog (item_name, category, price) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, item.getItemName());
            ps.setString(2, item.getCategory());
            ps.setDouble(3, item.getPrice());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    // --- Patient Reports ---

    public boolean addPatientReport(PatientReport report) {
        String sql = "INSERT INTO patient_reports (patient_id, admission_id, appointment_id, test_id, findings, status) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, report.getPatientId());
            if (report.getAdmissionId() > 0)
                ps.setInt(2, report.getAdmissionId());
            else
                ps.setNull(2, Types.INTEGER);
            if (report.getAppointmentId() > 0)
                ps.setInt(3, report.getAppointmentId());
            else
                ps.setNull(3, Types.INTEGER);
            ps.setInt(4, report.getTestId());
            ps.setString(5, report.getFindings());
            ps.setString(6, "Pending");
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<PatientReport> getReportsByPatient(int patientId) {
        List<PatientReport> list = new ArrayList<>();
        String sql = "SELECT pr.*, bc.item_name FROM patient_reports pr JOIN billing_catalog bc ON pr.test_id = bc.id WHERE pr.patient_id = ? ORDER BY pr.test_date DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PatientReport r = new PatientReport();
                r.setId(rs.getInt("id"));
                r.setTestId(rs.getInt("test_id"));
                r.setFindings(rs.getString("findings"));
                r.setTestDate(rs.getTimestamp("test_date"));
                r.setStatus(rs.getString("status"));
                r.setTestName(rs.getString("item_name"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PatientReport> getAllReports() {
        List<PatientReport> list = new ArrayList<>();
        String sql = "SELECT pr.*, bc.item_name, p.full_name FROM patient_reports pr " +
                "JOIN billing_catalog bc ON pr.test_id = bc.id " +
                "JOIN patients p ON pr.patient_id = p.id ORDER BY pr.test_date DESC";
        try (Connection conn = DBConnection.getConnection();
                Statement stmt = conn.createStatement();
                ResultSet rs = stmt.executeQuery(sql)) {
            while (rs.next()) {
                PatientReport r = new PatientReport();
                r.setId(rs.getInt("id"));
                r.setPatientId(rs.getInt("patient_id"));
                r.setTestId(rs.getInt("test_id"));
                r.setFindings(rs.getString("findings"));
                r.setTestDate(rs.getTimestamp("test_date"));
                r.setStatus(rs.getString("status"));
                r.setTestName(rs.getString("item_name"));
                r.setPatientName(rs.getString("full_name"));
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PatientReport> getReportsByAdmissionId(int admissionId) {
        List<PatientReport> list = new ArrayList<>();
        String sql = "SELECT pr.*, bc.item_name, bc.price FROM patient_reports pr JOIN billing_catalog bc ON pr.test_id = bc.id WHERE pr.admission_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, admissionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PatientReport r = new PatientReport();
                r.setId(rs.getInt("id"));
                r.setTestId(rs.getInt("test_id"));
                r.setFindings(rs.getString("findings"));
                r.setTestDate(rs.getTimestamp("test_date"));
                r.setStatus(rs.getString("status"));
                r.setTestName(rs.getString("item_name"));
                // We'll use findings or testName to carry price info for billing if needed
                list.add(r);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Admission getAdmissionById(int id) {
        String sql = "SELECT a.*, p.full_name as patient_name, b.bed_number, b.price_per_day, u.full_name as doctor_name "
                +
                "FROM admissions a JOIN patients p ON a.patient_id = p.id JOIN beds b ON a.bed_id = b.id JOIN users u ON a.doctor_id = u.id WHERE a.id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Admission a = new Admission();
                a.setId(rs.getInt("id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setBedId(rs.getInt("bed_id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setAdmissionDate(rs.getTimestamp("admission_date"));
                a.setDischargeDate(rs.getTimestamp("discharge_date"));
                a.setInsuranceName(rs.getString("insurance_name"));
                a.setDepositAmount(rs.getDouble("deposit_amount"));
                a.setDischargeSummary(rs.getString("discharge_summary"));
                a.setStatus(rs.getString("status"));
                a.setPatientName(rs.getString("patient_name"));
                a.setBedNumber(rs.getString("bed_number"));
                a.setDoctorName(rs.getString("doctor_name"));
                return a;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Medicine> getPrescribedMedicinesByAdmissionId(int admissionId) {
        List<Medicine> list = new ArrayList<>();
        String sql = "SELECT m.*, pd.quantity as prescribed_qty FROM medicines m " +
                "JOIN prescription_details pd ON m.id = pd.medicine_id " +
                "JOIN prescriptions p ON pd.prescription_id = p.id " +
                "JOIN admissions a ON p.patient_id = a.patient_id " +
                "WHERE a.id = ? AND a.status = 'Admitted'";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, admissionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Medicine m = new Medicine();
                m.setId(rs.getInt("id"));
                m.setName(rs.getString("name"));
                m.setPricePerUnit(rs.getDouble("price_per_unit"));
                m.setCurrentStock(rs.getInt("prescribed_qty"));
                list.add(m);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Appointment> getAppointmentsByPatient(int patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, u.full_name as doctor_name FROM appointments a JOIN users u ON a.doctor_id = u.id WHERE a.patient_id = ? ORDER BY a.appointment_time DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setId(rs.getInt("id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setAppointmentTime(rs.getTimestamp("appointment_time"));
                a.setAdminNotes(rs.getString("admin_notes"));
                a.setStatus(rs.getString("status"));
                a.setDoctorName(rs.getString("doctor_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Admission> getAdmissionsByPatient(int patientId) {
        List<Admission> list = new ArrayList<>();
        String sql = "SELECT a.*, p.full_name as patient_name, b.bed_number, u.full_name as doctor_name " +
                "FROM admissions a JOIN patients p ON a.patient_id = p.id JOIN beds b ON a.bed_id = b.id JOIN users u ON a.doctor_id = u.id WHERE a.patient_id = ? ORDER BY a.admission_date DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Admission a = new Admission();
                a.setId(rs.getInt("id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setBedId(rs.getInt("bed_id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setAdmissionDate(rs.getTimestamp("admission_date"));
                a.setDischargeDate(rs.getTimestamp("discharge_date"));
                a.setInsuranceName(rs.getString("insurance_name"));
                a.setDepositAmount(rs.getDouble("deposit_amount"));
                a.setDischargeSummary(rs.getString("discharge_summary"));
                a.setStatus(rs.getString("status"));
                a.setPatientName(rs.getString("patient_name"));
                a.setBedNumber(rs.getString("bed_number"));
                a.setDoctorName(rs.getString("doctor_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean updateAppointmentStatus(int id, String status) {
        String sql = "UPDATE appointments SET status = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setInt(2, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public List<Prescription> getPrescriptionsByAppointment(int appointmentId) {
        List<Prescription> list = new ArrayList<>();
        String sql = "SELECT * FROM prescriptions WHERE appointment_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Prescription p = new Prescription();
                p.setId(rs.getInt("id"));
                p.setAppointmentId(rs.getInt("appointment_id"));
                p.setDoctorId(rs.getInt("doctor_id"));
                p.setPatientId(rs.getInt("patient_id"));
                p.setDiagnosis(rs.getString("diagnosis"));
                p.setPrescribedDate(rs.getTimestamp("prescribed_date"));
                list.add(p);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<PrescriptionDetail> getPrescriptionDetails(int prescriptionId) {
        List<PrescriptionDetail> list = new ArrayList<>();
        String sql = "SELECT pd.*, m.name as medicine_name FROM prescription_details pd JOIN medicines m ON pd.medicine_id = m.id WHERE pd.prescription_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, prescriptionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PrescriptionDetail pd = new PrescriptionDetail();
                pd.setId(rs.getInt("id"));
                pd.setPrescriptionId(rs.getInt("prescription_id"));
                pd.setMedicineId(rs.getInt("medicine_id"));
                pd.setDosageMorning(rs.getString("dosage_morning"));
                pd.setDosageNoon(rs.getString("dosage_noon"));
                pd.setDosageEvening(rs.getString("dosage_evening"));
                pd.setDosageNight(rs.getString("dosage_night"));
                pd.setDuration(rs.getString("duration"));
                pd.setQuantity(rs.getInt("quantity"));
                pd.setMedicineName(rs.getString("medicine_name"));
                list.add(pd);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public Billing getBillByAppointment(int appointmentId) {
        String sql = "SELECT b.*, p.full_name as patient_name FROM billing b JOIN patients p ON b.patient_id = p.id WHERE b.appointment_id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, appointmentId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Billing b = new Billing();
                b.setId(rs.getInt("id"));
                b.setPatientId(rs.getInt("patient_id"));
                b.setAppointmentId(rs.getInt("appointment_id"));
                b.setTotalAmount(rs.getDouble("total_amount"));
                b.setPaidAmount(rs.getDouble("paid_amount"));
                b.setPaymentStatus(rs.getString("payment_status"));
                b.setBillingDate(rs.getTimestamp("billing_date"));
                b.setPatientName(rs.getString("patient_name"));
                return b;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public int generateBill(Billing bill) {
        String sql = "INSERT INTO billing (patient_id, admission_id, appointment_id, total_amount, payment_status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, bill.getPatientId());
            if (bill.getAdmissionId() > 0)
                ps.setInt(2, bill.getAdmissionId());
            else
                ps.setNull(2, java.sql.Types.INTEGER);
            if (bill.getAppointmentId() > 0)
                ps.setInt(3, bill.getAppointmentId());
            else
                ps.setNull(3, java.sql.Types.INTEGER);
            ps.setDouble(4, bill.getTotalAmount());
            ps.setString(5, bill.getPaymentStatus());

            if (ps.executeUpdate() > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next())
                    return rs.getInt(1);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

    public boolean addBillingDetail(BillingDetail detail) {
        String sql = "INSERT INTO billing_details (billing_id, item_name, amount) VALUES (?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, detail.getBillingId());
            ps.setString(2, detail.getItemName());
            ps.setDouble(3, detail.getAmount());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public BillingCatalog getBillingCatalogItemById(int id) {
        String sql = "SELECT * FROM billing_catalog WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                BillingCatalog b = new BillingCatalog();
                b.setId(rs.getInt("id"));
                b.setItemName(rs.getString("item_name"));
                b.setCategory(rs.getString("category"));
                b.setPrice(rs.getDouble("price"));
                return b;
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Appointment> getAppointmentsByPatientId(int patientId) {
        List<Appointment> list = new ArrayList<>();
        String sql = "SELECT a.*, d.full_name as doctor_name FROM appointments a JOIN users d ON a.doctor_id = d.id WHERE a.patient_id = ? ORDER BY a.appointment_time DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Appointment a = new Appointment();
                a.setId(rs.getInt("id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setAppointmentTime(rs.getTimestamp("appointment_time"));
                a.setStatus(rs.getString("status"));
                a.setAdminNotes(rs.getString("admin_notes"));
                a.setDoctorName(rs.getString("doctor_name"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public List<Admission> getAdmissionsByPatientId(int patientId) {
        List<Admission> list = new ArrayList<>();
        String sql = "SELECT * FROM admissions WHERE patient_id = ? ORDER BY admission_date DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Admission a = new Admission();
                a.setId(rs.getInt("id"));
                a.setPatientId(rs.getInt("patient_id"));
                a.setBedId(rs.getInt("bed_id"));
                a.setDoctorId(rs.getInt("doctor_id"));
                a.setAdmissionDate(rs.getTimestamp("admission_date"));
                a.setDischargeDate(rs.getTimestamp("discharge_date"));
                a.setInsuranceName(rs.getString("insurance_name"));
                a.setDepositAmount(rs.getDouble("deposit_amount"));
                a.setStatus(rs.getString("status"));
                a.setDischargeSummary(rs.getString("discharge_summary"));
                list.add(a);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    // asd
    public List<PatientReport> getReportsByPatientId(int patientId) {
        List<PatientReport> list = new ArrayList<>();
        String sql = "SELECT pr.*, b.item_name as test_name FROM patient_reports pr JOIN billing_catalog b ON pr.test_id = b.id WHERE pr.patient_id = ? ORDER BY pr.test_date DESC";
        try (Connection conn = DBConnection.getConnection();
                PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, patientId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                PatientReport pr = new PatientReport();
                pr.setId(rs.getInt("id"));
                pr.setPatientId(rs.getInt("patient_id"));
                pr.setAdmissionId(rs.getInt("admission_id"));
                pr.setAppointmentId(rs.getInt("appointment_id"));
                pr.setTestId(rs.getInt("test_id"));
                pr.setFindings(rs.getString("findings"));
                pr.setTestDate(rs.getTimestamp("test_date"));
                pr.setTestName(rs.getString("test_name"));
                list.add(pr);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }
}
