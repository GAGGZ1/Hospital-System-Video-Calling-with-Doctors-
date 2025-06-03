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
│   └── **init**.py
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

*Add screenshots of login, booking, doctor dashboard, and payment screens here.*

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
