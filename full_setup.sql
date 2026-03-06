-- CareConnect Consolidated Database Setup
-- This script creates the database, all tables, and inserts initial seed data.

CREATE DATABASE IF NOT EXISTS hospital;

USE hospital;

CREATE TABLE IF NOT EXISTS users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL,
    role ENUM('ADMIN', 'DOCTOR') NOT NULL,
    full_name VARCHAR(100) NOT NULL,
    specialization VARCHAR(100),
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE IF NOT EXISTS patients (
    id INT AUTO_INCREMENT PRIMARY KEY,
    full_name VARCHAR(100) NOT NULL,
    email VARCHAR(100),
    phone VARCHAR(20),
    dob DATE,
    gender ENUM('Male', 'Female', 'Other'),
    blood_group VARCHAR(5),
    weight DECIMAL(5, 2),
    height DECIMAL(5, 2),
    address TEXT,
    emergency_contact_name VARCHAR(100),
    emergency_contact_phone VARCHAR(20),
    allergies TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Appointments
CREATE TABLE IF NOT EXISTS appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    patient_id INT NOT NULL,
    appointment_time DATETIME NOT NULL,
    admin_notes TEXT,
    status VARCHAR(50) DEFAULT 'SCHEDULED',
    fee DECIMAL(10, 2) DEFAULT 500.00, -- Default Consultation Fee in INR
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (doctor_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES patients (id) ON DELETE CASCADE
);

-- Beds (Unified Infrastructure)
CREATE TABLE IF NOT EXISTS beds (
    id INT AUTO_INCREMENT PRIMARY KEY,
    bed_number VARCHAR(20) NOT NULL UNIQUE,
    room_number VARCHAR(20) NOT NULL,
    floor INT NOT NULL,
    type ENUM(
        'Common',
        'Semi-Special',
        'Special',
        'ICU',
        'Premium'
    ) NOT NULL,
    price_per_day DECIMAL(10, 2) NOT NULL,
    status ENUM(
        'Available',
        'Occupied',
        'Maintenance'
    ) DEFAULT 'Available'
);

-- Staff (Non-Login Directory)
CREATE TABLE IF NOT EXISTS staff (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    role ENUM('Nurse', 'Janitor', 'Peon') NOT NULL,
    phone VARCHAR(20),
    assigned_to_type ENUM('Floor', 'Bed', 'Doctor') DEFAULT 'Floor',
    assigned_to_id INT, -- Links to Floor Number, Bed ID, or Doctor User ID
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Inpatient Admissions (IPD)
CREATE TABLE IF NOT EXISTS admissions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    bed_id INT NOT NULL,
    doctor_id INT NOT NULL, -- Doctor in charge
    admission_date DATETIME DEFAULT CURRENT_TIMESTAMP,
    discharge_date DATETIME,
    insurance_name VARCHAR(100),
    deposit_amount DECIMAL(10, 2) DEFAULT 0.00,
    discharge_summary TEXT,
    status ENUM('Admitted', 'Discharged') DEFAULT 'Admitted',
    FOREIGN KEY (patient_id) REFERENCES patients (id) ON DELETE CASCADE,
    FOREIGN KEY (bed_id) REFERENCES beds (id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES users (id) ON DELETE CASCADE
);

-- Service & Billing Catalog
CREATE TABLE IF NOT EXISTS billing_catalog (
    id INT AUTO_INCREMENT PRIMARY KEY,
    item_name VARCHAR(100) NOT NULL,
    category ENUM(
        'Test',
        'Procedure',
        'Equipment',
        'Service'
    ) NOT NULL,
    price DECIMAL(10, 2) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Diagnostic Lab Reports
CREATE TABLE IF NOT EXISTS patient_reports (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    admission_id INT, -- Optional link to IPD stay
    appointment_id INT, -- Optional link to OPD visit
    test_id INT NOT NULL,
    findings TEXT,
    test_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    status ENUM('Pending', 'Completed') DEFAULT 'Pending',
    FOREIGN KEY (patient_id) REFERENCES patients (id) ON DELETE CASCADE,
    FOREIGN KEY (admission_id) REFERENCES admissions (id) ON DELETE SET NULL,
    FOREIGN KEY (appointment_id) REFERENCES appointments (id) ON DELETE SET NULL,
    FOREIGN KEY (test_id) REFERENCES billing_catalog (id) ON DELETE CASCADE
);

-- Pharmacy Inventory
CREATE TABLE IF NOT EXISTS medicines (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    batch_no VARCHAR(100),
    expiry_date DATE,
    current_stock INT DEFAULT 0,
    price_per_unit DECIMAL(10, 2),
    low_stock_threshold INT DEFAULT 10,
    supplier_email VARCHAR(100),
    is_reordered BOOLEAN DEFAULT FALSE,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Final Billing
CREATE TABLE IF NOT EXISTS billing (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    admission_id INT,
    appointment_id INT, -- Link to OPD visit
    total_amount DECIMAL(10, 2) NOT NULL,
    paid_amount DECIMAL(10, 2) DEFAULT 0.00,
    payment_status ENUM(
        'Pending',
        'Paid',
        'Partially Paid'
    ) DEFAULT 'Pending',
    billing_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES patients (id) ON DELETE CASCADE,
    FOREIGN KEY (admission_id) REFERENCES admissions (id) ON DELETE SET NULL,
    FOREIGN KEY (appointment_id) REFERENCES appointments (id) ON DELETE SET NULL
);

CREATE TABLE IF NOT EXISTS billing_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    billing_id INT NOT NULL,
    item_name VARCHAR(255) NOT NULL,
    amount DECIMAL(10, 2) NOT NULL,
    FOREIGN KEY (billing_id) REFERENCES billing (id) ON DELETE CASCADE
);

-- Clinical Prescriptions (OPD)
CREATE TABLE IF NOT EXISTS prescriptions (
    id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT,
    doctor_id INT,
    patient_id INT,
    diagnosis TEXT,
    prescribed_date TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES appointments (id) ON DELETE SET NULL,
    FOREIGN KEY (doctor_id) REFERENCES users (id) ON DELETE CASCADE,
    FOREIGN KEY (patient_id) REFERENCES patients (id) ON DELETE CASCADE
);

CREATE TABLE IF NOT EXISTS prescription_details (
    id INT AUTO_INCREMENT PRIMARY KEY,
    prescription_id INT,
    medicine_id INT,
    dosage_morning VARCHAR(50) DEFAULT '0',
    dosage_noon VARCHAR(50) DEFAULT '0',
    dosage_evening VARCHAR(50) DEFAULT '0',
    dosage_night VARCHAR(50) DEFAULT '0',
    duration VARCHAR(100),
    quantity INT,
    FOREIGN KEY (prescription_id) REFERENCES prescriptions (id) ON DELETE CASCADE,
    FOREIGN KEY (medicine_id) REFERENCES medicines (id) ON DELETE CASCADE
);

-- ==========================================
-- 3. SEED DATA (Indian Pricing - INR)
-- ==========================================

INSERT IGNORE INTO
    users (
        email,
        password,
        role,
        full_name,
        specialization
    )
VALUES (
        'admin@hospital.com',
        'admin',
        'ADMIN',
        'Hospital Administrator',
        NULL
    ),
    (
        'sahilodedra26@gmail.com',
        '123',
        'DOCTOR',
        'Sahil Odedra',
        'Cardiology'
    ),
    (
        'doctor@hospital.com',
        'doctor',
        'DOCTOR',
        'Sharma',
        'General Medicine'
    );

-- Sample Beds
INSERT IGNORE INTO
    beds (
        bed_number,
        room_number,
        floor,
        type,
        price_per_day,
        status
    )
VALUES (
        '101A',
        '101',
        1,
        'Semi-Special',
        1500.00,
        'Available'
    ),
    (
        '101B',
        '101',
        1,
        'Semi-Special',
        1500.00,
        'Available'
    ),
    (
        '201',
        '201',
        2,
        'Special',
        3500.00,
        'Available'
    ),
    (
        '301',
        '301',
        3,
        'ICU',
        8000.00,
        'Available'
    ),
    (
        'C-1',
        'C-WARD',
        1,
        'Common',
        500.00,
        'Available'
    ),
    (
        'C-2',
        'C-WARD',
        1,
        'Common',
        500.00,
        'Available'
    ),
    (
        'C-3',
        'C-WARD',
        1,
        'Common',
        500.00,
        'Available'
    ),
    (
        'C-4',
        'C-WARD',
        1,
        'Common',
        500.00,
        'Available'
    ),
    (
        'C-5',
        'C-WARD',
        1,
        'Common',
        500.00,
        'Available'
    );

-- Billing Catalog (Tests & Services)
INSERT IGNORE INTO
    billing_catalog (item_name, category, price)
VALUES ('X-Ray Chest', 'Test', 800.00),
    (
        'Full Blood Count (CBC)',
        'Test',
        450.00
    ),
    (
        'Lipid Profile',
        'Test',
        1200.00
    ),
    ('ECG', 'Test', 500.00),
    (
        'Oxygen Support (Per Hour)',
        'Equipment',
        200.00
    ),
    (
        'Ventilator Support (Per Day)',
        'Equipment',
        5000.00
    ),
    (
        'Wound Dressing',
        'Service',
        300.00
    ),
    (
        'Nursing Care (Per Day)',
        'Service',
        1000.00
    );

-- Medicines Stock
INSERT IGNORE INTO
    medicines (
        name,
        batch_no,
        expiry_date,
        current_stock,
        price_per_unit,
        low_stock_threshold,
        supplier_email
    )
VALUES (
        'Paracetamol 500mg',
        'BAT-001',
        '2025-12-31',
        1000,
        5.00,
        100,
        'supplier@meds.in'
    ),
    (
        'Amoxicillin 250mg',
        'BAT-002',
        '2024-10-15',
        500,
        15.00,
        50,
        'supplier@meds.in'
    ),
    (
        'Insulin Injection',
        'BAT-003',
        '2025-06-20',
        80,
        450.00,
        20,
        'pharma@supply.in'
    );

-- Staff Registry
INSERT IGNORE INTO
    staff (
        name,
        role,
        phone,
        assigned_to_type,
        assigned_to_id
    )
VALUES (
        'Sunita Devi',
        'Nurse',
        '9876543210',
        'Floor',
        1
    ),
    (
        'Rahul Kumar',
        'Janitor',
        '9823456789',
        'Floor',
        1
    ),
    (
        'Amit Singh',
        'Peon',
        '9812345678',
        'Doctor',
        2
    );

SELECT 'CareConnect HMS Database Setup Complete!' AS Result;