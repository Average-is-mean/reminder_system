from rest_framework import viewsets, status
from rest_framework.response import Response
from .models import Reminder
from .serializers import ReminderSerializer

class ReminderViewSet(viewsets.ModelViewSet):
    queryset = Reminder.objects.all()
    serializer_class = ReminderSerializer

    def create(self, request, *args, **kwargs):
        print("Received data:", request.data)

        serializer = self.get_serializer(data=request.data)
        if serializer.is_valid():
            self.perform_create(serializer)
            print("✅ Reminder created:", serializer.data)
            return Response(serializer.data, status=status.HTTP_201_CREATED)
        else:
            print("❌ Serializer errors:", serializer.errors)
            return Response(serializer.errors, status=status.HTTP_400_BAD_REQUEST)
