import os
import django
import time
import datetime
from django.utils import timezone
import logging

# Setup Django environment
os.environ.setdefault('DJANGO_SETTINGS_MODULE', 'reminder_system.settings')
django.setup()

from reminder_app.models import Reminder
from django.conf import settings
from django.core.mail import EmailMultiAlternatives
from pathlib import Path

BASE_DIR = Path(__file__).resolve().parent

# Set up a logger for email failures
LOG_DIR = os.path.join(BASE_DIR, 'logs')
os.makedirs(LOG_DIR, exist_ok=True)

logging.basicConfig(
    filename=os.path.join(LOG_DIR, 'email_failures.log'),
    level=logging.ERROR,
    format='%(asctime)s [%(levelname)s] %(message)s',
)

print(timezone.now())



def send_reminder(reminder, max_retries=3):
    attempt = 0
    while attempt < max_retries:
        try:
            subject = '⏰ Reminder Notification'
            from_email = settings.EMAIL_HOST_USER
            to_email = reminder.email
            text_content = reminder.message
            html_content = f"""
                <html>
                  <body style="font-family: Arial, sans-serif; background-color: #f9f9f9; padding: 20px;">
                    <div style="max-width: 600px; background: white; padding: 20px; border-radius: 8px; box-shadow: 0 2px 5px rgba(0,0,0,0.1);">
                      <h2 style="color: #333;">🔔 Reminder</h2>
                      <p><strong>Message:</strong> {reminder.message}</p>
                      <p><strong>Scheduled Time:</strong> {reminder.datetime_to_remind.astimezone().strftime('%d %b %Y, %I:%M %p')}</p>
                      <p style="color: gray;">This reminder was sent to <b>{reminder.email}</b> by your Reminder System.</p>
                    </div>
                  </body>
                </html>
            """

            msg = EmailMultiAlternatives(subject, text_content, from_email, [to_email])
            msg.attach_alternative(html_content, "text/html")
            msg.send()

            reminder.is_sent = True
            reminder.save()

            # Handle recurrence
            if reminder.recurrence != 'once':
                next_time = calculate_next_time(reminder.datetime_to_remind, reminder.recurrence)
                Reminder.objects.create(
                    user=reminder.user,
                    message=reminder.message,
                    datetime_to_remind=next_time,
                    recurrence=reminder.recurrence,
                    email=reminder.email
                )

            print(f"[SENT] Reminder to {reminder.email} at {timezone.now()}")
            break  # exit loop on success

        except Exception as e:
            attempt += 1
            print(f"[FAILED ATTEMPT {attempt}] Reminder to {reminder.email}: {e}")
            logging.error(f"Reminder ID {reminder.id} to {reminder.email} failed on attempt {attempt}: {e}")

            if attempt == max_retries:
                logging.error(f"FINAL FAILURE: Reminder ID {reminder.id} could not be sent after {max_retries} attempts.")


def calculate_next_time(current, recurrence):
    if recurrence == 'daily':
        return current + datetime.timedelta(days=1)
    elif recurrence == 'monthly':
        return current + datetime.timedelta(days=30)  # Approximation
    elif recurrence == 'yearly':
        return current + datetime.timedelta(days=365)
    return current

def run_scheduler():
    while True:
        now = timezone.now()
        print(f"[{now}] Checking for due reminders...")

        due_reminders = Reminder.objects.filter(is_sent=False, datetime_to_remind__lte=now)
        print(f"Found {due_reminders.count()} due reminders.")

        for reminder in due_reminders:
            print(f"Processing reminder ID {reminder.id} for {reminder.email} at {reminder.datetime_to_remind}")
            send_reminder(reminder)

        time.sleep(60)


if __name__ == '__main__':
    print("Scheduler started...")
    run_scheduler()
