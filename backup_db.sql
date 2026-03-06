-- CareConnect Database Backup Utility
-- This file provides instructions and helper queries for manual backups.

-- 1. RECOMMENDED: RUN FROM COMMAND LINE (DOCKER/LOCAL)
-- Use this command to create a full compressed backup:
-- mysqldump -u root -p hospital > hospital_backup_$(date +%F).sql

-- 2. MANUAL EXPORT (FOR CRITICAL TABLES)
-- Run these queries to export data into CSV format (if SECURE_FILE_PRIV is enabled)

/*
SELECT * FROM patients
INTO OUTFILE '/var/lib/mysql-files/patients_backup.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';

SELECT * FROM billing
INTO OUTFILE '/var/lib/mysql-files/billing_backup.csv'
FIELDS TERMINATED BY ','
ENCLOSED BY '"'
LINES TERMINATED BY '\n';
*/

-- 3. QUICK CLONE (SAFETY COPY WITHIN DATABASE)
-- Run these to create temporary safety copies before major structure changes

CREATE TABLE IF NOT EXISTS patients_backup_temp AS
SELECT *
FROM patients;

CREATE TABLE IF NOT EXISTS admissions_backup_temp AS
SELECT *
SELECT *
FROM admissions;

CREATE TABLE IF NOT EXISTS billing_backup_temp AS
SELECT *
SELECT *
FROM billing;

-- To restore from these temps:
-- INSERT INTO patients SELECT * FROM patients_backup_temp WHERE id NOT IN (SELECT id FROM patients);

SELECT 'Backup procedures documented at ' + NOW() as Status;