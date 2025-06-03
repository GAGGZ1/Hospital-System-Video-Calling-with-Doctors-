# 🏥 Hospital System with Video Calling and Online Appointments

A full-stack web application that allows **patients** and **doctors** to register, log in, schedule video consultations, and manage appointments. Integrated with **Stripe** for secure payment processing.

---

## 🚀 Features

### 👤 User Authentication
- 🔐 **Registration & Login** for both patients and doctors.
- 🚪 **Logout functionality** to end user sessions securely.
- 🧑‍⚕️ Role-based access for **Doctors** and **Patients**.

### 🗓️ Appointment System
- 📅 Patients can **book appointments** with available doctors.
- 📌 Patients can **check appointment booking status**.
- 📥 Doctors can **view their appointment list** in the dashboard.

### 💳 Stripe Payment Integration
- 💰 Patients pay **consultation fees** during the booking process.
- ✅ Secure Stripe payment before appointment confirmation.

### 📹 Video Consultation (Upcoming)
- Planned integration of **real-time video calling** between doctors and patients using WebRTC or similar technologies.

---

## 📁 Project Structure

```

Hospital-System-Video-Calling-with-Doctors-/
├── app/
│   ├── templates/
│   ├── static/
│   ├── routes/
│   ├── models/
├── config.py
├── requirements.txt
├── app.py
└── README.md

````

---

## ⚙️ Technologies Used

- Backend: Python, Flask, MySQL
- Frontend: HTML, CSS, JavaScript
- Database: MySQL  
- Authentication: Flask-Login  
- Payments: Stripe API

---

## 🧪 Setup Instructions

### 1. Clone the Repository

```bash
git clone https://github.com/GAGGZ1/Hospital-System-Video-Calling-with-Doctors-.git
cd Hospital-System-Video-Calling-with-Doctors-
````

### 2. Create and Activate a Virtual Environment

```bash
python -m venv venv
source venv/bin/activate  # Windows: venv\Scripts\activate
```

### 3. Install Dependencies

```bash
pip install -r requirements.txt
```

### 4. Configure Environment Variables

Update the `config.py` file with your credentials:

```python
MYSQL_HOST = "your_host"
MYSQL_USER = "your_user"
MYSQL_PASSWORD = "your_password"
MYSQL_DB = "your_db"

STRIPE_PUBLIC_KEY = "your_stripe_public_key"
STRIPE_SECRET_KEY = "your_stripe_secret_key"
SECRET_KEY = "your_flask_secret_key"
```

### 5. Run the App

```bash
python app.py
```

---

## 📸 Screenshots

1. <img width="1512" alt="Screenshot 2025-06-03 at 4 57 29 PM" src="https://github.com/user-attachments/assets/e1468636-e3ed-4a14-8fd7-a0097379611b" />
2. <img width="1512" alt="Screenshot 2025-06-03 at 4 57 39 PM" src="https://github.com/user-attachments/assets/24517d3c-835e-495c-9b7f-6ac603a18df7" />
3. <img width="1511" alt="Screenshot 2025-06-03 at 4 57 50 PM" src="https://github.com/user-attachments/assets/6184d055-71e0-4b31-b7b1-47b0da0ec81e" />
4. <img width="1511" alt="Screenshot 2025-06-03 at 4 58 00 PM" src="https://github.com/user-attachments/assets/1a1bc0b9-14eb-4ca4-a2b7-7e5ec970fdb1" />
5. <img width="1511" alt="Screenshot 2025-06-03 at 4 58 14 PM" src="https://github.com/user-attachments/assets/4fcdccfc-b231-460f-943e-1b0fffbbcb36" />
6. <img width="1486" alt="Screenshot 2025-06-03 at 4 58 30 PM" src="https://github.com/user-attachments/assets/807d2d1a-b302-47e8-be2e-e0918a57536d" />
7. <img width="1481" alt="Screenshot 2025-06-03 at 4 58 48 PM" src="https://github.com/user-attachments/assets/9eaf521b-ac5f-405d-bb90-c91770cc762b" />
8. <img width="1457" alt="Screenshot 2025-06-03 at 4 58 55 PM" src="https://github.com/user-attachments/assets/3ae88e2a-7c56-4dfc-9ad3-babc13c0264f" />


---

## 📌 Roadmap

* [x] Patient/Doctor Registration & Login
* [x] Appointment Booking & Viewing
* [x] Stripe Integration for Payment
* [ ] Real-time Video Consultation
* [ ] Admin Panel for Managing Users
* [ ] Email Notifications & Reminders

---

## 🤝 Contributing

Contributions are welcome! Please fork the repo and submit a pull request.

---

## 📃 License

This project is licensed under the [MIT License](LICENSE).

---

## 💬 Contact

* GitHub: [@GAGGZ1](https://github.com/GAGGZ1)
* Email: [chauhangagan117@gmail.com](mailto:chauhangagan117@gmail.com)
