from django.db import models
from django.contrib.auth.models import User
from django.utils.timezone import now


class Reminder(models.Model):
    user = models.ForeignKey(User, on_delete=models.CASCADE)
    message = models.TextField()
    datetime_to_remind = models.DateTimeField(default=now)
    recurrence = models.CharField(max_length=10, choices=[
        ('once', 'Once'), 
        ('daily', 'Daily'), 
        ('monthly', 'Monthly'), 
        ('yearly', 'Yearly')
    ])
    email = models.EmailField()
    is_sent = models.BooleanField(default=False)
    created_at = models.DateTimeField(auto_now_add=True)

    def __str__(self):
        return f"{self.user.username} - {self.message[:20]}"
