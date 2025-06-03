-- Create the database for our doctor appointment system
CREATE DATABASE IF NOT EXISTS doctor_appointment;
USE doctor_appointment;

-- Users table to store all kinds of users: patients, doctors, and admins
CREATE TABLE IF NOT EXISTS Users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,             -- Person's full name
    email VARCHAR(100) UNIQUE NOT NULL,     -- Email must be unique
    password VARCHAR(255) NOT NULL,         -- We'll store hashed passwords here
    role ENUM('patient', 'doctor', 'admin') NOT NULL, -- Role type
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP     -- When the user was added
);

-- Doctors table, linked to the Users table
CREATE TABLE IF NOT EXISTS Doctors (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,                               -- Links to Users table
    specialization VARCHAR(100) NOT NULL,               -- Doctor's field of work
    bio TEXT,                                            -- A little about the doctor
    approval_status ENUM('pending', 'approved', 'rejected') DEFAULT 'pending', -- Admin approval
    FOREIGN KEY (user_id) REFERENCES Users(id) ON DELETE CASCADE,
    UNIQUE (user_id)   -- Make sure one user only has one doctor profile
);

-- This table stores the available slots of doctors
CREATE TABLE IF NOT EXISTS Doctor_Schedule (
    id INT AUTO_INCREMENT PRIMARY KEY,
    doctor_id INT NOT NULL,                             -- Linked to the doctor
    day_of_week ENUM('Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') NOT NULL, -- What day
    start_time TIME NOT NULL,                          -- When they start
    end_time TIME NOT NULL,                            -- When they finish
    FOREIGN KEY (doctor_id) REFERENCES Doctors(id) ON DELETE CASCADE
);

-- Appointments table to keep track of bookings between patients and doctors
CREATE TABLE IF NOT EXISTS Appointments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    patient_id INT NOT NULL,                             -- Who booked the appointment
    doctor_id INT NOT NULL,                              -- Which doctor
    appointment_date DATE NOT NULL,
    appointment_time TIME NOT NULL,
    status ENUM('booked', 'completed', 'cancelled') DEFAULT 'booked', -- Overall status
    consultation_status ENUM('pending', 'active', 'completed') DEFAULT 'pending', -- For live consults
    room_id VARCHAR(255),                                -- Used for video call room maybe
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (patient_id) REFERENCES Users(id) ON DELETE CASCADE,
    FOREIGN KEY (doctor_id) REFERENCES Doctors(id) ON DELETE CASCADE
);

-- Payments table to keep track of transactions made for appointments
CREATE TABLE IF NOT EXISTS Payments (
    id INT AUTO_INCREMENT PRIMARY KEY,
    appointment_id INT NOT NULL,                         -- Linked to a specific appointment
    stripe_payment_id VARCHAR(255) NOT NULL,             -- From Stripe
    amount INT NOT NULL,                                 -- Stored in cents (e.g., 1000 = ₹10.00)
    status VARCHAR(50) NOT NULL,                         -- 'paid', 'failed', etc.
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (appointment_id) REFERENCES Appointments(id) ON DELETE CASCADE
);

-- Let's insert 5 doctor users
INSERT INTO Users (name, email, password, role) VALUES
('Dr. Alice Sharma', 'alice@example.com', 'password123', 'doctor'),
('Dr. Ravi Mehta', 'ravi@example.com', 'password123', 'doctor'),
('Dr. Sneha Kapoor', 'sneha@example.com', 'password123', 'doctor'),
('Dr. Arjun Singh', 'arjun@example.com', 'password123', 'doctor'),
('Dr. Neha Desai', 'neha@example.com', 'password123', 'doctor');

-- Now add their doctor profiles (make sure IDs match above insert)
INSERT INTO Doctors (user_id, specialization, bio, approval_status) VALUES
(1, 'Cardiology', 'Experienced cardiologist with 10 years of practice.', 'approved'),
(2, 'Neurology', 'Specialist in neurological disorders.', 'approved'),
(3, 'Pediatrics', 'Child healthcare expert.', 'approved'),
(4, 'Orthopedics', 'Bone and joint specialist.', 'approved'),
(5, 'Dermatology', 'Skin care and treatment expert.', 'approved');

-- Quick check: view all users
SELECT id, name, email, password, role FROM Users;

-- Check if the doctor got added properly
SELECT u.name, u.email, d.specialization, d.bio, d.approval_status
FROM Users u
JOIN Doctors d ON u.id = d.user_id;

-- Let’s check a specific doctor’s details
SELECT u.name, u.email, d.specialization, d.bio, d.approval_status
FROM Users u
JOIN Doctors d ON u.id = d.user_id
WHERE u.email = 'ravi@example.com';

-- See all appointments
SELECT * FROM Appointments;

-- See all payments
SELECT * FROM Payments;

-- Join payments with their appointment info
SELECT
    p.id AS payment_id,
    p.stripe_payment_id,
    p.amount,
    p.status,
    p.created_at,
    a.appointment_date,
    a.appointment_time,
    a.status AS appointment_status
FROM Payments p
JOIN Appointments a ON p.appointment_id = a.id;

-- Get appointments with the doctor's name
SELECT a.id, a.room_id, u.name AS doctor
FROM Appointments a
JOIN Doctors d ON a.doctor_id = d.id
JOIN Users u ON d.user_id = u.id;

-- Let’s just look at room and consultation status
SELECT consultation_status, room_id FROM Appointments;
