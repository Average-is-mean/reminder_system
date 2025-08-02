📅 Reminder App
A full-stack Reminder System built with Flutter (frontend) and Django REST Framework (backend), featuring secure JWT authentication, SMTP-based email notifications, user-specific data handling, and a custom cron + systemd-based scheduler for automated reminder dispatch.

🚀 Features
🔐 JWT-based user authentication (Signup/Login)

📧 Email reminder delivery using SMTP

📱 Flutter frontend with dynamic reminder creation/deletion

👤 User-specific reminder management

⏰ Recurrence support: once, daily, monthly, yearly

⚙️ Scheduler using cron and systemd for sending due reminders

🐳 Dockerized architecture with PostgreSQL

🔒 Secure token storage using shared_preferences

🛠️ Tech Stack
Layer	Technology
Frontend	Flutter
Backend	Django + Django REST Framework
Auth	JWT (SimpleJWT)
Database	PostgreSQL
Scheduler	Cron Jobs + systemd
Email	SMTP (Gmail or custom provider)
Deployment	Docker Compose
Token Storage	Shared Preferences (Flutter)

🧱 Architecture
Flutter App
   └── Login / Signup (JWT)
   └── Reminder List (GET)
   └── Create Reminder (POST)
   └── Delete Reminder (DELETE)
        │
Django REST Backend
   └── JWT Auth (SimpleJWT)
   └── PostgreSQL (User, Reminder Models)
   └── Email sender
        │
Scheduler (cron + systemd)
   └── Django command runs every minute
   └── Sends due reminders via email

🔧 Setup Instructions
1. Clone the repository
   git clone https://github.com/yourusername/reminder-app.git
   cd reminder-app
2. Setup Environment Variables
Create a .env file in the backend root:
POSTGRES_DB=reminder_db
POSTGRES_USER=postgres
POSTGRES_PASSWORD=yourpassword
DB_HOST=db
DB_PORT=5432

EMAIL_HOST=smtp.gmail.com
EMAIL_PORT=587
EMAIL_USE_TLS=True
EMAIL_HOST_USER=your_email@gmail.com
EMAIL_HOST_PASSWORD=your_app_password
3. Start Backend & DB (Dockerized)
docker-compose up --build
The backend will be available at http://localhost:8000/
4. Setup Flutter Frontend
cd flutter_frontend
flutter pub get
flutter run -d chrome
Update .env in Flutter with:
API_BASE_URL=http://localhost:8000/api/

📤 SMTP Setup
Use Gmail App Passwords
Or configure any custom SMTP provider.

🔁 Scheduler Setup (Cron + Systemd)
Add cron entry:
* * * * * /path/to/reminder_system/send_reminders.sh >> /var/log/reminders.log 2>&1
send_reminders.sh should contain:
#!/bin/bash
cd /path/to/project
source venv/bin/activate
python manage.py send_due_reminders
Enable service on reboot using systemd.

🔐 Authentication
Uses rest_framework_simplejwt for secure token-based auth
Tokens stored via shared_preferences in Flutter
Auto-refresh supported via /api/token/refresh/

✨ Learnings
JWT token handling across mobile/web
Email delivery via Gmail SMTP securely
Docker orchestration with volume/env support
Persistent scheduler using systemd
User-specific data filtering using Django ViewSets
Debugging and logging across frontend & backend
Secure user management without exposing credentials

📄 License
MIT License
