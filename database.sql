CREATE DATABASE doctor_appointment;

USE doctor_appointment;

-- Users table (patients, doctors, admin)
CREATE TABLE Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    email VARCHAR(100) UNIQUE NOT NULL,
    password VARCHAR(255) NOT NULL,
    role ENUM('patient', 'doctor', 'admin') NOT NULL
);

-- Doctors table (linked to Users)
CREATE TABLE Doctors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    specialization VARCHAR(100) NOT NULL,
    bio TEXT,
    approval_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending',
    FOREIGN KEY (user_id) REFERENCES Users(id)
);

-- Doctor available slots
CREATE TABLE Doctor_Schedule (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,
    day VARCHAR(20) NOT NULL,
    start_time TIME NOT NULL,
    end_time TIME NOT NULL,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(id)
);

-- Appointments
CREATE TABLE Appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,
    doctor_id INT NOT NULL,
    date DATE NOT NULL,
    time TIME NOT NULL,
    status ENUM('booked', 'completed', 'cancelled') DEFAULT 'booked',
    FOREIGN KEY (patient_id) REFERENCES Users(id),
    FOREIGN KEY (doctor_id) REFERENCES Doctors(id)
);

SELECT id, name, email, password, role FROM Users;

-- Step 1: Insert 5 doctor users
INSERT INTO Users (name, email, password, role)
VALUES
('Dr. Alice Sharma', 'alice@example.com', 'password123', 'doctor'),
('Dr. Ravi Mehta', 'ravi@example.com', 'password123', 'doctor'),
('Dr. Sneha Kapoor', 'sneha@example.com', 'password123', 'doctor'),
('Dr. Arjun Singh', 'arjun@example.com', 'password123', 'doctor'),
('Dr. Neha Desai', 'neha@example.com', 'password123', 'doctor');

-- Step 2: Insert corresponding doctor profiles
-- Assuming auto-increment IDs are 1 through 5 (adjust if needed)
INSERT INTO Doctors (user_id, specialization, bio, approval_status)
VALUES
(1, 'Cardiology', 'Experienced cardiologist with 10 years of practice.', 'approved'),
(2, 'Neurology', 'Specialist in neurological disorders.', 'approved'),
(3, 'Pediatrics', 'Child healthcare expert.', 'approved'),
(4, 'Orthopedics', 'Bone and joint specialist.', 'approved'),
(5, 'Dermatology', 'Skin care and treatment expert.', 'approved');


CREATE TABLE Payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,
    stripe_payment_id VARCHAR(255) NOT NULL,
    amount INT NOT NULL,  -- in cents
    status VARCHAR(50) NOT NULL,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(id)
);

ALTER TABLE Payments MODIFY stripe_payment_id VARCHAR(255) NOT NULL;
SELECT * FROM Payments;
SELECT
    Payments.id AS payment_id,
    Payments.stripe_payment_id,
    Payments.amount,
    Payments.status,
    Payments.created_at,
    Appointments.date,
    Appointments.time,
    Appointments.status AS appointment_status
FROM Payments
JOIN Appointments ON Payments.appointment_id = Appointments.id;

SELECT * FROM Appointments;
SELECT * FROM Payments;

ALTER TABLE Appointments
ADD COLUMN consultation_status ENUM('pending', 'active', 'completed') DEFAULT 'pending',
ADD COLUMN room_id VARCHAR(255) NULL;


SELECT consultation_status, room_id FROM Appointments;

ALTER TABLE Appointments
ADD COLUMN consultation_status VARCHAR(20) DEFAULT 'pending',
ADD COLUMN room_id VARCHAR(255);

SELECT a.id, a.room_id, u.name as doctor
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.id
JOIN Users u ON d.user_id = u.id;

ALTER TABLE Appointments
ADD COLUMN room_id VARCHAR(255) NULL,
ADD COLUMN consultation_status ENUM('pending', 'active', 'completed') DEFAULT 'pending';


ALTER TABLE Appointments MODIFY COLUMN time TIME;

SELECT u.name, u.email, d.specialization, d.bio, d.approval_status
FROM Users u
JOIN Doctors d ON u.id = d.user_id
WHERE u.name = 'Dr. Alice Sharma';


SELECT u.name, u.email, d.specialization, d.bio, d.approval_status
FROM Users u
JOIN Doctors d ON u.id = d.user_id
WHERE u.email = 'ravi@example.com';

SELECT * FROM Users;

