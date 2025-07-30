from rest_framework import serializers
from .models import Reminder
from django.contrib.auth.models import User

class ReminderSerializer(serializers.ModelSerializer):
    user = serializers.PrimaryKeyRelatedField(queryset=User.objects.all(), required=False)

    class Meta:
        model = Reminder
        fields = '__all__'
