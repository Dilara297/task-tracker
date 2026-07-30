from django.urls import path
from .views import home, edit_task, delete_task

urlpatterns=[
    path("",home,name="home"),
    path("edit/<int:id>/", edit_task, name="edit"),
    path("delete/<int:id>/",delete_task, name="delete")
]