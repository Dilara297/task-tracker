from rest_framework import viewsets
from .models import Task
from .serializers import TaskSerializer
from django.shortcuts import render,redirect,get_object_or_404
from .forms import RegisterForm,LoginForm
from django.contrib.auth import login,logout
from django.contrib.auth.views import LoginView
from django.contrib.auth.decorators import login_required

class TaskViewSet(viewsets.ModelViewSet):
    serializer_class = TaskSerializer

    def get_queryset(self):
        queryset = Task.objects.all().order_by('-created_at')
        completed = self.request.query_params.get('completed')

        if completed == 'true':
            queryset = queryset.filter(completed=True)
        elif completed == 'false':
            queryset = queryset.filter(completed=False)

        return queryset

@login_required
def home(request):
    
    if request.method=="POST":
        title= request.POST.get("title")
        print(title)
        description=request.POST.get("description")
        print(description)
        completed=request.POST.get("completed")=="on"
        print(completed)
        

        Task.objects.create(
            title=title,
            description=description,
            completed=completed,
            owner=request.user
            
        )
        return redirect("home")
    
    todo_tasks = Task.objects.filter(
        owner=request.user,
        completed=False
    )

    completed_tasks = Task.objects.filter(
        owner=request.user,
        completed=True
    )
    
    return render(
        request,
        "tasks/home.html",
        {"todo_tasks":todo_tasks,
         "completed_tasks": completed_tasks}
    )
    
@login_required
def edit_task(request,id):
    task = get_object_or_404(Task, id=id,owner=request.user)
    
    if request.method=="POST":
        title =request.POST.get("title")
        description = request.POST.get("description")
        completed=request.POST.get("completed")=="on"
        
        task.title=title
        task.description=description
        task.completed=completed
        
        task.save()
        return redirect ("home")
    
    tasks=Task.objects.all()
    return render(
        request,
        "tasks/home.html",
        {
            "tasks":tasks,
            "edit_task":task
            }
    )
    
@login_required
def delete_task(request,id):
    print(id)
    task=get_object_or_404(Task, id=id,owner=request.user)
    if request.method=="POST":
        task.delete()
        return redirect("home")
    
    return redirect("home")


def register(request):
    if request.method=="POST":
        form=RegisterForm(request.POST)
        if form.is_valid():
            User=form.save()
            login(request,User)
            return redirect('home')
            
    else:
        form=RegisterForm()
    return render(request,"tasks/register.html",{"form":form})


def user_login(request):
    if request.method=="POST":
        form=LoginForm(request,data=request.POST)
        if form.is_valid():
            user=form.get_user()
            login(request,user)
            return redirect("home")
    else:
        form=LoginForm()
        
    return render(request,"tasks/login.html",{"form":form})

def user_logout(request):
    logout(request)
    return redirect("login")

def ana_sayfa(request):
    return render(request,"tasks/ana_sayfa.html")


@login_required
def profil(request):

    total_tasks = Task.objects.filter(owner=request.user).count()

    completed_tasks = Task.objects.filter(
        owner=request.user,
        completed=True
    ).count()

    todo_tasks= Task.objects.filter(
        owner=request.user,
        completed=False
    ).count()

    return render(
        request,
        "tasks/profil.html",
        {
            "user": request.user,
            "total_tasks": total_tasks,
            "completed_tasks": completed_tasks,
            "todo_tasks": todo_tasks
        }
    )
    


@login_required
def toggle_task(request, id):
    task = get_object_or_404(Task, id=id, owner=request.user)

    if request.method == "POST":
        task.completed = not task.completed
        task.save()

    return redirect("home")

