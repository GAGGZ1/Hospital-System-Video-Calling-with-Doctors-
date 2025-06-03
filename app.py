from flask import Flask, render_template, request, redirect, url_for, session, flash
from flask_mysqldb import MySQL
import config
import stripe
from flask_stripe import Stripe
import time
time.tzset()  #for using system time-zone
import secrets


app = Flask(__name__)

stripe.api_key = config.STRIPE_SECRET_KEY
Stripe(app)



# MySQL configuration from config.py
app.config['MYSQL_HOST'] = config.MYSQL_HOST
app.config['MYSQL_USER'] = config.MYSQL_USER
app.config['MYSQL_PASSWORD'] = config.MYSQL_PASSWORD
app.config['MYSQL_DB'] = config.MYSQL_DB
mysql = MySQL(app)


# homepage
@app.route('/')
def index():
    return render_template('index.html')


# user registration page
@app.route('/register', methods=['GET', 'POST'])
def register():
    if request.method == 'POST':
        name = request.form['name']
        email = request.form['email']
        password = request.form['password']
        role = request.form['role']

        cur = mysql.connection.cursor()
        cur.execute("INSERT INTO Users (name, email, password, role) VALUES (%s, %s, %s, %s)",
                    (name, email, password, role))

        if role == 'doctor':
            user_id = cur.lastrowid
            cur.execute("INSERT INTO Doctors (user_id, specialization, bio) VALUES (%s, %s, %s)",
                        (user_id, request.form['specialization'], request.form['bio']))

        mysql.connection.commit()
        cur.close()
        flash('Registration successful!', 'success')
        return redirect(url_for('login'))
    return render_template('register.html')


# user login page
@app.route('/login', methods=['GET', 'POST'])
def login():
    if request.method == 'POST':
        email = request.form['email']
        password = request.form['password']

        cur = mysql.connection.cursor()
        cur.execute("SELECT * FROM Users WHERE email = %s AND password = %s", (email, password))
        user = cur.fetchone()
        cur.close()

        if user:
            session['user_id'] = user[0]
            session['role'] = user[4]
            flash('Login successful!', 'success')
            return redirect(url_for('dashboard'))
        else:
            flash('Invalid credentials!', 'danger')
    return render_template('login.html')

# user dashboard page
@app.route('/dashboard')
def dashboard():
    if 'user_id' not in session:
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()
    if session['role'] == 'patient':
        cur.execute("""
            SELECT a.id, a.patient_id, u.name as doctor_name, 
                a.date, a.time, a.status
            FROM Appointments a
            JOIN Doctors d ON a.doctor_id = d.id
            JOIN Users u ON d.user_id = u.id
            WHERE a.patient_id = %s
            ORDER BY a.date, a.time
        """, (session['user_id'],))
    elif session['role'] == 'doctor':
        cur.execute("""
            SELECT a.id, a.doctor_id, u.name as patient_name,
                a.date, a.time, a.status
            FROM Appointments a
            JOIN Users u ON a.patient_id = u.id
            WHERE a.doctor_id = %s
            ORDER BY a.date, a.time
        """, (session['user_id'],))

    appointments = cur.fetchall()
    cur.close()
    return render_template('dashboard.html', appointments=appointments)

# User appointment booking route
@app.route('/book_appointment', methods=['GET', 'POST'])
def book_appointment():
    if 'user_id' not in session or session['role'] != 'patient':
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()
    cur.execute("SELECT * FROM Doctors WHERE approval_status = 'approved'")
    doctors = cur.fetchall()

    if request.method == 'POST':
        # Store appointment data in session BEFORE payment
        session['temp_appointment'] = {
            'doctor_id': request.form['doctor_id'],
            'date': request.form['date'],
            'time': request.form['time']
        }

        # Create Stripe session
        checkout_session = stripe.checkout.Session.create(
            payment_method_types=['card'],
            line_items=[{
                'price_data': {
                    'currency': 'usd',
                    'product_data': {'name': 'Doctor Appointment'},
                    'unit_amount': 2000,  # $20.00
                },
                'quantity': 1,
            }],
            mode='payment',
            success_url=url_for('payment_success', _external=True) + '?session_id={CHECKOUT_SESSION_ID}',
            cancel_url=url_for('book_appointment', _external=True),
        )
        return redirect(checkout_session.url, code=303)

    return render_template('book_appointment.html', doctors=doctors)

# payment route

@app.route('/payment_success')
def payment_success():
    try:
        stripe_session_id = request.args.get('session_id')
        if not stripe_session_id:
            flash('Payment verification failed', 'danger')
            return redirect(url_for('book_appointment'))

        stripe_session = stripe.checkout.Session.retrieve(stripe_session_id)
        if stripe_session.payment_status != 'paid':
            flash('Payment not completed', 'danger')
            return redirect(url_for('book_appointment'))

        if 'temp_appointment' not in session:
            flash('Session expired', 'danger')
            return redirect(url_for('book_appointment'))

        temp_data = session.pop('temp_appointment')
        cur = mysql.connection.cursor()

        # Insert appointment
        cur.execute(
            """INSERT INTO Appointments 
            (patient_id, doctor_id, date, time, status) 
            VALUES (%s, %s, %s, %s, 'booked')""",
            (session['user_id'], temp_data['doctor_id'], temp_data['date'], temp_data['time'])
        )
        appointment_id = cur.lastrowid

        # Record payment
        cur.execute(
            """INSERT INTO Payments 
            (appointment_id, stripe_payment_id, amount, status) 
            VALUES (%s, %s, %s, 'completed')""",
            (appointment_id, stripe_session.payment_intent, 2000)
        )
        room_id = f"room_{appointment_id}_{secrets.token_hex(8)}"
        cur.execute("UPDATE Appointments SET room_id = %s WHERE id = %s", (room_id, appointment_id))

        mysql.connection.commit()
        flash('Appointment booked successfully!', 'success')
        return redirect(url_for('dashboard'))

    except Exception as e:
        mysql.connection.rollback()
        flash(f'Error: {str(e)}', 'danger')
        return redirect(url_for('book_appointment'))
    finally:
        if 'cur' in locals():
            cur.close()

# Logout
@app.route('/logout')
def logout():
    session.clear()
    flash('You have been logged out.', 'info')
    return redirect(url_for('index'))


# Cancel Appointment
@app.route('/cancel/<int:appointment_id>')
def cancel_appointment(appointment_id):
    if 'user_id' not in session:
        return redirect(url_for('login'))

    cur = mysql.connection.cursor()
    cur.execute("UPDATE Appointments SET status = 'cancelled' WHERE id = %s", (appointment_id,))
    mysql.connection.commit()
    cur.close()
    flash('Appointment cancelled!', 'success')
    return redirect(url_for('dashboard'))


@app.route('/stripe_webhook', methods=['POST'])
def webhook():
    event = None
    payload = request.data
    sig_header = request.headers['STRIPE_SIGNATURE']
    try:
        event = stripe.Webhook.construct_event(
            payload, sig_header, config.STRIPE_WEBHOOK_SECRET
        )
    except Exception as e:
        return jsonify(error=str(e)), 400
    return jsonify(success=True), 200


@app.route('/complete/<int:appointment_id>')
def complete_appointment(appointment_id):
    if 'user_id' not in session:
        return redirect('/login')

    cursor = mysql.connection.cursor()
    cursor.execute("UPDATE appointments SET status = 'completed' WHERE id = %s", (appointment_id,))
    mysql.connection.commit()
    cursor.close()

    return redirect('/dashboard')



if __name__ == '__main__':
    app.run(debug=True)

