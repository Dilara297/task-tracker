from rest_framework import viewsets
from .models import Task
from .serializers import TaskSerializer
from django.shortcuts import render,redirect,get_object_or_404

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
            completed=completed
        )
        return redirect("home")
    
    tasks=Task.objects.all()
    
    return render(
        request,
        "tasks/home.html",
        {"tasks": tasks}
    )
    
def edit_task(request,id):
    task = get_object_or_404(Task, id=id)
    
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
    
def delete_task(request,id):
    print(id)
    task=get_object_or_404(Task, id=id)
    if request.method=="POST":
        task.delete()
        return redirect("home")
    
    return redirect("home")

