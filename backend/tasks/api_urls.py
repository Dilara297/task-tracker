from django.urls import path,include
from rest_framework.routers import DefaultRouter
from .views import TaskViewSet,LoginAPIView

router =DefaultRouter()
router.register(r'tasks',TaskViewSet,basename='task')

urlpatterns = [
    path('login/', LoginAPIView.as_view(), name='api_login'),#APIView
    path('',include(router.urls)), #viewset
]
