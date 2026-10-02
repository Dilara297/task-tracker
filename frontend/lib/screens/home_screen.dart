import 'package:flutter/material.dart';
import 'package:gorev_takip_flutter/screens/LoginScreen.dart';
import 'package:gorev_takip_flutter/screens/add_task.screen.dart';
import 'package:gorev_takip_flutter/services/api_service.dart';
import 'package:gorev_takip_flutter/models/task.dart';
import 'package:gorev_takip_flutter/services/auth_service.dart';
import 'package:gorev_takip_flutter/widgets/task_card.dart';
import 'package:gorev_takip_flutter/screens/profil_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Task> tasks = [];

  bool isLoading = true;

  String? errorMessage;

  final ApiService apiService = ApiService();

  @override
  void initState() {
    super.initState();
    loadTasks();
  }

  Future<void> loadTasks() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      final gelenTasks = await apiService.getTasks();

      if(!mounted) return;//bu state hala ekranda mevcutmu?

      setState(() {
        tasks = gelenTasks;
        isLoading = false;
      });
    } catch (e) {
      if(!mounted) return;
      setState(() {
        errorMessage = "Görevler yüklenemedi. Tekrar deneyiniz.";
        isLoading = false;
      });
    }
  }
  Widget buildTaskCard(Task task){
    return TaskCard(
      task: task, 
      apiService: apiService, 
      onTaskUpdated: ()async{
        await loadTasks();
      },
    );
  }
  Widget buildEmptyState({
    required IconData icon,
    required String title,
    String? description,
    required Color backgroundColor,
    required Color iconColor,
  }){
    return Padding(
      padding: const  EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Column(
          children: [
            Icon(
              icon,
              size: 42,
              color: iconColor,
            ),
            const SizedBox(height: 12),
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.w600,
              ),
            ),
            if (description!=null) ...[
              const SizedBox(height: 6),
              Text(
                description,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: Colors.grey,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
  @override
  Widget build(BuildContext context) {

    final activeTasks=tasks.where((task)=> !task.completed).toList();
      
    final completedTasks=tasks.where((task)=> task.completed).toList();

    Widget body;

    if (isLoading) {
      body = const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text("Görevler Yükleniyor..."),
          ],
        ),
      );
    } else if (errorMessage != null) {
      body = Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
             const Icon(
                Icons.error,
                size: 48,
                color: Colors.amberAccent,
            ),
            const SizedBox(height: 16),
            const Text("HATA OLUŞTU"),

            const SizedBox(height: 16),
            Text(errorMessage!),

            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: ()async{
                await loadTasks();
            }, 
            child: const Text("TEKRAR DENE"),
            ),
          ],
        ),
      );
    } else if (tasks.isEmpty) {
      body = Container(
        width: double.infinity,
        height: double.infinity,
        color: const Color(0xFFF8F5FF),
        child:Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 96,
                height: 96,
                decoration: BoxDecoration(
                  color: Colors.deepPurple.shade50,
                  shape: BoxShape.circle,
                ),
                child:const Icon(
                Icons.assignment_outlined,
                size: 48,
                color: Colors.deepPurple,
            ),
            
            ),
            const SizedBox(height: 16),
            const Text(
              "Henüz Görev Yok",
              style: TextStyle(
                fontSize:22,
              fontWeight:FontWeight.w600,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              "İlk görevini ekleyerek başlayabilirsin",
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: ()async{
                 await Navigator.push(
                  context, 
                  MaterialPageRoute(builder: (context)=> const AddTaskScreen(),),);
                  await loadTasks();
            }, 
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.add),
                const SizedBox(width: 8),
                const Text("GÖREV EKLE"),
              ],
            ),
            ),
          ],
          ),
        ),
      );
    } else {
      body = ListView(// 2 card kullanabilmek için bu yapıyı kullandık .builder tek card kabul ediyor
        children:[
          const Padding(padding: EdgeInsets.fromLTRB(16, 20, 16, 8),
          child: Text(
            "DEVAM EDEN GÖREVLER",
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
          if(activeTasks.isEmpty)
          buildEmptyState(
            icon: Icons.check_circle_outline, 
            title: "Tüm görevlerin tamamlandı!", 
            description: "Yeni bir görev ekleyerek devam edebilirsin",
            backgroundColor: Colors.deepPurple.shade50, 
            iconColor: Colors.deepPurple,
            ),
          if(activeTasks.isNotEmpty)
          ...activeTasks.map(buildTaskCard),
            
      const SizedBox(height:24),

      const Padding(
      padding: EdgeInsets.fromLTRB(16, 8, 16, 8),
      child: Text(
        "TAMAMLANAN GÖREVLER",
        style: TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold,
        ),
        ),
      ),
      if(completedTasks.isEmpty)
      buildEmptyState(
        icon: Icons.assignment_outlined, 
        title: "Henüz tamamlanan görev yok", 
        backgroundColor: Colors.grey.shade100, 
        iconColor: Colors.grey,
        ),

      if (completedTasks.isNotEmpty)
      ...completedTasks.map(buildTaskCard), 
    ],
  );
}
    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            tooltip: "profile",
            onPressed: (){
              Navigator.push(
                context, 
                MaterialPageRoute(builder: (context)=> const ProfileScreen(),
                ),
              );
            }, 
            icon: const Icon(Icons.person),
            ),
          IconButton(
            tooltip: "Çıkış Yap",
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) {
                  return AlertDialog(
                    title: const Text("Çıkış yap"),
                    content: const Text(
                      "Çıkış yapmak istediğinize emin misiniz?",
                    ),
                    actions: [
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: const Text("HAYIR"),
                      ),
                      TextButton(
                        onPressed: () async {
                          final authService = AuthService();

                          await authService.logout();

                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const Loginscreen(),
                            ),
                          );
                        },
                        child: const Text("EVET"),
                      ),
                    ],
                  );
                },
              );
            },
            icon: const Icon(Icons.logout),
          ),
        ],
      ),

      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20,24,20,16),
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.center,
              children: [
                const Text(
                  "GÖREVLER",
                  style: TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 6),

                Text(
                  "${tasks.length} görev",
                  style: const TextStyle(
                    fontSize: 15,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ),

          Expanded(
            child: body,
          ),
        ],
      ),

      floatingActionButton: tasks.isEmpty
      ?null
      :FloatingActionButton(
        backgroundColor: Colors.deepPurple,
        elevation: 4,
        tooltip: "Görev Ekle",
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
        ),
        onPressed: () async {
          await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) =>const AddTaskScreen(),
            ),
          );
          await loadTasks();
        },
        child: const Icon(Icons.add,color: Colors.white),
      ),
    );
  }
}