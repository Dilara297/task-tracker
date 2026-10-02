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
        child:Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [

                const Icon(
                  Icons.add_task,
                  size: 50,
                ),

                const SizedBox(height: 12),

                const Text(
                  "Yeni görev oluştur",
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text("Yapman gereken bir görev ekle"),

                const SizedBox(height: 24),

                TextField(
                  controller: titlecontroller,
                  decoration: InputDecoration(
                    labelText: "Görev Başlığı",
                    hintText: "Örneğin: İngilizce çalış",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 16),

                TextField(
                  controller: descriptioncontroller,
                  maxLines: 4,
                  decoration: InputDecoration(
                    labelText: "Açıklama",
                    hintText: "Görev hakkında kısa bir açıklama yazınız",
                    border: OutlineInputBorder(),
                  ),
                ),
                SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  child:ElevatedButton( 
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      foregroundColor: Colors.white,
                    ),
                    onPressed: () async{
                    await apiService.addTask(
                      titlecontroller.text,
                      descriptioncontroller.text,
                    );

                      titlecontroller.clear();
                      descriptioncontroller.clear();

                      Navigator.pop(context);
                }, 
                child: const Text("Görevi kaydet"),
                ),
                ),
              ],
            ),
            ),
        ),
      ),
      );
  }
}