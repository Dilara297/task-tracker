from django.urls import path
from .views import home, edit_task, delete_task,register, user_login,user_logout,ana_sayfa,profil,toggle_task

urlpatterns=[
    path("home/",home,name="home"),
    path("",ana_sayfa,name='ana_sayfa'),
    path("edit/<int:id>/", edit_task, name="edit"),
    path("delete/<int:id>/",delete_task, name="delete"),
    path("register/",register,name="register"),
    path("login/",user_login,name="login"),
    path("logout/",user_logout,name="logout"),
    path("profil/",profil,name="profil"),
    path("toggle/<int:id>/", toggle_task, name="toggle"),
]