from rest_framework import serializers
from .models import Task

class TaskSerializer(serializers.ModelSerializer):
    owner = serializers.PrimaryKeyRelatedField(read_only=True)
    #owner apiden okunabilir ama istemciden gönderilmesi beklenemez


    class Meta:
        model = Task
        fields = '__all__'

    def validate_title(self, value):
        if len(value) < 3:
            raise serializers.ValidationError("Başlık en az 3 karakter olmalı.")
        return value

    def validate(self, data):
        completed= data.get('completed', False)
        
        description= data.get(
            'description',
            self.instance.description if self.instance else''
        )
        if completed and not description:
            raise serializers.ValidationError(
                "tamamlanan görevlerde açıklama boş bırakılamaz"
            )
        return data
    # data ['ompleted'] anahtar kesinikle varmış gibi davranır
    # data.get('completed',False) varsa alır yoksa false kullanılır