import 'package:flutter/material.dart';
import 'package:gorev_takip_flutter/screens/LoginScreen.dart';
import 'package:gorev_takip_flutter/screens/add_task.screen.dart';
import 'package:gorev_takip_flutter/services/api_service.dart';
import 'package:gorev_takip_flutter/models/task.dart';
import 'package:gorev_takip_flutter/services/auth_service.dart';
import 'package:gorev_takip_flutter/screens/Task_detail_screen.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

List<Task> tasks= [];

bool isLoading = true;

String? errorMessage;

final ApiService apiService =ApiService();

  @override
  void initState(){
    super.initState();
    loadTasks();

  }
  Future<void> loadTasks() async{
    setState(() {
      isLoading=true;
      errorMessage=null;
    });
    try{
      final gelenTasks = await apiService.getTasks();//djangodan görev listesini bekle

      setState(() {
        tasks =gelenTasks;//gelen görevleri homescreenin hafızasına koy
        isLoading=false;
      });
      

    }catch (e){
      setState(() {
        errorMessage = "görevler yüklenemedi : tekrar deneyiniz";
        isLoading=false;
      });   
    }
  }
  @override
  Widget build(BuildContext context) {

    Widget body;

    if(isLoading){
      body=const Center(
        child: CircularProgressIndicator(),
      );

    }else if(errorMessage != null){
      body=Center(
        child : Text(errorMessage!),
      );

    }else if (tasks.isEmpty){
      body = const Center(
        child: Text("henüz görev eklenmemiş"),
      );

    }else{
      body= ListView.builder(
        itemCount: tasks.length,
        itemBuilder: (context,index){
          return ListTile(
            title: Text(tasks[index].title),
            subtitle: Text(tasks[index].description),

            onTap: ()async{
              final result =await Navigator.push(
                context, 
                MaterialPageRoute(builder: (context)=> TaskDetailScreen(
                  task: tasks[index],//listedeki seçilmiş tek task. sırayla taskleri alıyoruz
                  ),
                  ),
                  );
                  if(result==true){
                    await loadTasks();
                  }
            },
            trailing:Checkbox(
              value: tasks[index].completed, 
              onChanged: (bool? value) async {
                if(value != null){
                  final updatedTask =await apiService.updateTask(
                    tasks[index].id,
                    tasks[index].title,
                    tasks[index].description,
                    value,
                  );
                  setState(() {
                    tasks[index]=updatedTask;
                  });
                }
              },
              ),
          );
        },
      );
    }
    return Scaffold(
      appBar:AppBar(
        title: Text("görevler"),
        actions: [
          IconButton(
            onPressed: (){
              showDialog(
                context: context, 
                builder: (context){
                  return AlertDialog(
                    title: const Text("çıkış yap"),
                    content: const Text("çıkış yapmak istediginize emin misiniz?"),
                    actions: [

                      TextButton(onPressed: (){
                        Navigator.pop(context);
                      }, 
                      child: const Text("HAYIR"),
                      ),

                      TextButton(onPressed: () async{
                        final authService = AuthService();
                        await  authService.logout();

                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context)=> const Loginscreen(),
                            ),
                        );

                      }, 
                      child: const Text("EVET"),),
                    ],
                  );
                },
                );
          }, 
          icon: const Icon(Icons.logout),
          ),
        ],
      ) ,
      body:body,

      floatingActionButton:FloatingActionButton(
        onPressed: () async{
           await Navigator.push(
            context, 
            MaterialPageRoute(
              builder: (context)=> const AddTaskScreen(),
            ),
          );
          loadTasks();
        },
        child: const Icon(Icons.add),
        ),
    );
  } 
}
  
  //GENEL AKIŞ
  // HomeScreen açılır. initState() sadece bir kez çalışır 
  //ve loadTasks() çağrılır. loadTasks() içinde ApiService 
  //kullanılarak Django API'sine HTTP GET isteği gönderilir. 
  //Sunucudan gelen cevap önce response.body olarak String şeklindedir. 
  //jsonDecode() ile bu veri Dart'ın anlayacağı Map/List yapısına çevrilir.
  // Görevlerin bulunduğu results listesi alınır. Listenin her elemanı Task.fromJson() 
  //ile bir Task nesnesine dönüştürülür ve elimizde List<Task> oluşur. 
  //Bu liste HomeScreen'deki tasks değişkenine atanır. setState() çağrıldığı için
  // Flutter ekranın değiştiğini anlar ve build() metodunu tekrar çalıştırır.
  // ListView.builder da bu listedeki her görevi tek tek ekrana çizer.
