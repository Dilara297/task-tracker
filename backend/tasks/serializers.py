from rest_framework import serializers
from .models import Task

class TaskSerializer(serializers.ModelSerializer):
    class Meta:
        model = Task
        fields = '__all__'

    def validate_title(self, value):
        if len(value) < 3:
            raise serializers.ValidationError("Başlık en az 3 karakter olmalı.")
        return value

    def validate(self, data):
        if data['completed'] and not data['description']:
            raise serializers.ValidationError("Tamamlanan görevlerde açıklama boş bırakılamaz.")
        return data