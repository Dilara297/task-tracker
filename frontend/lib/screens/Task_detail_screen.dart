import 'package:flutter/material.dart';
import 'package:gorev_takip_flutter/models/task.dart';
import 'package:gorev_takip_flutter/services/api_service.dart';

class TaskDetailScreen extends StatefulWidget {
  final Task task;

  const TaskDetailScreen({
    super.key,
    required this.task,//bu ekran oluşturulurken task verilmek zorunda
    });

  @override
  State<TaskDetailScreen> createState() => _TaskDetailScreenState();
}

class _TaskDetailScreenState extends State<TaskDetailScreen> {

  final ApiService apiService = ApiService();
  final TextEditingController titleController = TextEditingController();
  final TextEditingController descriptionController = TextEditingController();
  bool isSaving= false;
  bool isDeleting=false;


  @override
  void initState(){
    super.initState();

    titleController.text =widget.task.title;
    descriptionController.text=widget.task.description;
  }
  @override
  void dispose(){
    titleController.dispose();
    descriptionController.dispose();
    super.dispose();
  }
@override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(title: Text("Görev Detayları"),),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                children: [

                  TextField(
                    controller: titleController,
                    decoration: InputDecoration(
                      labelText: "Görev başlıgı",
                      border: OutlineInputBorder(),
                    ),
                    style: const TextStyle(
                      fontSize: 20,
                   ),
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  TextField(
                    controller: descriptionController,
                    decoration: InputDecoration(
                      labelText: "Açıklama",
                      border: OutlineInputBorder(),
                    ),
                    maxLines: 4,
                  ),
                  SizedBox(
                    height: 16,
                  ),
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.deepPurple,
                        foregroundColor: Colors.white,
                      ),
                      onPressed: isSaving
                        ?null
                        : () async {
                          setState((){//kaydetme başladı
                           isSaving = true;
                         });
                          try{
                            await apiService.updateTask( 
                              widget.task.id,
                            titleController.text,
                              descriptionController.text,
                              widget.task.completed,
                          );
                            Navigator.pop(context,true);

                         }catch(e){
                            setState(() {//kaydetme bitti
                              isSaving=false;
                            });

                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content: Text("görev güncellenemedi"),
                                ),
                            );
                          }
                    }, 
                child: isSaving
                      ?const SizedBox(//true ise dönen yuvarlak loding işareti 
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(),
                      )
                      : const Text("KAYDET"),//false ise kaydet yazısı olacak
                      )
                  ),
                  ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.deepPurple,
          foregroundColor: Colors.white,
          onPressed:isDeleting
            ?null
            :()async{
              showDialog(
                context: context,
                builder: (context){
                  return AlertDialog(
                    title: const Text("Görevi sil"),
                    content: const Text("Bu görevi silmek istediginize emin misiniz?"),
                    actions: [

                      TextButton(
                        onPressed: (){
                          Navigator.pop(context);
                        }, 
                      child: const Text("HAYIR"),),

                      TextButton(
                        onPressed: ()async{
                          Navigator.pop(context);// alertdiagamı yani silmek istediginize eminmisiniz sorusunu kapatır

                          setState(() {
                            isDeleting=true;
                          });

                          try{
                            await apiService.deleteTask(widget.task.id);
                            Navigator.pop(context,true);
                          }catch(e){
                            setState(() {
                              isDeleting=false;
                            });
                            ScaffoldMessenger.of(context).showSnackBar(
                              const SnackBar(
                                content:Text("görev silinemedi"),
                              ),
                              );

                          }
                         
                      }, 
                      child: const Text("EVET"),),
                  ],
                );
               },
              );
          },
          child: isDeleting
            ?const SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(),
            )
          :const Icon(Icons.delete),
          ),
    );
  }
}