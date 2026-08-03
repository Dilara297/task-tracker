import 'package:flutter/material.dart';
import 'package:gorev_takip_flutter/services/api_service.dart';
import 'package:gorev_takip_flutter/models/task.dart';


class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {

List<Task> tasks= [];


  @override
  void initState(){
    super.initState();
    loadTasks();

  }
  Future<void> loadTasks() async{
    ApiService api= ApiService();// api ile  konuşacak nesneyi oluştur

    final gelenTasks = await api.getTasks();//djangodan görev listesini bekle

    setState(() {
      tasks =gelenTasks;//gelen görevleri homescreenin hafızasına koy
    });

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar:AppBar(
        title: Text("görevler"),
      ) ,
      body: ListView.builder(
        itemCount: tasks.length,
        itemBuilder:(context,index){
          return ListTile(
            title: Text(tasks[index].title),
            subtitle: Text(tasks[index].description),
            trailing: Icon(
              tasks[index].completed
                  ?Icons.check_circle
                  :Icons.radio_button_unchecked,
            ),
          );
        } ,),
    );
  }
  }
