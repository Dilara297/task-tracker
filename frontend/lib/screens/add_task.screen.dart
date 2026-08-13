import 'package:flutter/material.dart';
import 'package:gorev_takip_flutter/services/api_service.dart';

class AddTaskScreen extends StatefulWidget {
  const AddTaskScreen({super.key});

  @override
  State<AddTaskScreen> createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final TextEditingController titlecontroller =TextEditingController();
  final TextEditingController descriptioncontroller=TextEditingController();

  final ApiService apiService=ApiService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Yeni Görev"),
      ),
      body: Padding(
        padding:EdgeInsets.all(16),
        child: Column(
          children: [
            const Text("Başlık"),
            TextField(
              controller: titlecontroller,
              decoration: InputDecoration(
                hintText: "Görev Başlıgı",
              ),
            ),
            TextField(
              controller: descriptioncontroller,
              decoration: InputDecoration(
                hintText: "Açıklama",
              ),
            ),
            ElevatedButton(
              onPressed: () async{
                await apiService.addTask(
                  titlecontroller.text,
                  descriptioncontroller.text,
                );

                  titlecontroller.clear();
                  descriptioncontroller.clear();

                  Navigator.pop(context);
            }, 
            child: const Text("kaydet"),
            ),
          ],
        ),
        ),
      );
  }
}